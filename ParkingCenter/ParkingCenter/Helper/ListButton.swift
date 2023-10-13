//
//  ListButton.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/13.
//

import UIKit

final class ListButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setButton()
    }
    
    private func setButton() {
        var config = UIButton.Configuration.filled()
        
        config.image = UIImage(systemName: "list.bullet.rectangle.portrait")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .small)
        config.imagePadding = 8
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .systemOrange
        
        configuration = config
    }
}
