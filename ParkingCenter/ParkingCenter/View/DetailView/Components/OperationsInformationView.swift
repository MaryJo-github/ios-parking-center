//
//  OperationsInformationView.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/14.
//

import UIKit

final class OperationsInformationView: UIView {
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
    
    private let operationsInformationStackView: UIStackView = {
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
            operationsInformationStackView.addArrangedSubview(view)
        }
        
        addSubview(operationsInformationStackView)
        backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            operationsInformationStackView.topAnchor.constraint(equalTo: topAnchor),
            operationsInformationStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            operationsInformationStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            operationsInformationStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func configureLabel(parkingInformations: [ParkingInformation]) {
        titleLabel.text = "⏰ 운영 정보"
        guard let singleData = parkingInformations.first else { return }
        
        var tempString = ""
        if singleData.weekdayBeginTime != "0000" && singleData.weekdayEndTime != "0000" {
            tempString += "평일 운영 시간 : \(convertStringToTimeFormat(singleData.weekdayBeginTime)) ~ \(convertStringToTimeFormat(singleData.weekdayEndTime))"
        } else {
            tempString += "평일 운영 시간 정보 없음"
        }
        
        if singleData.weekendBeginTime != "0000" && singleData.weekendEndTime != "0000" {
            tempString += "\n주말 운영 시간 : \(convertStringToTimeFormat(singleData.weekendBeginTime)) ~ \(convertStringToTimeFormat(singleData.weekendEndTime))"
        } else {
            tempString += "\n주말 운영 시간 정보 없음"
        }
        
        if singleData.holidayBeginTime != "0000" && singleData.holidayEndTime != "0000" {
            tempString += "\n공휴일 운영 시간 : \(convertStringToTimeFormat(singleData.holidayBeginTime)) ~ \(convertStringToTimeFormat(singleData.holidayEndTime))"
        }
        
        if singleData.nightFreeOpen == "Y" {
            tempString += "\n야간 무료 개방"
        }
        
        informationLabel.text = tempString
    }
    
    private func convertStringToTimeFormat(_ input: String) -> String {
        guard input.count == 4 else { return input }
        let result = String(input.prefix(2) + ":" + input.suffix(2))
        
        return result
    }
}
