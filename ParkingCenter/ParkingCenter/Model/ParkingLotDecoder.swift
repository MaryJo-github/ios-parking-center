//
//  ParkingLotDecoder.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/10.
//

import Foundation

struct ParkingLotDecoder {
    private let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    func decodeData(_ data: Data) {
        do {
            let decodedData = try JSONDecoder().decode(ParkingLot.self, from: data)
            print(decodedData)
        } catch {
            print(error.localizedDescription)
        }
    }
}
