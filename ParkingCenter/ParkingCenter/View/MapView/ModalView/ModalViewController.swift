//
//  ModalViewController.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/17.
//

import UIKit

final class ModalViewController: UIViewController {
    private let parkingInformations: [ParkingInformation]
    
    private let modalView: ModalView = {
        let modalView = ModalView()
        modalView.translatesAutoresizingMaskIntoConstraints = false
        
        return modalView
    }()
    
    private let detailButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.image = UIImage(systemName: "magnifyingglass.circle")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .medium)
        config.imagePadding = 8
        config.baseBackgroundColor = .systemBlue
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(parkingInformations: [ParkingInformation]) {
        self.parkingInformations = parkingInformations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setupConstraints()
        modalView.configureLabel(parkingInformations: parkingInformations)
    }
    
    private func configureUI() {
        view.addSubview(modalView)
        view.addSubview(detailButton)
        view.backgroundColor = .systemBackground
        view.alpha = 0.8
        
        detailButton.addTarget(self, action: #selector(tappedDetailButton), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            modalView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            modalView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            modalView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            detailButton.topAnchor.constraint(equalTo: modalView.bottomAnchor, constant: 16),
            detailButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            detailButton.heightAnchor.constraint(equalTo: detailButton.widthAnchor, multiplier: 0.2),
            detailButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    @objc private func tappedDetailButton() {
        let detailViewController = DetailViewController(
            viewModel: DetailViewModel(
                parkingInformations: parkingInformations
            )
        )

        show(detailViewController, sender: self)
    }
}
