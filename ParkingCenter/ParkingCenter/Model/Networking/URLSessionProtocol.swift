//
//  URLSessionProtocol.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/10.
//

import Foundation

protocol URLSessionProtocol {
    
    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
