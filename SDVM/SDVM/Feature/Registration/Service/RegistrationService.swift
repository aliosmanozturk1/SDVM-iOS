//
//  RegistrationService.swift
//  Firebase User Account Management
//
//  Created by Tunde on 22/05/2021.
//

import Combine
import Foundation
import Firebase
import FirebaseDatabase

enum Gender: String, Identifiable, CaseIterable {
    var id: Self { self }
    case erkek = "Erkek"
    case kadin = "Kadın"
}

enum Types: String, Identifiable, CaseIterable {
    var id: Self { self }
    case engelli = "Engelli"
    case takipci = "Takipçi"
    case cevirmen = "Çevirmen"
}

struct RegistrationCredentials {
    
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var occupation: String
    var gender: Gender
    var types: Types
}

protocol RegistrationService {
    func register(with credentials: RegistrationCredentials) -> AnyPublisher<Void, Error>
}

enum RegistrationKeys: String {
    case firstName
    case lastName
    case occupation
    case gender
    case types
}

final class RegistrationServiceImpl: RegistrationService {
    
    func register(with credentials: RegistrationCredentials) -> AnyPublisher<Void, Error> {
        
        Deferred {

            Future { promise in
                
                Auth.auth().createUser(withEmail: credentials.email,
                                       password: credentials.password) { res, error in
                    
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        
                        if let uid = res?.user.uid {
                            
                            let values = [RegistrationKeys.firstName.rawValue: credentials.firstName,
                                          RegistrationKeys.lastName.rawValue: credentials.lastName,
                                          RegistrationKeys.occupation.rawValue: credentials.occupation,
                                          RegistrationKeys.gender.rawValue: credentials.gender.rawValue,
                                          RegistrationKeys.types.rawValue: credentials.types.rawValue] as [String : Any]
                            
                            Database
                                .database()
                                .reference()
                                .child("users")
                                .child(uid)
                                .updateChildValues(values) { error, ref in
                                    
                                    if let err = error {
                                        promise(.failure(err))
                                    } else {
                                        promise(.success(()))
                                    }
                                }
                        }
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
