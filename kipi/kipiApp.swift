//
//  kipiApp.swift
//  kipi
//
//  Created by Ossi on 24/02/2024.
//

import SwiftUI
import SwiftData

@main
struct kipiApp: App {

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Account.self,
            Code.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
