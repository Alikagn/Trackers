//
//  CreatingIrregularEventViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 09.08.2025.
//

import UIKit

final class CreatingIrregularEventViewController: UIViewController {
    
    // MARK: Private Property
    
    private let contentsTableView = ["Категория"]
    private var scheduleCategory1 = String()
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private Methods

private extension CreatingIrregularEventViewController {
    
    func subTitle(subTitle: String?, indexPath: IndexPath) {
        guard let cell = ui.contentsTableView.cellForRow(at: indexPath) as? CustomTableViewCell else {
            return
        }
//        cell.subText(subText: subTitle)
    }
    
    func updatTitleCategory(category: String) {
        scheduleCategory1 = category
        setTitleCategory(category: scheduleCategory1)
    }
    
    func setTitleCategory(category: String) {
        subTitle(subTitle: category, indexPath: IndexPath(row: 0, section: 0))
    }
    
    func setupNavBar() {
        navigationItem.title = "Новое нерегулярное событие"
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.ypBlack
            ]
        }
    }
    
    @objc func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc func didTapCreateButton() {
        
    }
}

// MARK: - CategoryViewControllerDelegate

extension CreatingIrregularEventViewController: CategoryViewControllerDelegate {
    func categoryViewControllerDidSelectCategories(_ controller: String, categories: [String]) {
         updatTitleCategory(category: controller)
    }
}

// MARK: - UITableViewDelegate

extension CreatingIrregularEventViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // нажатие на ячейку
        var navigationController = UINavigationController()
        
            let controller = CategoryViewController()
            navigationController = UINavigationController(rootViewController: controller)
            self.present(navigationController, animated: true)
        
    }
}

// MARK: - UITableViewDataSource

extension CreatingIrregularEventViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsTableView.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypBackground
        if indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        return cell
    }
}

// MARK: - UI Configuration

private extension CreatingIrregularEventViewController {
    
    func setupUI() {
        view.backgroundColor = .ypWhite
        setupNavBar()
        
        [
            ui.cancelButton,
            ui.createButton
        ].forEach { ui.stackView.addArrangedSubview($0)}
    }
}

// MARK: - UI Configuring

extension CreatingIrregularEventViewController {
    
    // MARK: UI components
    
    struct UI {
        let trackerNameTextField: UITextField
        let contentsTableView: UITableView
        let stackView: UIStackView
        let cancelButton: UIButton
        let createButton: UIButton
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let trackerNameTextField = UITextField()
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        trackerNameTextField.placeholder = "  Введите название трекера"
        trackerNameTextField.layer.cornerRadius = 16
        trackerNameTextField.backgroundColor = .ypBackground
        trackerNameTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.addSubview(trackerNameTextField)
        
        let contentsTableView = UITableView()
        contentsTableView.register(
            CustomTableViewCell.self,
            forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier
        )
        contentsTableView.translatesAutoresizingMaskIntoConstraints = false
        contentsTableView.layer.cornerRadius = 16
        contentsTableView.backgroundColor = .ypBackground
        contentsTableView.delegate = self
        contentsTableView.dataSource = self
        view.addSubview(contentsTableView)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        view.addSubview(stackView)
        
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderWidth = 1
        cancelButton.backgroundColor = .ypWhite
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.addTarget(
            self,
            action: #selector(didTapCancelButton),
            for: .touchUpInside
        )
        view.addSubview(cancelButton)
        
        let createButton = UIButton()
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.setTitle("Создать", for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.backgroundColor = .ypGray
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.addTarget(
            self,
            action: #selector(didTapCreateButton),
            for: .touchUpInside
        )
        view.addSubview(createButton)
        
        return .init(
            trackerNameTextField: trackerNameTextField,
            contentsTableView: contentsTableView,
            stackView: stackView,
            cancelButton: cancelButton,
            createButton: createButton
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate( [
            
            ui.trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            ui.trackerNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            ui.trackerNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ui.trackerNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            ui.contentsTableView.heightAnchor.constraint(equalToConstant: 75),
            ui.contentsTableView.topAnchor.constraint(equalTo: ui.trackerNameTextField.bottomAnchor, constant: 24),
            ui.contentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ui.contentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            ui.stackView.heightAnchor.constraint(equalToConstant: 60),
            ui.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ui.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ui.stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -34)
        ])
    }
}
