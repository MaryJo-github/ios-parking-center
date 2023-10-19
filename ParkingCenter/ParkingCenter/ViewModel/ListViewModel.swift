//
//  ListViewModel.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/12.
//

final class ListViewModel {
    let parkingLotManager: ParkingLotManager
    weak var listViewDelegate: ListViewDelegate?
    var groupedData: [String: [ParkingInformation]]? {
        didSet {
            listViewDelegate?.updateTableView()
        }
    }
    var district: String {
        didSet {
            fetchParkingLotData(district: district)
        }
    }
    
    init(parkingLotManager: ParkingLotManager, district: String) {
        self.parkingLotManager = parkingLotManager
        self.district = district
    }
    
    func fetchParkingLotData(district: String) {
        parkingLotManager.receiveData(district: district) { [weak self] result in
            switch result {
            case .success(let data):
                self?.groupParkingLotData(data.getParkingInfo.information)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func groupParkingLotData(_ data: [ParkingInformation]) {
        groupedData = Dictionary(grouping: data) { information in
            return information.name
        }
    }
}
