//
//  ParkingLotManager.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/11.
//

import Foundation

final class ParkingLotManager {
    typealias RequestResult = (Result<ParkingLot, Error>) -> Void
    
    func receiveData(completion: @escaping RequestResult) {
        guard let url = makeURL() else {
            completion(.failure(URLError.makingURLFail))
            return
        }
        
        NetworkingManager().fetchData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(ParkingLot.self, from: data)

                    completion(.success(decodedData))
                } catch {
                    completion(.failure(DecodeError.decodingFail))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func makeURL() -> URL? {
        guard let apiKey = Bundle.main.infoDictionary?["ParkingAPIKey"] as? String else {
            return nil
        }
        
        var urlString = URLSource.baseURL
        urlString += "/" + apiKey
        urlString += "/" + URLSource.fileType
        urlString += "/" + URLSource.serviceName
        urlString += "/" + URLSource.startIndex
        urlString += "/" + URLSource.endIndex
        urlString += "/" + URLSource.address
        
        guard let url = URL(string: makeStringKoreanEncoded(urlString)) else {
            return nil
        }
        
        return url
    }
    
    private func makeStringKoreanEncoded(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? string
    }
}

extension ParkingLotManager {
    enum URLSource {
        static let fileType = "json"
        static let serviceName = "GetParkingInfo"
        static let startIndex = "1"
        static let endIndex = "5"
        static let address = "관악구"
        static let baseURL = "http://openapi.seoul.go.kr:8088"
    }
}
