//
//  ViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 16.06.2025.
//

import UIKit

final class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs() {
        
        // Trackers
        let tabTracker = TrackersViewController()
        let tabOneBarItem = UITabBarItem(
            title: "Трекер",
            image: UIImage(named: "trackers"),
            selectedImage: nil
        )
        
        tabTracker.tabBarItem = tabOneBarItem
        let trackersNavVC = UINavigationController(rootViewController: tabTracker)
        
        // Statistics
        let tabStatistic = StatisticViewController()
        let tabTwoBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "stats"),
            selectedImage: nil
        )
        
        tabStatistic.tabBarItem = tabTwoBarItem
        let statisticsNavVC = UINavigationController(rootViewController: tabStatistic)
        viewControllers = [trackersNavVC, statisticsNavVC]
    }
    
    private func setupAppearance() {
        let topline = CALayer()
        topline.frame = CGRect(x: 0, y: 0, width: self.tabBar.frame.width, height: 1)
        topline.backgroundColor = UIColor.gray.cgColor
        self.delegate = self
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.layer.masksToBounds = true
        self.tabBar.layer.addSublayer(topline)
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Выбрано: \(String(describing: viewController.title))")
    }
}

// MARK: FontsConstants

enum FontsConstants {
    static let startLabelText: UIFont = UIFont.systemFont(ofSize: 32, weight: .bold)
    static let label: UIFont = UIFont.systemFont(ofSize: 34, weight: .bold)
    static let searchTextField: UIFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let cometTextLabel: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
}

/*
 override func viewDidLoad() {
     super.viewDidLoad()
 // Создание линий:
 let topline = CALayer()
 topline.frame = CGRect(x: 0, y: 0, ширина: self.tabBar.frame.width, высота: 2)
 topline.backgroundColor = UIColor.gray.CGColor
 self.tabBar.layer.addSublayer(topline)
 let firstVerticalLine = CALayer()
 firstVerticalLine.frame = CGRect(x: self.tabBar.frame.width / 5, y: 0, ширина: 2, высота: self.tabBar.frame.height)
 firstVerticalLine.backgroundColor = UIColor.gray.CGColor
 self.tabBar.layer.addSublayer(firstVerticalLine)
 // Продолжать добавлять другие линии для разделения элементов вкладки...
 }
 */
