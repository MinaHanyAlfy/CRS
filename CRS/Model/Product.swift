//
//  Product.swift
//  CRS
//
//  Created by John Doe on 2022-12-02.
//

import Foundation

// MARK: - ProductElement
struct Product: Codable {
    var productID , productName: String?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productName = "product_name"
    }
}

typealias Products = [Product]
