//
//  NewAccountView.swift
//  kipi
//
//  Created by Ossi on 24/02/2024.
//

import SwiftUI

struct NewAccountView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    // Account data
    @State var accountName: String = ""
    @State var serviceId: Int = 0
    @State var accountCodes: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account")) {
                    TextField("Account name", text: $accountName)
                        .autocorrectionDisabled(true)
                        .keyboardType(.emailAddress)
                    
                    Picker("Select a service", selection: $serviceId) {
                        ForEach(services) { service in
                            HStack {
                                Image(service.serviceIcon)
                                    .resizable()
                                    .frame(width:30, height:30)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text(service.serviceName)
                            }
                            .tag(service.id)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section(header: Text("Recovery codes")) {
                    TextField("Copy/paste your codes here", text: $accountCodes, axis: .vertical)
                        .lineLimit(5...10)
                }
            }
            .navigationTitle("New account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        createAccount()
                        dismiss()
                    } label: {
                        Text("Create")
                            .bold()
                    }
                    .disabled(accountName.isEmpty || accountCodes.isEmpty)
                }
            }
        }
    }
    
    /**
     func createAccount()
     Create a new account and save it
     */
    func createAccount() {
        let newAccount = Account(accountName: accountName)
        modelContext.insert(newAccount)
        
        newAccount.serviceId = serviceId
        
        let newAccountCodes = accountCodes.components(separatedBy: "\n") // Splits string into an array of strings
        
        // Creates new codes and add them to the associated account
        for aCode in newAccountCodes {
            if !aCode.isEmpty {
                let newCode = Code(codeValue: aCode, account: newAccount)
                modelContext.insert(newCode)
            }
        }
    }
}

#Preview {
    NewAccountView()
}
