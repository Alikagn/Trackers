//
//  CustomTableViewCell.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 12.07.2025.
//

import UIKit

// MARK: - CustomTableViewCell

final class CustomTableViewCell: UITableViewCell {
    
    // MARK: Public Property
    
    static let reuseIdentifier = "CustomCell"
    
    // MARK: Private Property
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension CustomTableViewCell {
    
    func configure(with text: String, isCategory: Bool, subtitle: String? = nil) {
        setupUI()
        ui.titleLabel.text = text
        if let subtitle {
            ui.subtitleLabel.text = subtitle
        } else {
            ui.subtitleLabel.text = String()
        }
        layoutIfNeeded()
    }
    
    func configure(with day: WeekDay) {
        setupUI()
        ui.titleLabel.text = day.day
    }
}

// MARK: - UI Configuring

extension CustomTableViewCell {
    
    // MARK: UI components
    
    struct UI {
        let mainStackView: UIStackView
        let titleLabel: UILabel
        let subtitleLabel: UILabel
        let separatorLine: UIView
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.alignment = .leading
        mainStackView.spacing = 4
        mainStackView.distribution = .equalSpacing
        contentView.addSubview(mainStackView)
        
        let customLabel = UILabel()
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        customLabel.numberOfLines = .zero
        customLabel.sizeThatFits(mainStackView.bounds.size)
        customLabel.font = .systemFont(ofSize: 17, weight: .regular)
        customLabel.textAlignment = .left
        mainStackView.addArrangedSubview(customLabel)
        
        let subTextLabel = UILabel()
        subTextLabel.translatesAutoresizingMaskIntoConstraints = false
        subTextLabel.numberOfLines = .zero
        subTextLabel.font = .systemFont(ofSize: 17, weight: .regular)
        subTextLabel.textAlignment = .left
        subTextLabel.textColor = .ypGray
        mainStackView.addArrangedSubview(subTextLabel)
        
        let separatorLine = UIView()
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.backgroundColor = UIColor(
            red: 210/255,
            green: 210/255,
            blue: 210/255,
            alpha: 1
        )
        contentView.addSubview(separatorLine)
        
        return .init(
            mainStackView: mainStackView,
            titleLabel: customLabel,
            subtitleLabel: subTextLabel,
            separatorLine: separatorLine
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate([
            ui.mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ui.mainStackView.centerYAnchor.constraint(lessThanOrEqualTo: contentView.centerYAnchor),
            
            ui.separatorLine.heightAnchor.constraint(equalToConstant: 1),
            ui.separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ui.separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ui.separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setupUI() {
        backgroundColor = Colors.background
    }
}
