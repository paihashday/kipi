//
//  AccountsList.swift
//  kipi
//
//  Created by Ossi on 08/03/2024.
//

import SwiftUI
import SwiftData

struct AccountsList: View {
    @Environment(\.modelContext) var modelContext
    
    // Retrieves all the accounts
    @Query private var accounts: [Account]
    
    @Query(filter: #Predicate<Account> { account in
        account.bookmarked == false
    }) private var notBookmarkedAccounts: [Account]
    
    @State var displayNewAccountView: Bool = false
    @State var searchText: String = ""
    
    // List of all bookmarked accounts
    var bookmarkedAccounts: [Account] {
        let bookmarkedAccounts = accounts.compactMap { account in
            let accountIsBookmarked = account.bookmarked == true
            
            return accountIsBookmarked ? account : nil
        }
        
        return bookmarkedAccounts
    }
    
    // Filtered list of all accounts
    var filteredAccounts: [Account] {
        if searchText.isEmpty {
            return accounts
        }
        
        let filteredAccounts = accounts.compactMap { account in
            let accountNameContainsQuery = account.accountName.range(of: searchText, options: .caseInsensitive) != nil
            let accountServiceNameContainsQuery = services[account.serviceId].serviceName.range(of: searchText, options: .caseInsensitive) != nil
            
            return accountNameContainsQuery || accountServiceNameContainsQuery ? account : nil
        }
        
        return filteredAccounts
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                if !bookmarkedAccounts.isEmpty {
                    Section(header: Text("Bookmarked accounts")) {
                        ForEach(bookmarkedAccounts) { anAccount in
                            NavigationLink(destination: AccountView(account: anAccount)) {
                                HStack {
                                    Image(services[anAccount.serviceId].serviceIcon)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    Text(anAccount.accountName)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    ForEach(filteredAccounts) { anAccount in
                        NavigationLink(destination: AccountView(account: anAccount)) {
                            HStack {
                                Image(services[anAccount.serviceId].serviceIcon)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text(anAccount.accountName)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search my accounts")
            .navigationTitle("My accounts")
            .overlay {
                if filteredAccounts.isEmpty {
                    ContentUnavailableView.search
                }
            }
            .sheet(isPresented: $displayNewAccountView) {
                NewAccountView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        displayNewAccountView.toggle()
                    } label: {
                        Text("New")
                            .bold()
                            .padding([.top, .bottom], 5)
                            .padding([.leading, .trailing], 10)
                            .foregroundStyle(.white)
                            .background(Color.blue)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
}

#Preview {
    AccountsList()
}
