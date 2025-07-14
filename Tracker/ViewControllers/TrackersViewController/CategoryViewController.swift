//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 12.07.2025.
//

import UIKit

// MARK: - CategoryViewControllerDelegate

protocol CategoryViewControllerDelegate: AnyObject {
    func categoryViewControllerDidSelectCategories(_ category: String, categories: [String])
}

// MARK: - CategoryViewController

final class CategoryViewController: UIViewController {
    
    // MARK: Public Property
    
    weak var delegate: CategoryViewControllerDelegate?
    var contentsCategory: [String] = []
    
    // MARK: Private Property
    
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
    
    private var selectedCategories: Set<String> = []
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUIForCategory()
    }
}

// MARK: - Private Methods

private extension CategoryViewController {
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    func setupNavBar() {
        navigationItem.leftBarButtonItem = downButton
        navigationItem.title = "Категория"
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.ypBlack
            ]
        }
    }
    
    func showHiddenImage() {
        ui.lackOfTrackersImageView.isHidden = false
        ui.lackOfTrackersLabel.isHidden = false
        ui.categoryTableView.isHidden = true
    }
    
    func hideHiddenImage() {
        ui.lackOfTrackersImageView.isHidden = true
        ui.lackOfTrackersLabel.isHidden = true
        ui.categoryTableView.isHidden = false
    }
    
    func updateUIForCategory() {
        if contentsCategory.isEmpty {
            showHiddenImage()
        } else {
            hideHiddenImage()
        }
    }
    
    @objc func didTapNewCategoryButton() {
        let controller = NewCategoryViewController()
        controller.delegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        
        navigationController.modalPresentationStyle = .popover
        self.present(navigationController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // нажатие на ячейку
        let categoryName = contentsCategory[indexPath.row]
        
        if selectedCategories.contains(categoryName) {
            selectedCategories.remove(categoryName)
        } else {
            selectedCategories.insert(categoryName)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
        delegate?.categoryViewControllerDidSelectCategories(
            categoryName,
            categories: contentsCategory
        )
    }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsCategory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdent", for: indexPath)
        let categoryName = contentsCategory[indexPath.row]
        cell.textLabel?.text = categoryName
        cell.backgroundColor = .ypBackground
        
        if selectedCategories.contains(categoryName) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

// MARK: - UI Configuring

extension CategoryViewController {
    
    // MARK: UI components
    
    struct UI {
        let categoryTableView: UITableView
        let lackOfTrackersImageView: UIImageView
        let lackOfTrackersLabel: UILabel
        let newCategoryButton: UIButton
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let categoryTableView = UITableView()
        categoryTableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "reuseIdent"
        )
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        categoryTableView.layer.cornerRadius = 16
        categoryTableView.backgroundColor = .ypWhite
        categoryTableView.separatorStyle = .none
        categoryTableView.layer.masksToBounds = true
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        view.addSubview(categoryTableView)
        
        let lackOfTrackersImageView = UIImageView()
        lackOfTrackersImageView.translatesAutoresizingMaskIntoConstraints = false
        lackOfTrackersImageView.image = ImageConstants.lackOfTrackersImageView
        view.addSubview(lackOfTrackersImageView)
        
        let lackOfTrackersLabel = UILabel()
        lackOfTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        lackOfTrackersLabel.numberOfLines = 2
        lackOfTrackersLabel.text = "Привычки и события можно\n объединить по смыслу"
        lackOfTrackersLabel.textAlignment = .center
        lackOfTrackersLabel.font = FontsConstants.lackOfTrackersLabel
        lackOfTrackersLabel.textColor = .ypBlack
        view.addSubview(lackOfTrackersLabel)
        
        let newCategoryButton = UIButton()
        newCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        newCategoryButton.layer.cornerRadius = 16
        newCategoryButton.backgroundColor = .ypBlack
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
            categoryTableView: categoryTableView,
            lackOfTrackersImageView: lackOfTrackersImageView,
            lackOfTrackersLabel: lackOfTrackersLabel,
            newCategoryButton: newCategoryButton
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate([
            
            ui.categoryTableView.bottomAnchor.constraint(equalTo: ui.newCategoryButton.topAnchor, constant: -8),
            ui.categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            ui.categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ui.categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            ui.lackOfTrackersImageView.widthAnchor.constraint(equalToConstant: 80),
            ui.lackOfTrackersImageView.heightAnchor.constraint(equalToConstant: 80),
            ui.lackOfTrackersImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ui.lackOfTrackersImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            ui.lackOfTrackersLabel.topAnchor.constraint(equalTo: ui.lackOfTrackersImageView.bottomAnchor, constant: 8),
            ui.lackOfTrackersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ui.newCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            ui.newCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            ui.newCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ui.newCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func setupUI() {
        view.backgroundColor = Colors.white
        setupNavBar()
    }
}

// MARK: - NewCategoryViewControllerDelegate

extension CategoryViewController: NewCategoryViewControllerDelegate {
    func didCreateNewCategory(withName name: String) {
        if !contentsCategory.contains(name) {
            contentsCategory.append(name)
            ui.categoryTableView.reloadData()
            updateUIForCategory()
        }
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
        static let lackOfTrackersImageView = UIImage(named: "lackOfTrackers")
    }
}
