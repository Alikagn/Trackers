//
//  KeyboardHandler.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 01.07.2025.
//

import UIKit

// MARK: - Public Methods
final class KeyboardHandler: NSObject, UITextFieldDelegate {
    func setup(for viewController: UIViewController) {
        let tapGesture = UITapGestureRecognizer(target: viewController.view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        viewController.view.addGestureRecognizer(tapGesture)
    }
}
