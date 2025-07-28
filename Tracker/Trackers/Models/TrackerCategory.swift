//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 28.06.2025.
//

import Foundation

struct TrackerCategory {
    let headingCategory: String
    let trackers: [Tracker]
}

// MARK: - Equatable

extension TrackerCategory: Equatable {
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.headingCategory == rhs.headingCategory
    }
}
