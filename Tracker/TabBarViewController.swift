//
//  ViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 16.06.2025.
//

 import UIKit

 // MARK: - TabBarController

 final class TabBarController: UITabBarController, UITabBarControllerDelegate {
     
     // MARK: Lifecycle
     
     override func viewDidLoad() {
         super.viewDidLoad()
         self.delegate = self
         setupViewControllers()
         setupUI()
     }
     
     // UITabBarControllerDelegate method
     func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         print("Выбрано: \(String(describing: viewController.title))")
     }
 }

 // MARK: - Private Methods

 private extension TabBarController {
     func setupViewControllers() {
         let trackersVC = TrackersViewController()
         let trackersNavVC = UINavigationController(rootViewController: trackersVC)
         trackersVC.tabBarItem = UITabBarItem(
             title: "Трекеры",
             image: ImageConstants.tabTrackerActive,
             selectedImage: nil
         )
         
         let statisticsVC = StatisticViewController()
         let statisticsNavVC = UINavigationController(rootViewController: statisticsVC)
         statisticsNavVC.navigationItem.titleView = UIView()
         statisticsVC.tabBarItem = UITabBarItem(
             title: "Статистика",
             image: ImageConstants.tabStatisticActive,
             selectedImage: nil
         )
         self.viewControllers = [trackersNavVC, statisticsNavVC]
     }
 }

 // MARK: - UI Configuring

 private extension TabBarController {
     func setupUI() {
         view.backgroundColor = Colors.white
         separator()
     }
     
     func separator() {
         let separator = UIView(frame: CGRect(
             x: 0,
             y: -0.5,
             width: tabBar.frame.width,
             height: 1
         ))
         separator.backgroundColor = Colors.gray
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

