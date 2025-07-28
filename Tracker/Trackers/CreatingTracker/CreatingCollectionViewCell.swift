//
//  CreatingCollectionViewCell.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 15.07.2025.
//

import UIKit

// MARK: - CreatingCollectionViewCell

final class CreatingCollectionViewCell: UICollectionViewCell {
    
    // MARK: Public Property
    
    static let reuseIdentifier = "CreatingCell"
    
    // MARK: Private Property
    
    private lazy var ui: CellUI = {
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
}

// MARK: - Public Methods

extension CreatingCollectionViewCell {
    
    func configure(with emoji: String? = nil, backgroundColor: UIColor? = nil) {
        ui.creatingNameLabel.text = emoji
        ui.creatingNameLabel.backgroundColor = backgroundColor ?? .clear
    }
}

// MARK: - CellUI Configuring

extension CreatingCollectionViewCell {
    
    // MARK: CellUI components
    
    struct CellUI {
        let creatingNameLabel: UILabel
    }
    
    // MARK: Creating CellUI components
    
    func createUI() -> CellUI {
        
        let creatingNameLabel = UILabel()
        creatingNameLabel.translatesAutoresizingMaskIntoConstraints = false
        creatingNameLabel.layer.cornerRadius = 8
        creatingNameLabel.layer.masksToBounds = true
        creatingNameLabel.textAlignment = .center
        creatingNameLabel.font = .systemFont(ofSize: 32, weight: .bold)
        contentView.addSubview(creatingNameLabel)
        
        return .init(
            creatingNameLabel: creatingNameLabel
        )
    }
    
    // MARK: CellUI component constants
    
    func layout(_ ui: CellUI) {
        
        NSLayoutConstraint.activate( [
            
            ui.creatingNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            ui.creatingNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            ui.creatingNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            ui.creatingNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
}
