//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 09.08.2025.
//

import AppMetricaCore
final class AnalyticsService {

    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "1b34c72f-62c0-40fd-b9f0-9d522ef67a3a") else { return }

        AppMetrica.activate(with: configuration)
    }

    func reportEvent(event: String, parameters: [String: String]) {
        AppMetrica.reportEvent(name: event, parameters: parameters, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
