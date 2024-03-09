//
//  Account.swift
//  kipi
//
//  Created by Ossi on 24/02/2024.
//

import Foundation
import SwiftData

@Model
class Account {
    var accountName: String = ""
    var bookmarked: Bool = false
    
    var serviceIcon: String = ""
    var serviceId: Int = 0
    
    @Relationship(deleteRule: .cascade, inverse: \Code.account) var accountCodes: [Code]?
    
    init(accountName: String) {
        self.accountName = accountName
    }
}
