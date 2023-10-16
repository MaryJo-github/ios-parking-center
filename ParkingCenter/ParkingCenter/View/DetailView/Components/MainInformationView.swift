//
//  MainInformationView.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/14.
//

import UIKit

final class MainInformationView: UIView {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.numberOfLines = 0
        label.textColor = .systemOrange
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let parkingInformationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()

    private let mainInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [
            nameLabel,
            addressLabel,
            phoneNumberLabel,
            parkingInformationLabel,
        ].forEach { view in
            mainInformationStackView.addArrangedSubview(view)
        }
        
        addSubview(mainInformationStackView)
        backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainInformationStackView.topAnchor.constraint(equalTo: topAnchor),
            mainInformationStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainInformationStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainInformationStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func configureLabel(parkingInformations: [ParkingInformation]) {
        guard let singleData = parkingInformations.first else { return }
        
        nameLabel.text = singleData.name
        addressLabel.text = singleData.address
        
        if singleData.phoneNumber != "" {
            phoneNumberLabel.text = singleData.phoneNumber
        } else {
            phoneNumberLabel.removeFromSuperview()
        }
        
        guard singleData.queueStatus == "1" else {
            parkingInformationLabel.text = "실시간 주차 정보 미제공"
            return
        }
        
        if singleData.capacity == 1 && parkingInformations.count != 1 {
            parkingInformationLabel.text = "전체주차면 : \(parkingInformations.count) | 주차가능면 : \(parkingInformations.count - Int(singleData.currentParking))"
        } else {
            parkingInformationLabel.text = "전체주차면 : \(Int(singleData.capacity)) | 주차가능면 : \(Int(singleData.capacity - singleData.currentParking))"
        }
    }
}
