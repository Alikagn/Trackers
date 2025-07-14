//
//  Colors.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 05.07.2025.
//


import UIKit

// MARK: - Colors
enum Colors {
    static let background = UIColor(named: "YP Background")
    static let black = UIColor(named: "YP Black")
    static let blue = UIColor(named: "YP Blue")
    static let gray = UIColor(named: "YP Gray")
    static let lightGray = UIColor(named: "YP Light Gray")
    static let red = UIColor(named: "YP Red")
    static let white = UIColor(named: "YP White")
    
    static let searchFieldBackground = UIColor(named: "SearchFieldBackground")
    static let searchTextColor = UIColor(named: "SearchTextColor")
    static let datePickerBackground = UIColor(named: "DatePickerBackground")
    
    static let trackerColors: [UIColor] = {
        return (1...18).compactMap { UIColor(named: "Color selection \($0)") }
    }()
}