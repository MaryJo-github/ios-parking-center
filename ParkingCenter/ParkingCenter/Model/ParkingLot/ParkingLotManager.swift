//
//  ParkingLotManager.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/11.
//

import Foundation

typealias ParkingLotRequestResult = (Result<ParkingLot, Error>) -> Void

final class ParkingLotManager {
    private(set) var informations: [ParkingInformation]?
    
    func receiveData(district: String, completion: @escaping ParkingLotRequestResult) {
        guard let url = makeURL(district: district) else {
            completion(.failure(URLError.makingURLFail))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        if let cachedData = URLCache.shared.cachedResponse(for: urlRequest)?.data {
            do {
                let decodedData = try JSONDecoder().decode(ParkingLot.self, from: cachedData)
                
                self.informations = decodedData.getParkingInfo.information
                
                completion(.success(decodedData))
            } catch {
                completion(.failure(DecodeError.decodingFail))
            }
            return
        }
        
        NetworkingManager().fetchData(urlRequest: urlRequest, caching: true) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(ParkingLot.self, from: data)

                    self?.informations = decodedData.getParkingInfo.information
                    
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(DecodeError.decodingFail))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func makeURL(district: String) -> URL? {
        guard let apiKey = Bundle.main.infoDictionary?["ParkingAPIKey"] as? String else {
            return nil
        }
        
        var urlString = URLSource.baseURL
        urlString += "/" + apiKey
        urlString += "/" + URLSource.fileType
        urlString += "/" + URLSource.serviceName
        urlString += "/" + URLSource.startIndex
        urlString += "/" + URLSource.endIndex
        urlString += "/" + district
        
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
        static let baseURL = "http://openapi.seoul.go.kr:8088"
        static let fileType = "json"
        static let serviceName = "GetParkingInfo"
        static let startIndex = "1"
        static let endIndex = "1000"
    }
}
