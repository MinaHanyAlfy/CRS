//
//  User.swift
//  CRS
//
//  Created by John Doe on 2022-11-26.
//

import Foundation

typealias ResponseString = String

struct User {
    var name: String?
    var idEncoded: String?
    var idDecoded: String?
    var company: CompanyElement?
    var level: String?
    init(name: String? = nil, idEncoded: String? = nil, company: CompanyElement? = nil,level: String? = nil,idDecoded: String? = nil) {
        self.name = name
        self.idEncoded = idEncoded
        self.idDecoded = idDecoded
        self.company = company
        self.level = level
    }
}
