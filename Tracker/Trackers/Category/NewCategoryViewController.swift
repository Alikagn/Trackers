//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 12.07.2025.
//

import UIKit

// MARK: - NewCategoryViewControllerDelegate

protocol NewCategoryViewControllerDelegate: AnyObject {
    func didCreateNewCategory(withName name: TrackerCategory)
}

// MARK: - NewCategoryViewController

final class NewCategoryViewController: UIViewController {
    
    // MARK: Public Property
    
    weak var delegate: NewCategoryViewControllerDelegate?
    
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

private extension NewCategoryViewController {
    func setupNavBar() {
        navigationItem.title = "Новая категория"
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.ypBlack
            ]
        }
    }
    
    func isSubmitButtonEnabled() -> Bool {
        !(ui.newCategoryTextField.text?.isEmpty ?? false)
    }
    
    @objc func didTapNewCategoryButton() {
        if let newCategoryName = ui.newCategoryTextField.text, !newCategoryName.isEmpty {
            let newCategory = TrackerCategory(headingCategory: newCategoryName, trackers: [])
            delegate?.didCreateNewCategory(withName: newCategory)
        }
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension NewCategoryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        ui.newCategoryButton.isEnabled = isSubmitButtonEnabled()
        if ui.newCategoryButton.isEnabled {
            ui.newCategoryButton.backgroundColor = .ypBlack
        } else {
            ui.newCategoryButton.backgroundColor = .ypGray
        }
        return true
    }
}

// MARK: - UI Configuring

private extension NewCategoryViewController {
    
    // MARK: UI components
    
    struct UI {
        let newCategoryTextField: UITextField
        let newCategoryButton: UIButton
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let newCategoryTextField = UITextField()
        newCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        newCategoryTextField.placeholder = "  Введите название категории"
        newCategoryTextField.layer.cornerRadius = 16
        newCategoryTextField.backgroundColor = .ypBackground
        newCategoryTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        newCategoryTextField.leftPadding(16)
        newCategoryTextField.delegate = self
        view.addSubview(newCategoryTextField)
        
        let newCategoryButton = UIButton()
        newCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        newCategoryButton.isEnabled = false
        newCategoryButton.layer.cornerRadius = 16
        newCategoryButton.backgroundColor = .ypGray
        newCategoryButton.setTitle("Добавить категорию", for: .normal)
        newCategoryButton.setTitleColor(.ypWhite, for: .normal)
        newCategoryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        newCategoryButton.addTarget(
            self,
            action: #selector(didTapNewCategoryButton),
            for: .touchUpInside
        )
        view.addSubview(newCategoryButton)
        
        return .init(
            newCategoryTextField: newCategoryTextField,
            newCategoryButton: newCategoryButton
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate([
            
            ui.newCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            ui.newCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            ui.newCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ui.newCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            ui.newCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            ui.newCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            ui.newCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ui.newCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func setupUI() {
        view.backgroundColor = .ypWhite
        setupNavBar()
        print(ui.newCategoryTextField.text ?? String())
    }
}

// MARK: - Constants

private extension CategoryViewController {
    
    // MARK: FontsConstants
    
    enum FontsConstants {
        static let lackOfTrackersLabel: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    // MARK: ImageConstants
    
    enum ImageConstants {
        static let plusButton = UIImage(named: "plus") ?? UIImage()
        static let lackOfTrackersImageView = UIImage(named: "Comet")
    }
}
