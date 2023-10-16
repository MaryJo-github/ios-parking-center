//
//  Region.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/11.
//

struct Region: Decodable {
    let meta: Meta
    let documents: [Document]
}

struct Meta: Decodable {
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}

struct Document: Decodable {
    let regionType: String
    let city: String
    let district: String
    
    enum CodingKeys: String, CodingKey {
        case regionType = "region_type"
        case city = "region_1depth_name"
        case district = "region_2depth_name"
    }
}
