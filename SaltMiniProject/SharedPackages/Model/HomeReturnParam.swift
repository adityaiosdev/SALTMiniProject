//
//  HomeReturnParam.swift
//  SaltMiniProject
//
//  Created by Aditya Ramadhan on 19/10/23.
//

import Foundation

struct ResponseContract: Codable {
    let page, perPage, total, totalPages: Int
    let data: [UserItem]
    let support: Support

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data, support
    }
}

struct UserItem: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}

struct Support: Codable {
    let url: String
    let text: String
}
