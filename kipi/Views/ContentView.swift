//
//  ContentView.swift
//  kipi
//
//  Created by Ossi on 24/02/2024.
//

import SwiftUI
import SwiftData
import LocalAuthentication

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    
    // Security
    @ObservedObject var authController = AuthController()
    @State var userSuccessfullyAuthenticated: Bool = false
    @State private var biometricAvailable = true
    
    // Retrieves all the accounts
    @Query private var accounts: [Account]
    
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
            if newPhase == .active {
                print("App is active")
            } else if newPhase == .inactive {
                print("App is inactive")
            } else if newPhase == .background {
                print("App is in background")
            }
        }
    }
    
    func authenticate() {
        authController.authenticate { result in
            switch result {
            case .success(_):
                userSuccessfullyAuthenticated = true
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
