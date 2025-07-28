//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 28.06.2025.
//

import UIKit

// MARK: - TrackerCollectionViewCellDelegate

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func incompleteTracker(id: UUID, at indexPath: IndexPath)
}

// MARK: - TrackerCollectionViewCell

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: Public Property
    
    static let reuseIdentifier = "TrackerCell"
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    // MARK: Private Property
    
    private(set) var id: UUID?
    private var isCompletedToday: Bool = false
    private var indexPath: IndexPath?
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        id = nil
        isCompletedToday = false
        indexPath = nil
    }
}

// MARK: - Private Methods

extension TrackerCollectionViewCell {
    
    func schedule(
        tracker: Tracker,
        isCompletedToday: Bool,
        completedDays: Int,
        indexPath: IndexPath
    ) {
        self.id = tracker.trackerID
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        ui.nameLabel.text = tracker.name
        ui.mainView.backgroundColor = tracker.color
        ui.emojiLabel.text = tracker.emoji
        ui.completedDaysLabel.text = formatDays(completedDays)
        
        addButton()
    }
    
    func formatDays(_ days: Int) -> String {
        switch days % 100 {
        case 11, 12, 13, 14:
            return "\(days) дней"
        default:
            switch days % 10 {
            case 1:
                return "\(days) день"
            case 2, 3, 4:
                return "\(days) дня"
            default:
                return "\(days) дней"
            }
        }
    }
    
    func addButton() {
        guard let trackerColor = ui.mainView.backgroundColor else { return }
        let image = !isCompletedToday ? UIImage(systemName: "plus") : UIImage(systemName: "checkmark")
        ui.counterButton.setImage(image, for: .normal)
        ui.counterButton.backgroundColor = isCompletedToday ? trackerColor.withAlphaComponent(0.3) : trackerColor
        ui.counterButton.imageView?.contentMode = .center
    }
    
    @objc func completionButtonTapped() {
        guard let id, let indexPath else {
            assertionFailure("no id")
            return
        }
        if !isCompletedToday {
            delegate?.completeTracker(id: id, at: indexPath)
        } else {
            delegate?.incompleteTracker(id: id, at: indexPath)
        }
    }
}
// MARK: - UI Configuring

extension TrackerCollectionViewCell {
    
    // MARK: UI components
    
    struct UI {
        let mainView: UIView
        let emojiLabel: UILabel
        let nameLabel: UILabel
        let completedDaysLabel: UILabel
        let counterButton: UIButton
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.layer.cornerRadius = 16
        mainView.layer.masksToBounds = true
        contentView.addSubview(mainView)
        
        let emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.textAlignment = .center
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        emojiLabel.backgroundColor = .white.withAlphaComponent(0.3)
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.layer.masksToBounds = true
        mainView.addSubview(emojiLabel)
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        mainView.addSubview(nameLabel)
        
        let completedDaysLabel = UILabel()
        completedDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        completedDaysLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        completedDaysLabel.textColor = .black
        contentView.addSubview(completedDaysLabel)
        
        let counterButton = UIButton()
        counterButton.translatesAutoresizingMaskIntoConstraints = false
        counterButton.tintColor = .ypWhite
        counterButton.layer.cornerRadius = 17
        counterButton.layer.masksToBounds = true
        counterButton.contentMode = .center
        counterButton.addTarget(
            self,
            action: #selector(completionButtonTapped),
            for: .touchUpInside
        )
        contentView.addSubview(counterButton)
        
        return .init(
            mainView: mainView,
            emojiLabel: emojiLabel,
            nameLabel: nameLabel,
            completedDaysLabel: completedDaysLabel,
            counterButton: counterButton
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate( [
            
            ui.mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            ui.mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ui.mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ui.mainView.heightAnchor.constraint(equalToConstant: 90),
            
            ui.emojiLabel.topAnchor.constraint(equalTo: ui.mainView.topAnchor, constant: 12),
            ui.emojiLabel.leadingAnchor.constraint(equalTo: ui.mainView.leadingAnchor, constant: 12),
            ui.emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            ui.emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            ui.nameLabel.leadingAnchor.constraint(equalTo: ui.mainView.leadingAnchor, constant: 12),
            ui.nameLabel.trailingAnchor.constraint(equalTo: ui.mainView.trailingAnchor, constant: -12),
            ui.nameLabel.bottomAnchor.constraint(equalTo: ui.mainView.bottomAnchor, constant: -12),
            
            ui.completedDaysLabel.topAnchor.constraint(equalTo: ui.mainView.bottomAnchor, constant: 16),
            ui.completedDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            ui.completedDaysLabel.heightAnchor.constraint(equalToConstant: 18),
            
            ui.counterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            ui.counterButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            ui.counterButton.heightAnchor.constraint(equalToConstant: 34),
            ui.counterButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
}
