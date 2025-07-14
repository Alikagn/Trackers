//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 01.07.2025.
//

import UIKit

// MARK: - ScheduleDelegate

protocol ScheduleDelegate: AnyObject {
    func delegateSchedule(days: [WeekDay])
}

// MARK: - ScheduleViewController

final class ScheduleViewController: UIViewController {
    
    // MARK: Public Property
    
    var delegate: ScheduleDelegate?
    var currentSchedule: [WeekDay] = []
    
    // MARK: Private Property
    
    private var weekdays: [WeekDay] = []
    
    private lazy var downButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.down") ?? UIImage(systemName: "arrowshape.down"),
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        button.tintColor = Colors.black
        button.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        return button
    }()
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
}

// MARK: - Private Methods

private extension ScheduleViewController {
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = downButton
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    func setupNavBar() {
        navigationItem.title = "Расписание"
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.ypBlack
            ]
        }
    }
    
    func statusDay() {
        for (index, day) in WeekDay.allCases.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = ui.scheduleTableView.cellForRow(at: indexPath)
            guard let switchButton = cell?.accessoryView as? UISwitch else { return }
            
            if switchButton.isOn {
                weekdays.append(day)
            } else {
                weekdays.removeAll { $0 == day }
            }
        }
    }
    
    @objc func didTapButton() {
        statusDay()
        delegate?.delegateSchedule(days: weekdays)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == WeekDay.allCases.count - 1 {
            return 76
        } else {
            return 75
        }
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = Colors.background
        let switchButton = UISwitch(frame: .zero)
        let switchIsOn = currentSchedule.contains(WeekDay.allCases[indexPath.row])
        switchButton.setOn(switchIsOn, animated: true)
        switchButton.onTintColor = .ypBlue
        switchButton.tag = indexPath.row
        cell.accessoryView = switchButton
        cell.configure(with: WeekDay.allCases[indexPath.row])
        
        return cell
    }
}

// MARK: - UI Configuring

extension ScheduleViewController {
    
    // MARK: UI components
    
    struct UI {
        let scheduleTableView: UITableView
        let donebutton: UIButton
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let scheduleTableView = UITableView()
        scheduleTableView.register(
            CustomTableViewCell.self,
            forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier
        )
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        scheduleTableView.layer.cornerRadius = 16
        scheduleTableView.backgroundColor = .ypBackground
        scheduleTableView.separatorStyle = .none
        scheduleTableView.layer.masksToBounds = true
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        view.addSubview(scheduleTableView)
        
        let donebutton = UIButton()
        donebutton.translatesAutoresizingMaskIntoConstraints = false
        donebutton.layer.cornerRadius = 16
        donebutton.backgroundColor = .ypBlack
        donebutton.setTitle("Готово", for: .normal)
        donebutton.setTitleColor(.ypWhite, for: .normal)
        donebutton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        donebutton.addTarget(
            self,
            action: #selector(didTapButton),
            for: .touchUpInside
        )
        view.addSubview(donebutton)
        
        return .init(
            scheduleTableView: scheduleTableView,
            donebutton: donebutton
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate([
            
            ui.scheduleTableView.heightAnchor.constraint(equalToConstant: 525),
            ui.scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            ui.scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ui.scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            ui.donebutton.heightAnchor.constraint(equalToConstant: 60),
            ui.donebutton.topAnchor.constraint(equalTo: ui.scheduleTableView.bottomAnchor, constant: 47),
            ui.donebutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ui.donebutton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func setupUI() {
        view.backgroundColor = .ypWhite
        print(ui.donebutton.titleLabel?.text)
        setupNavBar()
    }
}
/*
import UIKit

final class ScheduleViewController: UIViewController {
    
    var currentSchedule: [WeekDay] = []

    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.black
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        table.isScrollEnabled = false
        table.layer.cornerRadius = 16
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.separatorColor = Colors.gray
        return table
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = Colors.black
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Colors.white, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var downButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.down") ?? UIImage(systemName: "arrowshape.down"),
            style: .plain,
            target: self,
            action: #selector(doneButtonTapped)
        )
        button.tintColor = Colors.black
        button.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        return button
    }()
    
    private let daysOfWeek = WeekDay.allCases
    var selectedDays: Set<WeekDay> = []
    var onScheduleSelected: ((Set<WeekDay>) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        setupViews()
        setupConstraints()
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = downButton
    }
    
    private func setupViews() {
        [titleLabel, tableView, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(daysOfWeek.count * 75)),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func doneButtonTapped() {
        onScheduleSelected?(selectedDays)
        dismiss(animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleCell.reuseIdentifier,
            for: indexPath
        ) as? ScheduleCell else {
            return UITableViewCell()
        }
        let switchIsOn = currentSchedule.contains(WeekDay.allCases[indexPath.row])
        let day = daysOfWeek[indexPath.row]
        cell.configure(with: day, isOn: selectedDays.contains(day))
        
        cell.onSwitchChanged = { [weak self] isOn in
            if isOn {
                self?.selectedDays.insert(day)
            } else {
                self?.selectedDays.remove(day)
            }
        }
        
        cell.separatorInset = indexPath.row == daysOfWeek.count - 1 ?
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude) :
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
*/

