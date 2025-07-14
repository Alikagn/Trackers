//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 28.06.2025.
//

import Foundation

struct TrackerCategory {
    let id: UUID
    let title: String
    let trackers: [Tracker]
}
