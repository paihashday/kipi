//
//  AccountView.swift
//  kipi
//
//  Created by Ossi on 24/02/2024.
//

import SwiftUI
import SwiftData

struct AccountView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @State private var navigationPath = NavigationPath()
    
    var account: Account
    
    @State var prout: Bool = false
    
    // Account deletion
    @State private var deleteTaps: Int = 0
    @State private var showAccountDeleteConfirmationDialog: Bool = false
    @State private var accountNameConfirmation: String = ""
    
    // Codes deletion
    @State private var showCodeDeleteConfirmationDialog: Bool = false
    @State private var selectedCodeToDelete: Code?
    
    // New codes
    @State private var showNewCodesView: Bool = false
    @State var newCodes: [Code] = []
    
    // Account edition
    @State var showEditAccountView: Bool = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                List {
                    // Account informations
                    Section {
                        VStack(alignment: .center) {
                            HStack {
                                Spacer()
                                Image(services[account.serviceId].serviceIcon)
                                    .resizable()
                                    .frame(width:100, height:100)
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                Spacer()
                            }
                            .onTapGesture {
                                // Increments deleteTaps and send haptic feedback to the user
                                userTapsOnLogo()
                            }
                            
                            Text(services[account.serviceId].serviceName)
                                .font(.caption)
                            
                            Text(account.accountName)
                                .font(.title)
                        }
                    }
                    .listRowBackground(colorScheme == .dark ? Color(.black) :  Color(.secondarySystemBackground))
                    
                    
                    Section {
                        // List of codes
                        if let accountCodes = account.accountCodes {
                            ForEach(accountCodes) { aCode in
                                if let codeValue = aCode.codeValue {
                                    CodeListItemView(codeValue: codeValue)
                                        .swipeActions {
                                            Button("Supprimer", role: .destructive) {
                                                selectedCodeToDelete = aCode
                                                showCodeDeleteConfirmationDialog.toggle()
                                            }
                                        }
                                }
                            }
                        } else {
                            Text("No codes associated with this account")
                        }
                    } header: {
                        Text("Recovery codes")
                    } footer: {
                        Text("Long press on a code to copy it in the pasteboard")
                    }
                    
                    Section {
                        NavigationLink(destination: NewCodesView(account: account)) {
                            Text("Add new codes")
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    
                    if deleteTaps >= 5 {
                        Section(header: Text("Danger zone")) {
                            Button {
                                showAccountDeleteConfirmationDialog.toggle()
                            } label: {
                                Text("Delete this account")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //navigationPath.append(1)
                        showEditAccountView.toggle()
                    } label: {
                        HStack{
                            Text("Edit infos")
                                .padding([.leading, .trailing])
                                .padding([.top, .bottom], 5)
                        }
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(Capsule())
                    }
                }
            }
            .sheet(isPresented: $showNewCodesView) { // New codes modal
                NewCodesView(account: account)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showEditAccountView) {
                EditAccountView(account: account)
            }
            .alert("Delete this account ?", isPresented: $showAccountDeleteConfirmationDialog) { // Account deletion alert
                TextField("Enter accont's name", text: $accountNameConfirmation)
                Button("Cancel", role: .cancel) {}
                Button("Confirm") {
                    deleteAccount()
                }
            } message: {
                Text("Once deleted, an account ant its codes cannot be retrieved")
                    .bold()
                    .foregroundStyle(.red)
            }
            .alert("Delete this code ?", isPresented: $showCodeDeleteConfirmationDialog) {
                Button("Cancel", role: .cancel) {}
                Button("Confirm") {
                    deleteCode(code: selectedCodeToDelete!)
                }
            }
            .navigationDestination(for: Int.self) { i in
                EditAccountView(account: account)
            }
        }
    }
    
    
    /*
     func userTapsOnLogo()
     Increments deleteTaps and send an haptic feedback to the user
     */
    func userTapsOnLogo() {
        let hapticFeedback = UIImpactFeedbackGenerator(style: .rigid)
        hapticFeedback.impactOccurred()
        deleteTaps = deleteTaps <= 10 ? deleteTaps + 1 : 0
    }
    
    
    /**
        func deleteAccount()
        Deletes the account
     */
    func deleteAccount() {
        if accountNameConfirmation == account.accountName {
            modelContext.delete(account)
            
            // Force save the suppression of the account in CloudKit
            do {
                try modelContext.save()
            } catch {
                fatalError("Cannot save changes \(error)")
            }
            
            dismiss()
            
        } else {
            print("Account name is not the same")
        }
    }
    
    
    /**
    func deleteCode(code: Code)
     Delete the code in parameters
     - parameter code : The code object we want to delete
     */
    func deleteCode(code: Code) {
        print("Code supprimé \(code.codeValue!)")
        modelContext.delete(code)
        do {
            try modelContext.save()
        } catch {
            fatalError("Cannot save changes right now \(error)")
        }
    }
}

#Preview {
    AccountView(account: Account(accountName: "Panzani"))

    
}
