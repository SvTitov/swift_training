import Foundation
import SwiftData

protocol ModelProtocol: Identifiable, Sendable where ID == UUID {
    associatedtype Entity: PersistentModel
    init(_ entity: Entity)
}

protocol EntityProtocol: AnyObject, Identifiable, PersistentModel where ID == UUID {
    associatedtype Model: ModelProtocol
    func update(_ model: Model)
    init(model: Model)
}

protocol PersistentRepositoryProtocol<Entity, Model>: Actor {
    associatedtype Entity: EntityProtocol
    associatedtype Model: ModelProtocol

    func insert(_ model: Model) throws
    func insertBatch(_ models: [Model]) async throws
    func fetch(predicate: Predicate<Entity>) throws -> [Model]
    func fetchAll() throws -> [Model]
    func delete(_ element: Model) throws
    func delete(predicate: Predicate<Entity>) throws
    func update(_ model: Model) throws
    func updateBatch(_ models: [Model]) throws
    func commit() throws
    func count() throws -> Int
}

@ModelActor
actor PersistentRepository<E: EntityProtocol, M: ModelProtocol>: PersistentRepositoryProtocol
where E.Model == M, M.Entity == E {
    typealias Entity = E
    typealias Model = M

    func insert(_ model: Model) throws {
        let entity = E.init(model: model)

        modelContext.insert(entity)
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }

    func insertBatch(_ models: [M]) async throws {
        if models.isEmpty { return }

        let batchSize = 500
        var index = 0

        while index < models.count {
            let end = min(index + batchSize, models.count)
            let batch = models[index..<end]
            
            for element in batch {
                let entity = E.init(model: element)
                modelContext.insert(entity)
            }
            
            try modelContext.save()
            
            index = end

            await Task.yield()
        }
    }

    func fetchAll() throws -> [M] {
        let desr = FetchDescriptor<E>()
        return try modelContext.fetch(desr)
            .map { M.init($0) }
    }

    func fetch(predicate: Predicate<Entity>) throws -> [Model]
    where Entity: PersistentModel {
        let fetchDescr = FetchDescriptor<Entity>(predicate: predicate)
        return try modelContext.fetch(fetchDescr).map { M.init($0) }
    }

    func delete(_ element: Model) throws {
        var descr = FetchDescriptor<Entity>()
        descr.fetchLimit = 1

        guard let entity = try modelContext.fetch(descr).first else {
            return
        }

        modelContext.delete(entity)
    }

    func delete(predicate: Predicate<Entity>) throws
    where Entity: PersistentModel {
        try modelContext.delete(
            model: Entity.self,
            where: predicate
        )
    }

    func commit() throws {
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }

    func update(_ model: Model) throws {
        let id = model.id
        let predicate = #Predicate<Entity> { $0.id == id }
        var descr = FetchDescriptor(predicate: predicate)
        descr.fetchLimit = 1

        guard let entity = try modelContext.fetch(descr).first else {
            return
        }

        entity.update(model)

        if entity.hasChanges {
            try modelContext.save()
        }
    }

    func count() throws -> Int {
        let descr = FetchDescriptor<Entity>()
        return try modelContext.fetchCount(descr)
    }

    func updateBatch(_ models: [M]) throws {
        let models = Dictionary(grouping: models, by: { $0.id })

        let keys = models.map { $0.key }
        let predicate = #Predicate<Entity> { keys.contains($0.id) }
        let descr = FetchDescriptor(predicate: predicate)
        let entities = Dictionary(grouping: try modelContext.fetch(descr), by: { $0.id })

        entities.forEach {
            guard let model = models[$0.key]?.first, let entity = $0.value.first else {
                return
            }

            entity.update(model)
        }

        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
}

actor PersistentRepositoryMock<E: EntityProtocol, M: ModelProtocol>: PersistentRepositoryProtocol
where E.Model == M, M.Entity == E {
    typealias Entity = E
    typealias Model = M

    func insert(_ model: M) throws {}

    func fetch(predicate: Predicate<E>) throws -> [M] { [] }

    func fetchAll() throws -> [M] { [] }

    func delete(_ element: M) throws {}

    func delete(predicate: Predicate<E>) throws {}

    func commit() throws {}

    func insertBatch(_ elements: [M]) throws {}

    func update(_ model: Model) throws {}

    func count() throws -> Int { -1 }

    func updateBatch(_ models: [M]) throws {}
}
