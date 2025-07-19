//
//  AppDelegate.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 16.06.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // IException    NSException *    "Expected dequeued view to be returned to the collection view in preparation for display. When the collection view's data source is asked to provide a view for a given index path, ensure that a single view is dequeued and returned to the collection view. Avoid dequeuing views without a request from the collection view. For retrieving an existing view in the collection view, use -[UICollectionView cellForItemAtIndexPath:] or -[UICollectionView supplementaryViewForElementKind:atIndexPath:]. Dequeued view: <Tracker.SupplementaryView: 0x10563b4a0; baseClass = UICollectionReusableView; frame = (0 0; 0 0); alpha = 0; layer = <CALayer: 0x600000284920>>; Collection view: <UICollectionView: 0x106042e00; frame = (0 62; 402 729); clipsToBounds = YES; gestureRecognizers = <NSArray: 0x600000c859e0>; backgroundColor = <UIDynamicSystemColor: 0x600001766200; name = systemBackgroundColor>; layer = <CALayer: 0x60000027f020>; contentOffset: {0, 0}; contentSize: {402, 1030.3333333333333}; adjustedContentInset: {0, 0, 0, 0}; layo"    0x0000600000c7e790f any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

