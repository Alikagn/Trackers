//
//  CreatingHabitViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 12.07.2025.
//

import UIKit

final class CreatingHabitViewController: UIViewController {
    
    // MARK: Public Property
    
    weak var delegate: CreatingTrackerViewControllerDelegate?
    
    var currentSchedule: [WeekDay] = []
    
    // MARK: Private Property
    
    private let contentsTableView = ["Категория", "Расписание"]
    private var scheduleDay: [WeekDay] = []
    private var scheduleCategory = String()
    
    private var categoryText: String? = nil
    private var scheduleText: String? = nil
    private var contentsCategory: [String] = []
    
    private var isHabit: Bool
    
    private lazy var downButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "icons8") ?? UIImage(systemName: "arrowshape.down"),
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        button.tintColor = Colors.black
        button.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        return button
    }()
    
    lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(isHabit value: Bool) {
        self.isHabit = value
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension CreatingHabitViewController {
    
    func getSelectedDays(from schedules: [Schedule]) -> [WeekDay] {
        return schedules.compactMap { schedule in
            if schedule.value, let day = schedule.day {
                return day
            }
            return nil
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    func setupNavBar() {
        navigationItem.leftBarButtonItem = downButton
        navigationItem.title = isHabit ? "Новая привычка" : "Новое нерегулярное событие"
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.ypBlack
            ]
        }
    }
    
    func isSubmitButtonEnabled() -> Bool {
        if isHabit {
            scheduleText != nil &&
            categoryText != nil &&
            !(ui.trackerNameTextField.text?.isEmpty ?? false)
        } else {
            categoryText != nil &&
            !(ui.trackerNameTextField.text?.isEmpty ?? false)
        }
    }
    
    func stackSubView() {
        [
            ui.trackerNameTextField,
            ui.contentsTableView,
            ui.stackView
        ].forEach { view.addSubview($0) }
        
        [
            ui.cancelButton,
            ui.createButton
        ].forEach { ui.stackView.addArrangedSubview($0) }
    }
    
    @objc func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc func didTapCreateButton() {
        guard let trackerName = ui.trackerNameTextField.text else { return }
        let tracker = Tracker(
            id: UUID(),
            name: trackerName,
            color: "ColorSelection12",
            emoji: "🐶",
            schedule: scheduleDay,
            colorAssetName: "ColorSelection12",
            type: isHabit ? .habit : .irregularEvent
        )
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            delegate?.sendTracker(tracker: tracker, for: categoryText ?? String())
        }
    }
}

// MARK: - UITextFieldDelegate

extension CreatingHabitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        ui.createButton.isEnabled = isSubmitButtonEnabled()
        if ui.createButton.isEnabled {
            ui.createButton.backgroundColor = .ypBlack
        } else {
            ui.createButton.backgroundColor = .ypGray
        }
        return true
    }
}

// MARK: - UITableViewDelegate

extension CreatingHabitViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // нажатие на ячейку
        var navigationController = UINavigationController()
        
        if indexPath.row == 0 {
            let controller = CategoryViewController()
            controller.contentsCategory = contentsCategory
            controller.delegate = self
            navigationController = UINavigationController(rootViewController: controller)
            self.present(navigationController, animated: true)
        } else if indexPath.row == 1 {
            let controller = ScheduleViewController()
            controller.currentSchedule = scheduleDay
            controller.delegate = self
            navigationController = UINavigationController(rootViewController: controller)
            self.present(navigationController, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension CreatingHabitViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isHabit ? contentsTableView.count : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = Colors.background
        let isCategory = indexPath.row == 0
        cell.configure(
            with: contentsTableView[indexPath.row],
            isCategory: indexPath.row == 0,
            subtitle: isCategory ? categoryText : scheduleText
        )
        
        return cell
    }
}

// MARK: - CategoryViewControllerDelegate

extension CreatingHabitViewController: CategoryViewControllerDelegate {
    
    func categoryViewControllerDidSelectCategories(
        _ category: String,
        categories: [String]
    ) {
        categoryText = category
        ui.contentsTableView.reloadData()
        contentsCategory = categories
        ui.createButton.isEnabled = isSubmitButtonEnabled()
        if ui.createButton.isEnabled {
            ui.createButton.backgroundColor = .ypBlack
        } else {
            ui.createButton.backgroundColor = .ypGray
        }
    }
}

// MARK: - ScheduleDelegate

extension CreatingHabitViewController: ScheduleDelegate {
    func delegateSchedule(days: [WeekDay]) {
        // Получить все дни недели
        scheduleDay = days
        
        // Проверка, выбраны ли все
        let selectedDaysSet = Set(days)
        
        if selectedDaysSet == Set(WeekDay.allCases) {
            // Все дни
            scheduleText = "Каждый день"
        } else {
            // Не все
            scheduleText = days.map { $0.shortDay }.joined(separator: ", ")
        }
        ui.contentsTableView.reloadData()
        ui.createButton.isEnabled = isSubmitButtonEnabled()
        if ui.createButton.isEnabled {
            ui.createButton.backgroundColor = .ypBlack
        } else {
            ui.createButton.backgroundColor = .ypGray
        }
    }
}

// MARK: - UI Configuring

extension CreatingHabitViewController {
    
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
        trackerNameTextField.delegate = self
        view.addSubview(trackerNameTextField)
        
        let contentsTableView = UITableView()
        contentsTableView.register(
            CustomTableViewCell.self,
            forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier
        )
        contentsTableView.translatesAutoresizingMaskIntoConstraints = false
        contentsTableView.layer.cornerRadius = 16
        contentsTableView.backgroundColor = .ypBackground
        contentsTableView.separatorStyle = .none
        contentsTableView.layer.masksToBounds = true
        contentsTableView.backgroundColor = .clear
        contentsTableView.dataSource = self
        contentsTableView.delegate = self
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
        cancelButton.layer.masksToBounds = true
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
        createButton.isEnabled = false
        createButton.setTitle("Создать", for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
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
            
            ui.contentsTableView.bottomAnchor.constraint(equalTo: ui.stackView.topAnchor, constant: -24),
            ui.contentsTableView.topAnchor.constraint(equalTo: ui.trackerNameTextField.bottomAnchor, constant: 24),
            ui.contentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ui.contentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            ui.stackView.heightAnchor.constraint(equalToConstant: 60),
            ui.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ui.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ui.stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -34)
        ])
    }
    
    func setupUI() {
        view.backgroundColor = Colors.white
        setupNavBar()
        stackSubView()
    }
}

