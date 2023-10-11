//
//  ServiceError.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/11.
//

import Foundation

enum ServiceError {
    case regionNotServiced
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .regionNotServiced:
            return "해당 지역은 서비스되지 않습니다."
        }
    }
}
