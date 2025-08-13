//
//  Tracker.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 26.06.2025.
//

import UIKit

struct Tracker {
    let trackerID: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
    let type: TypeTrackers
    let isPinned: Bool
}
