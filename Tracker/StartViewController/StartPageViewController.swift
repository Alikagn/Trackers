//
//  StartPageViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 05.08.2025.
//

import UIKit

// MARK: - StartPageViewController

final class StartPageViewController: UIViewController {
    
    // MARK: Private Property
    
    private let backgroundName: String
    private let startLabel: String
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Constructor
    
    init(backgroundName: String, startLabel: String) {
        self.backgroundName = backgroundName
        self.startLabel = startLabel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - UI Configuring

private extension StartPageViewController {
    
    // MARK: UI components
    
    struct UI {
        
        let backgroundImageView: UIImageView
        let startLabelText: UILabel

    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        let startLabelText = UILabel()
        startLabelText.translatesAutoresizingMaskIntoConstraints = false
        startLabelText.numberOfLines = 0
        startLabelText.textAlignment = .center
        startLabelText.font = FontsConstants.startLabelText
        startLabelText.textColor = .ypBlack
        view.addSubview(startLabelText)
        
        return .init(
            backgroundImageView: backgroundImageView,
            startLabelText: startLabelText
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate( [
            
            ui.backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            ui.backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ui.backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ui.backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            ui.startLabelText.topAnchor.constraint(equalTo: ui.backgroundImageView.topAnchor, constant: 432),
            ui.startLabelText.leadingAnchor.constraint(equalTo: ui.backgroundImageView.leadingAnchor, constant: 16),
            ui.startLabelText.trailingAnchor.constraint(equalTo: ui.backgroundImageView.trailingAnchor, constant: -16),
            
        ])
    }
    
    func setupUI() {
        view.backgroundColor = .ypWhite
        ui.backgroundImageView.image = UIImage(named: backgroundName)
        ui.startLabelText.text = startLabel
    }
}

// MARK: - Constants

private extension StartPageViewController {
    
    // MARK: FontsConstants
    
    enum FontsConstants {
        static let startLabelText: UIFont = UIFont.systemFont(ofSize: 32, weight: .bold)
    }
    
    // MARK: ImageConstants
    
    enum ImageConstants {
        static let backgroundImage = UIImage(named: "backgroundBlueImage")
    }
}

