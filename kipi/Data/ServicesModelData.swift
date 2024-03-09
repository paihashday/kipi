//
//  ServicesModelData.swift
//  kipi
//
//  Created by Ossi on 26/02/2024.
//

import Foundation

var services: [Service] = load("services.json")

func load<T:Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("\(filename) introuvable")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Impossible de charger \(filename) : \(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Impossible de décoder \(filename) : \(error)")
    }
}
