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
                    color: "ColorSelection2",
                    emoji: "❤️",
                    schedule: [WeekDay.monday, WeekDay.saturday],
                    isRegular: true,
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
                    color: "ColorSelection3",
                    emoji: "😻",
                    schedule: [WeekDay.friday, WeekDay.tuesday],
                    isRegular: true,
                    colorAssetName: "ColorSelection3",
                    type: .habit
                ),
                Tracker(
                    id: UUID(),
                    name: "Спортивные соревнования",
                    color: "ColorSelection4",
                    emoji: "🌺",
                    schedule: [WeekDay.wednesday, WeekDay.monday, WeekDay.thursday],
                    isRegular: true,
                    colorAssetName: "ColorSelection4",
                    type: .habit
                ),
                Tracker(
                    id: UUID(),
                    name: "Встреча с друзьями",
                    color: "ColorSelection5",
                    emoji: "❤️",
                    schedule: [WeekDay.thursday],
                    isRegular: true,
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
                    color: "ColorSelection8",
                    emoji: "🙂",
                    schedule: [WeekDay.sunday, WeekDay.tuesday],
                    isRegular: true,
                    colorAssetName: "ColorSelection8",
                    type: .habit
                ),
                Tracker(
                    id: UUID(),
                    name: "Высокая активность",
                    color:"ColorSelection9",
                    emoji: "😪",
                    schedule: [WeekDay.saturday],
                    isRegular: true,
                    colorAssetName: "ColorSelection9",
                    type: .habit
                )
            ]
        )
    ]
}

