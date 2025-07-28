//
//  CreatingHabitViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 12.07.2025.
//

import UIKit

// MARK: - CreatingHabitViewController

final class CreatingHabitViewController: UIViewController {
    
    // MARK: Public Property
    
    weak var delegate: CreatingTrackerViewControllerDelegate?
    
    // MARK: Private Property
    
    private var contentsTableView = ["Категория", "Расписание"]
    private var scheduleDay: [WeekDay] = []
    private var scheduleCategory = String()
    
    private var categoryText: String? = nil
    private var scheduleText: String? = nil
    private var contentsCategory: [String] = []
    
    private var isHabit: Bool
    
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    private var selectedIndexEmoji: Int?
    private var selectedIndexColor: Int?
    
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    private let colors: [UIColor] = [
        .colorSelection1, .colorSelection2, .colorSelection3,
        .colorSelection4, .colorSelection5, .colorSelection6,
        .colorSelection7, .colorSelection8, .colorSelection9,
        .colorSelection10, .colorSelection11, .colorSelection12,
        .colorSelection13, .colorSelection14, .colorSelection15,
        .colorSelection16, .colorSelection17, .colorSelection18
    ]
    
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
    
    init(isHabit value: Bool) {
        self.isHabit = value
        if !isHabit {
            contentsTableView.removeLast()
        }
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
    
    func setupNavBar() {
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
            selectedEmoji != nil &&
            selectedColor != nil &&
            scheduleText != nil &&
            categoryText != nil &&
            !(ui.trackerNameTextField.text?.isEmpty ?? false)
        } else {
            selectedEmoji != nil &&
            selectedColor != nil &&
            categoryText != nil &&
            !(ui.trackerNameTextField.text?.isEmpty ?? false)
        }
    }
    
    func stackSubView() {
        [
            ui.trackerNameTextField,
            ui.contentsTableView,
            ui.emojisColorsCollectionView,
            ui.stackView
        ].forEach { ui.scrollView.addSubview($0) }
        
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
            trackerID: UUID(),
            name: trackerName,
            color: selectedColor ?? UIColor.black,
            emoji: selectedEmoji ?? String(),
            schedule: scheduleDay,
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
        return contentsTableView.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypBackground
        let isCategory = indexPath.row == 0
        cell.configure(
            with: contentsTableView[indexPath.row],
            isCategory: indexPath.row == 0,
            subtitle: isCategory ? categoryText : scheduleText,
            isLast: contentsTableView[indexPath.row] == contentsTableView.last
        )
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CreatingHabitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        return 5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 24, left: 18, bottom: 40, right: 19)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        return CGSize(width: 52, height: 52)
    }
}

// MARK: - UICollectionViewDataSource

