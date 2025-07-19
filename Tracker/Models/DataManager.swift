//
//  DataManager.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 28.06.2025.
//

import Foundation

final class DataManager {
    
    static let shared = DataManager()
    private init() {}
    
    var categories: [TrackerCategory] = [
        TrackerCategory(
            id: UUID(),
            title: "Домашний уют",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Кормить кошек",
                    color: .colorSelection2,
                    emoji: "❤️",
                    schedule: [WeekDay.monday, WeekDay.saturday],
                    colorAssetName: "ColorSelection2",
                    type: .habit
                ),
            ]
        ),
        TrackerCategory(
            id: UUID(),
            title: "Радостные мелочи",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Пришла посылка",
                    color: .colorSelection3,
                    emoji: "😻",
                    schedule: [WeekDay.friday, WeekDay.tuesday],
                    colorAssetName: "ColorSelection3",
                    type: .habit
                ),
                Tracker(
                    id: UUID(),
                    name: "Спортивные соревнования",
                    color: .colorSelection4,
                    emoji: "🌺",
                    schedule: [WeekDay.wednesday, WeekDay.monday, WeekDay.thursday],
                    colorAssetName: "ColorSelection4",
                    type: .habit
                ),
                Tracker(
                    id: UUID(),
                    name: "Встреча с друзьями",
                    color: .colorSelection5,
                    emoji: "❤️",
                    schedule: [WeekDay.thursday],
                    colorAssetName: "ColorSelection5",
                    type: .habit
                )
            ]
        ),
        TrackerCategory(
            id: UUID(),
            title: "Самочувствие",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Рабочее настроение",
                    color: .colorSelection8,
                    emoji: "🙂",
                    schedule: [WeekDay.sunday, WeekDay.tuesday],
                    colorAssetName: "ColorSelection8",
                    type: .habit
                ),
                Tracker(
                    id: UUID(),
                    name: "Высокая активность",
                    color:.colorSelection9,
                    emoji: "😪",
                    schedule: [WeekDay.saturday],
                    colorAssetName: "ColorSelection9",
                    type: .habit
                )
            ]
        )
    ]
}

