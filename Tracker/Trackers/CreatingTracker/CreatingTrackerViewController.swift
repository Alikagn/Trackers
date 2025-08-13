//
//  CreatingTrackerViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 12.07.2025.
//

import UIKit

// MARK: - CreatingTrackerViewControllerDelegate

protocol CreatingTrackerViewControllerDelegate: AnyObject {
    func updateTracker(tracker: Tracker, for category: String)
    func sendTracker(tracker: Tracker, for category: String)
}

// MARK: - CreatingTrackerViewController

final class CreatingTrackerViewController: UIViewController {
    
    // MARK: Public Property
    
    weak var delegate: TrackersViewControllerDelegate?
    var trackers: [Tracker] = []
    
    // MARK: Private Property
    
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

private extension CreatingTrackerViewController {
    
    func setupNavBar() {
        title = NSLocalizedString("creatingNavigationItem.title", comment: "")
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.ypBlack
            ]
        }
    }
    
    @objc func didTapHabitButton() {
        let controller = CreatingHabitViewController(isHabit: true, tracker: nil)
        let navigationController = UINavigationController(rootViewController: controller)
        controller.delegate = self
        navigationController.modalPresentationStyle = .popover
        self.present(navigationController, animated: true)
    }
    
    @objc func didTapIrregularEventButton() {
        let controller = CreatingHabitViewController(isHabit: false, tracker: nil)
        let navigationController = UINavigationController(rootViewController: controller)
        controller.delegate = self
        navigationController.modalPresentationStyle = .popover
        self.present(navigationController, animated: true)
    }
}

// MARK: - CreatingTrackerViewControllerDelegate

extension CreatingTrackerViewController: CreatingTrackerViewControllerDelegate {
    func updateTracker(tracker: Tracker, for category: String) {
        if let index = trackers.firstIndex(where: { $0.trackerID == tracker.trackerID }) {
            trackers[index] = tracker
            print("Трекер обновлен: \(tracker.name)")
        } else {
            print("Трекер не найден для обновления")
        }
    }
    
    func sendTracker(tracker: Tracker, for category: String) {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            delegate?.tracker(tracker: tracker, for: category)
        }
    }
}

// MARK: - UI Configuring

private extension CreatingTrackerViewController {
    
    // MARK: UI components
    
    struct UI {
        let habitButton: UIButton
        let irregularEventButton: UIButton
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let habitButton = UIButton(type: .system)
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.backgroundColor = .ypBlack
        habitButton.setTitleColor(.ypWhite, for: .normal)
        habitButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        habitButton.setTitle(NSLocalizedString("regularButton.setTitle", comment: ""), for: .normal)
        habitButton.layer.cornerRadius = 16
        habitButton.addTarget(
            self,
            action: #selector(didTapHabitButton),
            for: .touchUpInside
        )
        view.addSubview(habitButton)
        
        let irregularEventButton = UIButton(type: .system)
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        irregularEventButton.backgroundColor = .ypBlack
        irregularEventButton.setTitleColor(.ypWhite, for: .normal)
        irregularEventButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        irregularEventButton.setTitle(NSLocalizedString("irregularButton.setTitle", comment: ""), for: .normal)
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.addTarget(
            self,
            action: #selector(didTapIrregularEventButton),
            for: .touchUpInside
        )
        view.addSubview(irregularEventButton)
        
        return .init(
            habitButton: habitButton,
            irregularEventButton: irregularEventButton
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate( [
            
            ui.habitButton.heightAnchor.constraint(equalToConstant: 60),
            ui.habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ui.habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ui.habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            ui.irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            ui.irregularEventButton.topAnchor.constraint(equalTo: ui.habitButton.bottomAnchor, constant: 16),
            ui.irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ui.irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupUI() {
        view.backgroundColor = .ypWhite
        setupNavBar()
        print(ui.habitButton.titleLabel?.text ?? String())
    }
}
