//
//  Service.swift
//  kipi
//
//  Created by Ossi on 26/02/2024.
//

import Foundation

struct Service: Identifiable, Decodable {
    
    var id: Int
    var serviceName: String
    var serviceIcon: String
    var serviceColor: String
}