extension CreatingHabitViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        if section == 0 {
            return emojis.count
        } else if section == 1 {
            return colors.count
        }
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CreatingCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CreatingCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.section == 0 {
            let emoji = emojis[indexPath.row]
            cell.configure(with: emoji)
        } else if indexPath.section == 1 {
            let color = colors[indexPath.row]
            cell.configure(backgroundColor: color)
        }
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CreatingSupplementaryView.reuseIdentifier,
            for: indexPath
        ) as? CreatingSupplementaryView else { return UICollectionReusableView() }
        
        if indexPath.section == 0 {
            view.showNewTracker(with: "Emoji")
        } else if indexPath.section == 1 {
            view.showNewTracker(with: "Цвет")
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // deselect cell
            guard let cellToDeselect = collectionView.cellForItem(at: .init(item: selectedIndexEmoji ?? .zero, section: 0)) else { return }
            cellToDeselect.backgroundColor = .clear
            // select cell
            guard let cell = collectionView.cellForItem(at: indexPath) as? CreatingCollectionViewCell else { return }
            cell.layer.cornerRadius = 16
            cell.layer.masksToBounds = true
            cell.backgroundColor = .ypLightGray
            selectedEmoji = emojis[indexPath.row]
            selectedIndexEmoji = indexPath.item
        } else if indexPath.section == 1 {
            // deselect cell
            guard let cellToDeselect = collectionView.cellForItem(at: .init(item: selectedIndexColor ?? .zero, section: 1)) else { return }
            cellToDeselect.layer.borderWidth = .zero
            // select cell
            guard let cell = collectionView.cellForItem(at: indexPath) as? CreatingCollectionViewCell else { return }
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            cell.layer.borderColor = colors[indexPath.row].cgColor.copy(alpha: 0.3)
            cell.layer.borderWidth = 3
            selectedColor = colors[indexPath.row]
            selectedIndexColor = indexPath.item
        }
        ui.createButton.isEnabled = isSubmitButtonEnabled()
        if ui.createButton.isEnabled {
            ui.createButton.backgroundColor = .ypBlack
        } else {
            ui.createButton.backgroundColor = .ypGray
        }
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
        let scrollView: UIScrollView
        let contentView: UIView
        let emojisColorsCollectionView: UICollectionView
        let cancelButton: UIButton
        let createButton: UIButton
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let trackerNameTextField = UITextField()
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        trackerNameTextField.placeholder = "Введите название трекера"
        trackerNameTextField.layer.cornerRadius = 16
        trackerNameTextField.backgroundColor = .ypBackground
        trackerNameTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        trackerNameTextField.returnKeyType = .done
        trackerNameTextField.leftPadding(16)
        trackerNameTextField.delegate = self
        view.addSubview(trackerNameTextField)
        
        let contentsTableView = UITableView()
        contentsTableView.register(
            CustomTableViewCell.self,
            forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier
        )
        contentsTableView.translatesAutoresizingMaskIntoConstraints = false
        contentsTableView.layer.cornerRadius = 16
        contentsTableView.backgroundColor = .red
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
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        let emojisColorsCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        emojisColorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojisColorsCollectionView.isScrollEnabled = false
        emojisColorsCollectionView.register(
            CreatingCollectionViewCell.self,
            forCellWithReuseIdentifier: CreatingCollectionViewCell.reuseIdentifier
        )
        emojisColorsCollectionView.register(
            CreatingSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CreatingSupplementaryView.reuseIdentifier
        )
        emojisColorsCollectionView.delegate = self
        emojisColorsCollectionView.dataSource = self
        view.addSubview(emojisColorsCollectionView)
        
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
            scrollView: scrollView,
            contentView: contentView,
            emojisColorsCollectionView: emojisColorsCollectionView,
            cancelButton: cancelButton,
            createButton: createButton
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate( [
            ui.trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            ui.trackerNameTextField.topAnchor.constraint(equalTo: ui.contentView.topAnchor, constant: 24),
            ui.trackerNameTextField.leadingAnchor.constraint(equalTo: ui.contentView.leadingAnchor, constant: 16),
            ui.trackerNameTextField.trailingAnchor.constraint(equalTo: ui.contentView.trailingAnchor, constant: -16),
            
            ui.contentsTableView.heightAnchor.constraint(equalToConstant: isHabit ? 150 : 75),
            
            ui.contentsTableView.topAnchor.constraint(equalTo: ui.trackerNameTextField.bottomAnchor, constant: 24),
            ui.contentsTableView.leadingAnchor.constraint(equalTo: ui.contentView.leadingAnchor, constant: 16),
            ui.contentsTableView.trailingAnchor.constraint(equalTo: ui.contentView.trailingAnchor, constant: -16),
            
            ui.stackView.heightAnchor.constraint(equalToConstant: 60),
            ui.stackView.topAnchor.constraint(equalTo: ui.emojisColorsCollectionView.bottomAnchor, constant: 16),
            ui.stackView.leadingAnchor.constraint(equalTo: ui.contentView.leadingAnchor, constant: 20),
            ui.stackView.trailingAnchor.constraint(equalTo: ui.contentView.trailingAnchor, constant: -20),
            ui.stackView.bottomAnchor.constraint(equalTo: ui.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -34),
            
            ui.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ui.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ui.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ui.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            ui.contentView.topAnchor.constraint(equalTo: ui.scrollView.topAnchor),
            ui.contentView.leadingAnchor.constraint(equalTo: ui.scrollView.leadingAnchor),
            ui.contentView.trailingAnchor.constraint(equalTo: ui.scrollView.trailingAnchor),
            ui.contentView.bottomAnchor.constraint(equalTo: ui.scrollView.bottomAnchor),
            ui.contentView.widthAnchor.constraint(equalTo: ui.scrollView.widthAnchor),
            
            ui.emojisColorsCollectionView.topAnchor.constraint(equalTo: ui.contentsTableView.bottomAnchor, constant: 24),
            ui.emojisColorsCollectionView.leadingAnchor.constraint(equalTo: ui.contentView.leadingAnchor),
            ui.emojisColorsCollectionView.trailingAnchor.constraint(equalTo: ui.contentView.trailingAnchor),
            ui.emojisColorsCollectionView.heightAnchor.constraint(equalToConstant: 440)
        ])
        ui.scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 105)
    }
    
    func setupUI() {
        view.backgroundColor = .ypWhite
        setupNavBar()
        stackSubView()
    }
}
