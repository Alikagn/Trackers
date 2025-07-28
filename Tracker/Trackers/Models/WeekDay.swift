//
//  WeekDay.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 28.06.2025.
//
import Foundation

struct Schedule {
    let day: WeekDay?
    let value: Bool
}

enum WeekDay: Int, CaseIterable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    var day: String {
        switch self {
        case .monday:
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        }
    }
    
    var shortDay: String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
    
    static func calculateScheduleValue(for schedule: [WeekDay]) -> Int16 {
        var scheduleValue: Int16 = 0
        for day in schedule {
            let dayRawValue = Int16(1 << day.rawValue)
            scheduleValue |= dayRawValue
        }
        return scheduleValue
    }
    
    static func calculateScheduleArray(from value: Int16) -> [WeekDay] {
        var schedule: [WeekDay] = []
        for day in WeekDay.allCases {
            if value & (1 << day.rawValue) != 0 {
                schedule.append(day)
            }
        }
        return schedule
    }
}
