//
//  ViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 16.06.2025.
//

import UIKit

// MARK: - TabBarController

final class TabBarController: UITabBarController {
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupUI()
    }
}

// MARK: - Private Methods

private extension TabBarController {
    func setupViewControllers() {
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: ImageConstants.tabTrackerActive,
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: ImageConstants.tabStatisticActive,
            selectedImage: nil
        )
        self.viewControllers = [trackersViewController, statisticsViewController]
    }
}

// MARK: - UI Configuring

private extension TabBarController {
    func setupUI() {
        view.backgroundColor = .ypWhite
        separator()
    }
    
    func separator() {
        let separator = UIView(frame: CGRect(
            x: 0,
            y: -0.5,
            width: tabBar.frame.width,
            height: 1
        ))
        separator.backgroundColor = .ypGray
        separator.backgroundColor?.withAlphaComponent(20)
        tabBar.addSubview(separator)
    }
}

// MARK: - Constants

private extension TabBarController {
    
    // MARK: ImageConstants
    
    enum ImageConstants {
        static let tabTrackerActive = UIImage(named: "trackers")
        static let tabStatisticActive = UIImage(named: "stats")
    }
}
