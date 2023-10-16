//
//  DecodeError.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/11.
//

import Foundation

enum DecodeError {
    case decodingFail
}

extension DecodeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingFail:
            return "데이터 변환에 실패하였습니다."
        }
    }
}
