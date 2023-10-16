//
//  ChargeInformationView.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/14.
//

import UIKit

final class ChargeInformationView: UIView {
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
    
    private let chargeInformationStackView: UIStackView = {
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
            chargeInformationStackView.addArrangedSubview(view)
        }
        
        addSubview(chargeInformationStackView)
        backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chargeInformationStackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            chargeInformationStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chargeInformationStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chargeInformationStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func configureLabel(parkingInformations: [ParkingInformation]) {
        titleLabel.text = "💰 요금 정보"
        guard let singleData = parkingInformations.first else { return }
        guard singleData.payRequiredName == "유료" else {
            informationLabel.text = "무료"
            return
        }
        
        var tempString = ""
        if singleData.charge != 0 && singleData.chargetimeUnit != 0 {
            tempString += "기본 요금(시간) : \(Int(singleData.charge))원 / \(Int(singleData.chargetimeUnit))분"
        } else {
            tempString += "기본 요금 정보 없음"
        }
        
        if singleData.surcharge != 0 && singleData.surchargeTimeUnit != 0 {
            tempString += "\n추가 요금(시간) : \(Int(singleData.surcharge))원 / \(Int(singleData.surchargeTimeUnit))분"
        }
        
        if singleData.chargeFullTimeMonthly != "0" && singleData.chargeFullTimeMonthly != "" {
            tempString += "\n월 정기권 요금 : \(singleData.chargeFullTimeMonthly)원"
        }
        
        if singleData.dayMaximumCharge != 0 {
            tempString += "\n일일 최대 요금 : \(Int(singleData.dayMaximumCharge))원"
        }
        
        if singleData.saturdayPayRequired == "N" {
            tempString += "\n토요일 무료"
        }
        
        if singleData.holidayPayRequired == "N" {
            tempString += "\n공휴일 무료"
        }
        
        informationLabel.text = tempString
    }
}
