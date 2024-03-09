//
//  Code.swift
//  kipi
//
//  Created by Ossi on 24/02/2024.
//

import Foundation
import SwiftData

@Model
class Code {
    var codeValue: String?
    var account: Account?
    
    init(codeValue: String, account: Account) {
        self.codeValue = codeValue
        self.account = account
    }
}
