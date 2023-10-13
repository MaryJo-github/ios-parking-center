//
//  ParkingLotTableViewCell.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/13.
//

import UIKit

final class ParkingLotTableViewCell: UITableViewCell {
    private let parkingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "p.circle")
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        
        return label
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        
        return stackView
    }()
    
    private let parkingLotStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setupConstraints()
        
        backgroundColor = .systemBackground
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(name: String, data: [ParkingInformation]) {
        guard let singleData = data.first else { return }
        
        nameLabel.text = name
        addressLabel.text = singleData.address
        
        guard singleData.queueStatus == "1" else {
            infoLabel.text = "실시간 주차 정보 미제공"
            return
        }
        
        if singleData.capacity == 1 && data.count != 1 {
            infoLabel.text = "전체주차면 : \(data.count) | 주차가능면 : \(data.count - Int(singleData.currentParking))"
        } else {
            infoLabel.text = "전체주차면 : \(Int(singleData.capacity)) | 주차가능면 : \(Int(singleData.capacity - singleData.currentParking))"
        }
    }
    
    private func configureUI() {
        [
            parkingImage,
            nameLabel
        ].forEach { view in
            nameStackView.addArrangedSubview(view)
        }
        
        [
            nameStackView,
            addressLabel,
            infoLabel
        ].forEach { view in
            parkingLotStackView.addArrangedSubview(view)
        }
        
        contentView.addSubview(parkingLotStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            parkingLotStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            parkingLotStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            parkingLotStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            parkingLotStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            parkingImage.widthAnchor.constraint(equalTo: nameStackView.widthAnchor, multiplier: 0.07),
            parkingImage.heightAnchor.constraint(equalTo: parkingImage.widthAnchor),
        ])
    }
}
