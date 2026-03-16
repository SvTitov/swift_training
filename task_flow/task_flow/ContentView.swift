//
//  ContentView.swift
//  task_flow
//
//  Created by Svyatoslav Titov on 10.03.2026.
//

import SwiftUI

struct ContentView: View {
    var foo: Int = 5
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("New content")
                .onTapGesture {
                    let a = 5
                    let b = 6
                    print("HELLO")
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
