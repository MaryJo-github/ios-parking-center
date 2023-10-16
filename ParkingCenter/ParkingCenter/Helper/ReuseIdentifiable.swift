//
//  ReuseIdentifiable.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/13.
//

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
