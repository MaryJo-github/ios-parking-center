//
//  URLError.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/11.
//

import Foundation

enum URLError {
    case makingURLFail
}

extension URLError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .makingURLFail:
            return "올바르지 않은 URL입니다."
        }
    }
}
