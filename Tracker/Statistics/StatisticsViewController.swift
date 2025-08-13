//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 19.06.2025.
//

import UIKit

// MARK: - StatisticsViewController

final class StatisticsViewController: UIViewController {
    
    // MARK: Private Property
    
    let trackerRecordStore: TrackerRecordStore = TrackerRecordStore()
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchStats()
    }
    
}

// MARK: - Private Methods

private extension StatisticsViewController {
    
    func showStatistics() {
        ui.lackOfStatisticsImageView.isHidden = false
        ui.lackOfStatisticsLabel.isHidden = false
        ui.bestPeriodLabel.isHidden = true
        ui.perfectDaysLabel.isHidden = true
        ui.completedTrackersLabel.isHidden = true
        ui.averageLabel.isHidden = true
    }
    
    func hideStatistics() {
        ui.lackOfStatisticsImageView.isHidden = true
        ui.lackOfStatisticsLabel.isHidden = true
        ui.bestPeriodLabel.isHidden = false
        ui.perfectDaysLabel.isHidden = false
        ui.completedTrackersLabel.isHidden = false
        ui.averageLabel.isHidden = false
    }
    
    private func fetchStats() {
        let trackersCompleted = trackerRecordStore.getNumberOfCompletedTrackers()
        if trackersCompleted == 0 {
            showStatistics()
            return
        } else {
            if let stats = trackerRecordStore.getStats() {
                hideStatistics()
                let perfectDays = stats[0]
                ui.perfectDaysLabel.updateView(
                    number: "\(perfectDays)",
                    name: NSLocalizedString("Perfect days", comment: "")
                )
                
                ui.completedTrackersLabel.updateView(
                    number: "\(trackersCompleted)",
                    name: NSLocalizedString("Trackers completed", comment: "")
                )
                
                let average = stats[1]
                ui.averageLabel.updateView(
                    number: "\(average)",
                    name: NSLocalizedString("Average value", comment: "")
                )
                
                let bestPeriod = stats[2]
                ui.bestPeriodLabel.updateView(
                    number: "\(bestPeriod)",
                    name: NSLocalizedString("Best period", comment: "")
                )
            }
        }
    }
}

// MARK: - UI Configuring

private extension StatisticsViewController {
    
    // MARK: UI components
    
    struct UI {
        
        let largeTitleLabel: UILabel
        let lackOfStatisticsImageView: UIImageView
        let lackOfStatisticsLabel: UILabel
        let bestPeriodLabel: CardStats
        let perfectDaysLabel: CardStats
        let completedTrackersLabel: CardStats
        let averageLabel: CardStats
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        let largeTitleLabel = UILabel()
        largeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        largeTitleLabel.text = NSLocalizedString("largeTitleLabel.text", comment: "")
        largeTitleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        largeTitleLabel.textColor = .ypBlack
        view.addSubview(largeTitleLabel)
        
        let lackOfStatisticsImageView = UIImageView()
        lackOfStatisticsImageView.translatesAutoresizingMaskIntoConstraints = false
        lackOfStatisticsImageView.image = UIImage(named: "LackOfStatistics")
        view.addSubview(lackOfStatisticsImageView)
        
        let lackOfStatisticsLabel = UILabel()
        lackOfStatisticsLabel.translatesAutoresizingMaskIntoConstraints = false
        lackOfStatisticsLabel.text = NSLocalizedString("lackOfStatisticsLabel.text", comment: "")
        lackOfStatisticsLabel.font = .systemFont(ofSize: 12, weight: .medium)
        lackOfStatisticsLabel.textColor = .ypBlack
        view.addSubview(lackOfStatisticsLabel)
        
        var bestPeriodLabel = CardStats()
        bestPeriodLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bestPeriodLabel)
        
        var perfectDaysLabel = CardStats()
        perfectDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(perfectDaysLabel)
        
        var completedTrackersLabel = CardStats()
        completedTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(completedTrackersLabel)
        
        var averageLabel = CardStats()
        averageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(averageLabel)
        
        return .init(
            largeTitleLabel: largeTitleLabel,
            lackOfStatisticsImageView: lackOfStatisticsImageView,
            lackOfStatisticsLabel: lackOfStatisticsLabel,
            bestPeriodLabel: bestPeriodLabel,
            perfectDaysLabel: perfectDaysLabel,
            completedTrackersLabel: completedTrackersLabel,
            averageLabel: averageLabel
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate( [
            ui.largeTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            ui.largeTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            ui.lackOfStatisticsImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            ui.lackOfStatisticsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ui.lackOfStatisticsImageView.widthAnchor.constraint(equalToConstant: 80),
            ui.lackOfStatisticsImageView.heightAnchor.constraint(equalToConstant: 80),
            
            ui.lackOfStatisticsLabel.topAnchor.constraint(equalTo: ui.lackOfStatisticsImageView.bottomAnchor, constant: 8),
            ui.lackOfStatisticsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ui.bestPeriodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ui.bestPeriodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ui.bestPeriodLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -198),
            ui.bestPeriodLabel.heightAnchor.constraint(equalToConstant: 90),
            
            ui.perfectDaysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ui.perfectDaysLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ui.perfectDaysLabel.topAnchor.constraint(equalTo: ui.bestPeriodLabel.bottomAnchor, constant: 12),
            ui.perfectDaysLabel.heightAnchor.constraint(equalToConstant: 90),
            
            ui.completedTrackersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ui.completedTrackersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ui.completedTrackersLabel.topAnchor.constraint(equalTo: ui.perfectDaysLabel.bottomAnchor, constant: 12),
            ui.completedTrackersLabel.heightAnchor.constraint(equalToConstant: 90),
            
            ui.averageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ui.averageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ui.averageLabel.topAnchor.constraint(equalTo: ui.completedTrackersLabel.bottomAnchor, constant: 12),
            ui.averageLabel.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func setupUI() {
        ui.largeTitleLabel.textColor = ui.largeTitleLabel.textColor
    }
}
