import SwiftUI

struct ContentView: View {
    var foo: Int = 5
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("New content")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
