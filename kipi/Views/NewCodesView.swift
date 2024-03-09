//
//  NewCodesView.swift
//  kipi
//
//  Created by Ossi on 29/02/2024.
//

import SwiftUI

struct NewCodesView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var account: Account
    
    @State var newCodesString: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Paste your new codes here", text: $newCodesString, axis: .vertical)
                        .lineLimit(5...20)
                }
            }
            .navigationTitle("Add codes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addCodes(codes: newCodesString, account: account)
                        dismiss()
                    } label: {
                        Text("Add codes")
                            .bold()
                    }
                    .disabled(newCodesString.isEmpty)
                }
            }
        }
    }
    
    // Add new codes to the account
    func addCodes(codes: String, account: Account) {
        let newAccountCodes = newCodesString.components(separatedBy: "\n")
        for aCode in newAccountCodes {
            let newCode = Code(codeValue: aCode, account: account)
            modelContext.insert(newCode)
        }
        
        do {
            try modelContext.save()
        } catch {
            fatalError("Cannot save new codes \(error)")
        }
    }
}

#Preview {
    NewCodesView(account: Account(accountName: "Giovani"))
}
