//
//  CardStats.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 09.08.2025.
//

import UIKit

// MARK: - CardStats

final class CardStats: UIView {
    
    // MARK: Private Property
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Constructor
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
}

// MARK: - Public Methods

extension CardStats {
    
    func updateView(
        number: String,
        name: String
    ) {
        ui.statsTitleLabel.text = number
        ui.statsLabel.text = name
        
        setupGradient()
    }
}

// MARK: - Private Methods

private extension CardStats {
    
    func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(named: "ColorSelection1")?.cgColor ?? UIColor(),
            UIColor(named: "ColorSelection9")?.cgColor ?? UIColor(),
            UIColor(named: "ColorSelection3")?.cgColor ?? UIColor()
        ]
        gradientLayer.frame = .init(
            x: .zero,
            y: .zero,
            width: UIScreen.main.bounds.width - 32,
            height: 90
        )
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - UI Configuring

private extension CardStats {
    
    // MARK: UI components
    
    struct UI {
        
        let cardStatsView: UIView
        let statsTitleLabel: UILabel
        let statsLabel: UILabel
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        let cardStatsView = UIView()
        cardStatsView.translatesAutoresizingMaskIntoConstraints = false
        cardStatsView.backgroundColor = .ypWhite
        cardStatsView.clipsToBounds = true
        cardStatsView.layer.cornerRadius = 15
        addSubview(cardStatsView)
        
        let largeTitleLabel = UILabel()
        largeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        largeTitleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        largeTitleLabel.textColor = .ypBlack
        largeTitleLabel.textAlignment = .left
        cardStatsView.addSubview(largeTitleLabel)
        
        let statsLabel = UILabel()
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        statsLabel.font = .systemFont(ofSize: 12, weight: .medium)
        statsLabel.textColor = .ypBlack
        statsLabel.textAlignment = .left
        cardStatsView.addSubview(statsLabel)
        
        return .init(
            cardStatsView: cardStatsView,
            statsTitleLabel: largeTitleLabel,
            statsLabel: statsLabel
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate( [
            ui.cardStatsView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            ui.cardStatsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            ui.cardStatsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
            ui.cardStatsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1),
            
            ui.statsTitleLabel.heightAnchor.constraint(equalToConstant: 41),
            ui.statsTitleLabel.leadingAnchor.constraint(equalTo: ui.cardStatsView.leadingAnchor, constant: 11),
            ui.statsTitleLabel.topAnchor.constraint(equalTo: ui.cardStatsView.topAnchor, constant: 11),
            
            ui.statsLabel.heightAnchor.constraint(equalToConstant: 18),
            ui.statsLabel.topAnchor.constraint(equalTo: ui.statsTitleLabel.bottomAnchor, constant: 7),
            ui.statsLabel.leadingAnchor.constraint(equalTo: ui.cardStatsView.leadingAnchor, constant: 11)
        ])
    }
    
    func setupUI() {
        clipsToBounds = true
        layer.cornerRadius = 16
    }
}
