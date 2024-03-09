//
//  AuthController.swift
//  kipi
//
//  Created by Ossi on 08/03/2024.
//

import Foundation
import LocalAuthentication



class AuthController: ObservableObject {
    
    fileprivate var context: LAContext?
    
    init() {
        context = LAContext()
    }
    
    deinit {
        context = nil
    }
    
    func authenticate(completion : @escaping (Result<Bool, LAError>) -> Void) {
        if let context {
            let reason = "Authenticate to see access your data"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    completion(.success(true))
                } else if let error = error as? LAError {
                    switch error.code {
                    case .authenticationFailed:
                        completion(.failure(error))
                    case .userCancel:
                        completion(.failure(error))
                    default:
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
