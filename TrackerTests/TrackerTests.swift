//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Dmitry Batorevich on 10.08.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testLightTheme() {
        let vc = TrackersViewController()
        vc.overrideUserInterfaceStyle = .light
        vc.loadViewIfNeeded()
        
        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13), 
            named: "LightTheme"
        )
    }
   
    func testDarkTheme() {
        let viewController = TrackersViewController()
        viewController.overrideUserInterfaceStyle = .dark
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "DarkTheme",
            record: true // Переключатель записи/проверки
        )
    }
     
}
