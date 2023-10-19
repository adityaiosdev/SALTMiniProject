//
//  AuthReturnParam.swift
//  SaltMiniProject
//
//  Created by Aditya Ramadhan on 19/10/23.
//

import Foundation
import UIKit

struct AuthReturnParam: Codable {
    let token: String?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case error = "error"
    }
}
