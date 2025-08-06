//
//  AppDelegate.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 16.06.2025.
//

import CoreData
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        checkCoreDataInitialization()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func checkCoreDataInitialization() {
        let container = persistentContainer
        print("Core Data контейнер загружен успешно")
        print("Имя модели: \(container.name)")
        print("Количество хранилищ: \(container.persistentStoreDescriptions.count)")
        
        let context = container.viewContext
        print("Контекст доступен: \(context)")
        
        do {
            let count = try context.count(for: TrackerCoreData.fetchRequest())
            print("Количество трекеров в базе: \(count)")
        } catch {
            print("Ошибка при проверке Core Data: \(error)")
        }
    }
}
