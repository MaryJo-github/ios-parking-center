//
//  ModalView.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/17.
//

import UIKit

final class ModalView: UIView {
    private let parkingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "p.circle")
        imageView.tintColor = .systemGray2
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.setContentHuggingPriority(.init(100), for: .vertical)
        
        return label
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let modalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
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
            parkingImage,
            nameLabel,
        ].forEach { view in
            nameStackView.addArrangedSubview(view)
        }
        
        [
            nameStackView,
            addressLabel,
            infoLabel,
        ].forEach { view in
            modalStackView.addArrangedSubview(view)
        }
        
        addSubview(modalStackView)
        backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            modalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            modalStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            modalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            modalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),

            parkingImage.widthAnchor.constraint(equalTo: nameStackView.widthAnchor, multiplier: 0.07),
            parkingImage.heightAnchor.constraint(equalTo: parkingImage.widthAnchor),
        ])
    }
    
    func configureLabel(parkingInformations: [ParkingInformation]) {
        guard let singleData = parkingInformations.first else { return }
        
        nameLabel.text = singleData.name
        addressLabel.text = singleData.address
        
        guard singleData.queueStatus == "1" else {
            infoLabel.text = "실시간 주차 정보 미제공"
            return
        }
        
        if singleData.capacity == 1 && parkingInformations.count != 1 {
            infoLabel.text = "전체주차면 : \(parkingInformations.count) | 주차가능면 : \(parkingInformations.count - Int(singleData.currentParking))"
        } else {
            infoLabel.text = "전체주차면 : \(Int(singleData.capacity)) | 주차가능면 : \(Int(singleData.capacity - singleData.currentParking))"
        }
    }
}
