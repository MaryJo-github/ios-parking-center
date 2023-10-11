//
//  RegionMananger.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/11.
//

import Foundation
import CoreLocation

typealias RegionRequestResult = (Result<Region, Error>) -> Void

final class RegionMananger {
    func receiveData(coordinate: CLLocationCoordinate2D, completion: @escaping RegionRequestResult) {
        guard let urlRequest = makeURLRequest(coordinate: coordinate) else {
            completion(.failure(URLError.makingURLFail))
            return
        }
        
        NetworkingManager().fetchData(urlRequest: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(Region.self, from: data)

                    completion(.success(decodedData))
                } catch {
                    completion(.failure(DecodeError.decodingFail))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func makeURLRequest(coordinate: CLLocationCoordinate2D) -> URLRequest? {
        var urlString = URLSource.baseURL
        urlString += "?x=" + String(coordinate.longitude)
        urlString += "&y=" + String(coordinate.latitude)
        
        guard let url = URL(string: urlString),
              let apiKey = Bundle.main.infoDictionary?["KakaoAPIKey"] as? String else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)

        urlRequest.addValue(apiKey, forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
}

extension RegionMananger {
    enum URLSource {
        static let baseURL = "https://dapi.kakao.com/v2/local/geo/coord2regioncode"
    }
}
