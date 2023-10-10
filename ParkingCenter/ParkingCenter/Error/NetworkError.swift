//
//  NetworkError.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/10.
//

import Foundation

enum NetworkError {
    case requestFail
    case responseFail
    case statusCodeNotSuccess(Int)
    case dataLoadFail
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .requestFail:
            return "데이터 요청에 실패했습니다."
        case .responseFail:
            return "응답이 없습니다."
        case .statusCodeNotSuccess(let statusCode):
            return "statusCode가 successful이 아닙니다. [Code: \(statusCode)]"
        case .dataLoadFail:
            return "data를 불러오지 못했습니다."
        }
    }
}
