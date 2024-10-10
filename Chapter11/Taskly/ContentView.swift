//
//  ContentView.swift
//  Taskly
//
//  Created by Nathan Sebhastian on 20/09/24.
//

import SwiftUI

struct ContentView: View {
    let tasks = ["Task 1", "Task 2", "Task 3"]
    
    var body: some View {
        List(tasks, id: \.self) { task in
            Text(task)
        }
    }
}

#Preview {
    ContentView()
}
