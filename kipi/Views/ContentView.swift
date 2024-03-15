//
//  ContentView.swift
//  kipi
//
//  Created by Ossi on 24/02/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    
    // UserDefaults
    let defaults = UserDefaults.standard
    
    // Security
    @ObservedObject var authController = AuthController()
    @State var userSuccessfullyAuthenticated: Bool = false
    
    // Retrieves all the accounts
    @Query private var accounts: [Account]
    
    // Retrieves all the accounts that are not bookmarked
    @Query(filter: #Predicate<Account> { account in
        account.bookmarked == false
    }) private var notBookmarkedAccounts: [Account]
    
    @State var displayNewAccountView: Bool = false
    @State var searchText: String = ""


    var body: some View {
        VStack {
            if userSuccessfullyAuthenticated {
                AccountsList()
            } else {
                VStack {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.gray)
                    Text("Authenticate to unlock your data")
                        .bold()
                        .font(.system(size: 20))
                        .padding(5)
                    Button {
                        authenticate()
                    } label: {
                        Text("Unlock")
                    }
                }
            }
        }
        .onAppear(perform: authenticate)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            lockTheApp(phase: newPhase)
        }
    }
    
    /**
     func lockTheApp(phase: ScenePhase)
     Lock the app if it has been put in background for more than 30 seconds
     - Parameter ScenePhase phase
     */
    func lockTheApp(phase: ScenePhase) {
        if phase == .active {
            // Retrieves the last time the app went into background
            let appWentInBackgroundMode = defaults.object(forKey: "appWentInBackgroundMode") as? Date ?? Date()
            
            // Compares the the previously retrieved value with the current time
            let components = Calendar.current.dateComponents([.second], from: appWentInBackgroundMode, to: Date())
            
            if components.second! > 600 {
                // Shows the app lock screen and starts the authentication process
                userSuccessfullyAuthenticated = false
                print(userSuccessfullyAuthenticated ? "App is unlocked" : "App is locked")
                authenticate()
                print(userSuccessfullyAuthenticated ? "App is unlocked" : "App is locked")
            }
        } else if phase == .background {
            // Set the current time once the app enters background
            defaults.set(Date(), forKey: "appWentInBackgroundMode")
        }
    }
    
    
    /**
     func authenticate()
     Starts the authentication process
    */
    func authenticate() {
        authController.authenticate { result in
            switch result {
            case .success(_):
                userSuccessfullyAuthenticated = true
                defaults.set(Date(), forKey: "appWentInBackgroundMode")
            case .failure(_):
                userSuccessfullyAuthenticated = false
            }
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
