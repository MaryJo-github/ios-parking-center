//
//  ListViewController.swift
//  ParkingCenter
//
//  Created by MARY on 2023/10/12.
//

import UIKit

final class ListViewController: UIViewController {
    private var viewModel: ListViewModel
    private let pickerView = UIPickerView()

    private let districtShowPicker: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.tintColor = .clear
        textField.backgroundColor = .systemOrange
        textField.textColor = .white
        textField.textAlignment = .center
        textField.font = .boldSystemFont(ofSize: 20)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let parkingLotTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configurePickerView()
        configureTableView()
        setupConstraints()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(districtShowPicker)
        view.addSubview(parkingLotTableView)
        title = "주차장 목록"
        navigationItem.backButtonTitle = ""
        
        viewModel.listViewDelegate = self
    }
    
    private func configurePickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        districtShowPicker.inputView = pickerView
        districtShowPicker.text = viewModel.district + " ▼"
        
        if let district = Districts(rawValue: viewModel.district),
           let defaultRow = Districts.allCases.firstIndex(of: district) {
            pickerView.selectRow(defaultRow, inComponent: 0, animated: false)
        }
        
        configureToolbar()
    }
    
    private func configureTableView() {
        parkingLotTableView.dataSource = self
        parkingLotTableView.delegate = self
        parkingLotTableView.register(ParkingLotTableViewCell.self, forCellReuseIdentifier: ParkingLotTableViewCell.reuseIdentifier)
        viewModel.district = viewModel.district
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            districtShowPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            districtShowPicker.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            districtShowPicker.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            parkingLotTableView.topAnchor.constraint(equalTo: districtShowPicker.bottomAnchor, constant: 8),
            parkingLotTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            parkingLotTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            parkingLotTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func configureToolbar() {
        let toolBar = UIToolbar()
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: self,
            action: #selector(donePicker)
        )
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let cancelButton = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(cancelPicker)
        )
        
        toolBar.setItems(
            [
                doneButton,
                flexibleSpace,
                cancelButton
            ],
            animated: true
        )
        
        districtShowPicker.inputAccessoryView = toolBar
    }
    
    @objc private func donePicker() {
        let row = pickerView.selectedRow(inComponent: 0)
        pickerView.selectRow(row, inComponent: 0, animated: false)
        districtShowPicker.text = Districts.allCases[row].rawValue + " ▼"
        districtShowPicker.resignFirstResponder()
        viewModel.district = Districts.allCases[row].rawValue
    }

    @objc private func cancelPicker() {
        districtShowPicker.text = nil
        districtShowPicker.resignFirstResponder()
    }
    
    private func showDetailViewController(parkingInformations: [ParkingInformation]) {
        let detailViewController = DetailViewController(viewModel: DetailViewModel(parkingInformations: parkingInformations))
        
        show(detailViewController, sender: self)
    }
}

extension ListViewController: ListViewDelegate {
    func updateTableView() {
        DispatchQueue.main.async {
            self.parkingLotTableView.reloadData()
        }
    }
}

extension ListViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Districts.allCases.count
    }
}

extension ListViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Districts.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        districtShowPicker.text = Districts.allCases[row].rawValue + " ▼"
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupedData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ParkingLotTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? ParkingLotTableViewCell else {
            return UITableViewCell()
        }
        
        guard let datas = viewModel.groupedData else {
            return UITableViewCell()
        }
        
        let index = datas.index(datas.startIndex, offsetBy: indexPath.row)
        
        cell.configureCell(name: datas[index].key, data: datas[index].value)
        
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let datas = viewModel.groupedData else { return }
        let index = datas.index(datas.startIndex, offsetBy: indexPath.row)
        
        showDetailViewController(parkingInformations: datas[index].value)
    }
}
