//
//  Customer.swift
//  CRS
//
//  Created by John Doe on 2022-12-02.
//

import Foundation

// MARK: - Customer
struct Customer: Codable {
    var customerID, customerName, customerPotential: String?
    var customerPrescription, pharmacy: String?
    var customerLatitude, customerLongitude, specialityName: String?
    var zoneName: JSONNull?

    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case customerName = "customer_name"
        case customerPotential = "customer_potential"
        case customerPrescription = "customer_prescription"
        case pharmacy
        case customerLatitude = "customer_latitude"
        case customerLongitude = "customer_longitude"
        case specialityName = "speciality_name"
        case zoneName = "zone_name"
    }
}

typealias Customers = [Customer]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
