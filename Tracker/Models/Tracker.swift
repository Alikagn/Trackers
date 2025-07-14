//
//  Tracker.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 26.06.2025.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: [WeekDay]?
    let isRegular: Bool
    let colorAssetName: String
    let type: TypeTrackers
}

