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
    var id: String?
    var company: CompanyElement?
    
    init(name: String? = nil, id: String? = nil, company: CompanyElement? = nil) {
        self.name = name
        self.id = id
        self.company = company
    }
}
