//
//  EditAccountView.swift
//  kipi
//
//  Created by Ossi on 05/03/2024.
//

import SwiftUI
import SwiftData

struct EditAccountView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var account: Account
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Account name")
                        Spacer()
                        TextField("Account name", text: $account.accountName)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Picker("Select a service", selection: $account.serviceId) {
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
            }
            .navigationTitle("Edit account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
    }
}

#Preview {
    EditAccountView(account: Account(accountName: "Je suis fatigué"))
}
