//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 09.08.2025.
//

import UIKit

// MARK: - FiltersViewControllerDelegate

protocol FiltersViewControllerDelegate: AnyObject {
    func didSelectFilter(_ filter: String)
    func didDeselectFilter()
}

// MARK: - FiltersViewController

final class FiltersViewController: UIViewController {
    
    // MARK: Public Properties
    
    weak var delegate: FiltersViewControllerDelegate?
    var currentFilter: String?
    
    // MARK: Private Properties
    
    private let filters = [
        NSLocalizedString("All trackers", comment: ""),
        NSLocalizedString("Trackers for today", comment: ""),
        NSLocalizedString("Completed", comment: ""),
        NSLocalizedString("Not completed", comment: "")
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
}

// MARK: - UITableViewDataSource

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .ypBackground
        cell.separatorInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16
        )
        
        cell.textLabel?.text = filters[indexPath.row]
        
        if currentFilter == filters[indexPath.row] {
            self.ui.filtersTable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            cell.isSelected = true
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 75
    }
}

// MARK: - UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let selectedFilter = filters[indexPath.row]
        
        if currentFilter == selectedFilter {
            self.dismiss(animated: true)
            return
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        delegate?.didSelectFilter(selectedFilter)
        self.dismiss(animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        didDeselectRowAt indexPath: IndexPath
    ) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == filters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

// MARK: - UI Configuring

private extension FiltersViewController {
    
    // MARK: UI components
    
    struct UI {
        
        let viewTitle: UILabel
        let filtersTable: UITableView
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        let viewTitle = UILabel()
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.textColor = UIColor(named: "Black")
        viewTitle.textAlignment = .center
        viewTitle.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        viewTitle.text = NSLocalizedString("viewTitle.text", comment: "")
        view.addSubview(viewTitle)
        
        let filtersTable = UITableView()
        filtersTable.translatesAutoresizingMaskIntoConstraints = false
        filtersTable.backgroundColor = .ypWhite
        filtersTable.layer.cornerRadius = 16
        filtersTable.layer.masksToBounds = true
        filtersTable.separatorStyle = .singleLine
        filtersTable.tableHeaderView = UIView()
        filtersTable.separatorColor = .ypGray
        filtersTable.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier)
        view.addSubview(filtersTable)
        
        return .init(
            viewTitle: viewTitle,
            filtersTable: filtersTable
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate([
            ui.viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ui.viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            ui.viewTitle.heightAnchor.constraint(equalToConstant: 22),
            
            ui.filtersTable.topAnchor.constraint(equalTo: ui.viewTitle.bottomAnchor, constant: 24),
            ui.filtersTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ui.filtersTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ui.filtersTable.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    func setupUI() {
        view.backgroundColor = .ypWhite
        
        ui.filtersTable.dataSource = self
        ui.filtersTable.delegate = self
    }
}
