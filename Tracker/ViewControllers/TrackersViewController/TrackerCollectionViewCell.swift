//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 28.06.2025.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    
    static let identifier = "TrackerCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let emojiBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = Colors.white?.withAlphaComponent(0.3)
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = Colors.white
        label.numberOfLines = 2
        return label
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = Colors.black
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var trackerId: UUID?
    private var completedDays = 0
    private var currentDate = Date()
    private var isCompletedToday = false
    
    var onPlusButtonTapped: ((UUID, Date, Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tracker: Tracker, completedDays: Int, isCompletedToday: Bool, currentDate: Date) {
        trackerId = tracker.id
        self.completedDays = completedDays
        self.isCompletedToday = isCompletedToday
        self.currentDate = currentDate
        
        containerView.backgroundColor = tracker.color //UIColor(named: tracker.color)
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        daysLabel.text = formattedDaysCount(completedDays)
        
        updatePlusButton()
    }
    
    private func setupViews() {
        [containerView, emojiBackground, emojiLabel, titleLabel, daysLabel, plusButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = true
        }
        
        contentView.addSubview(containerView)
        containerView.addSubview(emojiBackground)
        emojiBackground.addSubview(emojiLabel)
        containerView.addSubview(titleLabel)
        contentView.addSubview(daysLabel)
        contentView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiBackground.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            emojiBackground.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            emojiBackground.widthAnchor.constraint(equalToConstant: 24),
            emojiBackground.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackground.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackground.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            daysLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func updatePlusButton() {
        let imageName = isCompletedToday ? "checkmark" : "plus"
        plusButton.setImage(UIImage(systemName: imageName), for: .normal)
        plusButton.backgroundColor = containerView.backgroundColor?.withAlphaComponent(isCompletedToday ? 0.3 : 1.0)
        plusButton.tintColor = Colors.white
        
        let isFutureDate = currentDate > Date()
        plusButton.isEnabled = !isFutureDate
        plusButton.alpha = isFutureDate ? 0.3 : 1.0
    }
    
    private func formattedDaysCount(_ count: Int) -> String {
        let remainder = count % 10
        let remainder100 = count % 100
        
        if remainder100 >= 11 && remainder100 <= 19 {
            return "\(count) дней"
        } else if remainder == 1 {
            return "\(count) день"
        } else if remainder >= 2 && remainder <= 4 {
            return "\(count) дня"
        } else {
            return "\(count) дней"
        }
    }
    
    @objc private func plusButtonTapped() {
        guard let trackerId = trackerId else { return }
        
        isCompletedToday.toggle()
        completedDays += isCompletedToday ? 1 : -1
        daysLabel.text = formattedDaysCount(completedDays)
        
        updatePlusButton()
        onPlusButtonTapped?(trackerId, currentDate, isCompletedToday)
    }
}
