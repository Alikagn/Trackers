//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 23.07.2025.
//

import UIKit

// MARK: - SupplementaryView

final class SupplementaryView: UICollectionReusableView {
    
    // MARK: Public Property
    
    static let reuseIdentifier = "trackerSupplementaryView"
    
    // MARK: Private Property
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showNewTracker(with title: String) {
        ui.titleLabel.text = title
    }
}

// MARK: - UI Configuring

extension SupplementaryView {
    
    // MARK: UI components
    
    struct UI {
        
        let titleLabel: UILabel
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.frame = bounds
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = .ypBlack
        addSubview(titleLabel)
        
        return .init(
            titleLabel: titleLabel
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate( [
            ui.titleLabel.topAnchor.constraint(equalTo: topAnchor),
            ui.titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            ui.titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            ui.titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
