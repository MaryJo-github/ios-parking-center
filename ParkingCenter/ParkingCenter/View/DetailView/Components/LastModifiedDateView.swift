//
//  LastModifiedDateView.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/14.
//

import UIKit

final class LastModifiedDateView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let lastModifiedStackView: UIStackView = {
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
            titleLabel,
            informationLabel,
        ].forEach { view in
            lastModifiedStackView.addArrangedSubview(view)
        }
        
        addSubview(lastModifiedStackView)
        backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            lastModifiedStackView.topAnchor.constraint(equalTo: topAnchor),
            lastModifiedStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lastModifiedStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lastModifiedStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func configureLabel(parkingInformations: [ParkingInformation]) {
        titleLabel.text = "🗓️ 정보 수정 일자"
        guard let singleData = parkingInformations.first else { return }
        
        var tempString = ""
        if singleData.updatedTime != "" {
            tempString = singleData.updatedTime
        } else {
            tempString += "정보 없음"
        }
        
        informationLabel.text = tempString
    }
}
