//
//  NetworkingManager.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/10.
//

import Foundation

final class NetworkingManager {
    typealias NetworkResult = (Result<Data, NetworkError>) -> Void
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData(url: URL, caching: Bool = false, completion: @escaping NetworkResult) {
        fetchData(urlRequest: URLRequest(url: url), caching: caching, completion: completion)
    }
    
    func fetchData(urlRequest: URLRequest, caching: Bool = false, completion: @escaping NetworkResult) {
        let task: URLSessionDataTask  = session.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completion(.failure(.requestFail))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.responseFail))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.statusCodeNotSuccess(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataLoadFail))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}
