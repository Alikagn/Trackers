//
//  CreatingSupplementaryView.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 15.07.2025.
//

import UIKit

// MARK: - CreatingSupplementaryView

final class CreatingSupplementaryView: UICollectionReusableView {
    
    // MARK: Public Property
    
    static let reuseIdentifier = "creatingSupplementaryView"
    
    // MARK: Private Property
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Constructor

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension CreatingSupplementaryView {
    
    func showNewTracker(with title: String) {
        ui.creatingTitleLabel.text = title
    }
}

// MARK: - UI Configuring

private extension CreatingSupplementaryView {
    
    // MARK: UI components
    
    struct UI {
        
        let creatingTitleLabel: UILabel
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        let creatingTitleLabel = UILabel()
        creatingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        creatingTitleLabel.frame = bounds
        creatingTitleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        creatingTitleLabel.textColor = .ypBlack
        addSubview(creatingTitleLabel)
        
        return .init(
            creatingTitleLabel: creatingTitleLabel
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate( [
            ui.creatingTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            ui.creatingTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            ui.creatingTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 28),
            ui.creatingTitleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
