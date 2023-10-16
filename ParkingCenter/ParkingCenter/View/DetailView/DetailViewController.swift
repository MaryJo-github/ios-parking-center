//
//  DetailViewController.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/14.
//

import UIKit

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private let mainInformationView = MainInformationView()
    private let chargeInformationView = ChargeInformationView()
    private let operationsInformationView = OperationsInformationView()
    private let lastModifiedDateView = LastModifiedDateView()
    private var separatorView = UIView()
        
    private let detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setupConstraints()
        configureLabels()
    }
    
    private func configureUI() {
        chargeInformationView.layer.addSeparator(x: 0, y: 0, width: view.frame.width, height: 1)
        
        [
            mainInformationView,
            chargeInformationView,
            operationsInformationView,
            lastModifiedDateView
        ].forEach {
            detailStackView.addArrangedSubview($0)
        }
        
        scrollView.addSubview(detailStackView)
        view.addSubview(scrollView)
        view.backgroundColor = .systemBackground
        title = "주차장 상세정보"
        navigationItem.backBarButtonItem?.title = ""
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            
            detailStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: 1),
            detailStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            detailStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            detailStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            detailStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
        ])
    }
    
    private func configureLabels() {
        mainInformationView.configureLabel(parkingInformations: viewModel.parkingInformations)
        chargeInformationView.configureLabel(parkingInformations: viewModel.parkingInformations)
        operationsInformationView.configureLabel(parkingInformations: viewModel.parkingInformations)
        lastModifiedDateView.configureLabel(parkingInformations: viewModel.parkingInformations)
    }
}
