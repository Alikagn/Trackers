//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 16.06.2025.
//
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        // Проверка, показывать ли стартовый экран
        let hasSeenOnboarding = UserDefaultsService.shared.hasSeenOnboarding
        
        if hasSeenOnboarding {
            // Уже заходили, показать основной интерфейс
            let tabBarController = TabBarController()
            window?.rootViewController = tabBarController
        } else {
            // Первый запуск, показать стартовый экран
            let startViewController = StartViewController()
            startViewController.onboardingCompletionHandler = { [weak self] in
                // После завершения стартового экрана, сохраняем флаг
                UserDefaultsService.shared.hasSeenOnboarding = true
                let tabBarController = TabBarController()
                self?.window?.rootViewController = tabBarController
            }
            window?.rootViewController = startViewController
        }
        
        window?.makeKeyAndVisible()
    }
    
}
