//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 19.06.2025.
//

import UIKit

protocol TrackersViewControllerDelegate: AnyObject {
    func tracker(tracker: Tracker, for category: String)
}

// MARK: - TrackersViewController
class TrackersViewController: UIViewController, UICollectionViewDelegate {
    
    private let keyboardHandler = KeyboardHandler()
    private var isEmptyState = false {
        didSet {
            cometImageView.isHidden = !isEmptyState
            questionLabel.isHidden = !isEmptyState
            collectionView.isHidden = isEmptyState
        }
    }
    
    private var currentDate = Date() {
        didSet {
            collectionView.reloadData()
            isEmptyState = categories.isEmpty
        }
    }
    private let dataManager = DataManager.shared
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    
    
    func reloadData() {
        categories = dataManager.categories
        print(("categories: \(categories.count)"))
    }
    
    func isCurrentDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
    
    func reloadVisibleCategories() {
         let calendar = Calendar.current
         let filterText = (searchTextField.text ?? String()).lowercased()
         let today = calendar.component(.weekday, from: datePicker.date)
         
        visibleCategories = categories.compactMap { category in
             let trackers = category.trackers.filter { tracker in
                 let textCondition = filterText.isEmpty ||
                 tracker.name.lowercased().contains(filterText)
                 var dateCondition = false
                 switch tracker.type {
                 case .habit:
                     dateCondition = ((tracker.schedule?.contains { weekDay in
                         return today == weekDay.calendarIndex
                     }) != nil)
                 case .irregularEvent:
                     if isCurrentDate(datePicker.date) {
                         let creationDate = Date()
                         dateCondition = calendar.isDate(
                             creationDate,
                             inSameDayAs: datePicker.date
                         )
                     }
                 }
                 
                 return textCondition && dateCondition
             }
             return trackers.isEmpty ? nil : TrackerCategory(id: category.id, title: category.title, trackers: trackers)
         }
        collectionView.reloadData()
     }
     
    private var filteredCategories: [TrackerCategory] {
        categories.map { category in
            let filteredTrackers = category.trackers.filter { isTrackerVisible($0, for: currentDate) }
            return TrackerCategory(id: category.id, title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
    }
        
    private let cellIdentifier = "cell"
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "Add tracker") ?? UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
        button.tintColor = Colors.black
        button.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        picker.tintColor = Colors.blue
        return picker
    }()
    
    private lazy var datePickerBarButton: UIBarButtonItem = {
        return UIBarButtonItem(customView: datePicker)
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YY"
        return formatter
    }()
    
    private lazy var cometImageView: UIImageView = {
        let profileImage = UIImage(named: "Comet")
        let imageView = UIImageView(image: profileImage)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var largeTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = .ypBlack
        label.font = FontsConstants.label
        return label
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = " Поиск"
        searchTextField.layer.cornerRadius = 10
        searchTextField.font = FontsConstants.searchTextField
        searchTextField.delegate = self
        searchTextField.textColor = Colors.searchTextColor
        return searchTextField
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.black
        label.text = "Что будем отслеживать?"
        label.font = FontsConstants.cometTextLabel
        label.isHidden = true
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collection.register(
            TrackerSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerSectionHeader.reuseIdentifier
        )
        collection.backgroundColor = Colors.white
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    // MARK: - Private methods
    private func setupView() {
        
        [cometImageView, largeTextLabel, questionLabel, searchTextField, collectionView].forEach
        {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        setConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        self.title = "Трекеры"
        setupView()
        setupNavigationBar()
        setupKeyboardHandler()
        reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isEmptyState = self.filteredCategories.isEmpty
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = datePickerBarButton
    }
    
    private func setupKeyboardHandler() {
        keyboardHandler.setup(for: self)
        searchTextField.delegate = keyboardHandler
    }
    
    private func isTrackerVisible(_ tracker: Tracker, for date: Date) -> Bool {
        guard tracker.isRegular else { return true }
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        return tracker.schedule?.contains { $0.calendarIndex == weekday } ?? false
    }
    
    private func isSearchTrackers(_ tracker: Tracker, for searchText: String) -> Bool {
        return true
    }
    
    private func isTrackerCompletedToday(_ trackerId: UUID) -> Bool {
        completedTrackers.contains { record in
         record.trackerId == trackerId && Calendar.current.isDate(record.date, inSameDayAs: currentDate)
        }
    }

    @objc private func addButtonTapped() {
        let creatingVC = CreatingTrackerViewController() //HabitCreationViewController()
        creatingVC.modalPresentationStyle = .formSheet
        
        creatingVC.onTrackerCreated = { [weak self] newTracker in
            guard let self = self else { return }
           
            if let firstCategoryIndex = self.categories.firstIndex(where: { $0.title == "Радостные мелочи" }) {
                let oldCategory = self.categories[firstCategoryIndex]
                let newCategory = TrackerCategory(
                    id: oldCategory.id,
                    title: oldCategory.title,
                    trackers: oldCategory.trackers + [newTracker]
                )
                self.categories = self.categories.enumerated().map { index, category in
                    index == firstCategoryIndex ? newCategory : category
                }
            } else {
                let newCategory = TrackerCategory(
                    id: UUID(),
                    title: "Радостные мелочи",
                    trackers: [newTracker]
                )
                self.categories.append(newCategory)
            }
            self.collectionView.reloadData()
            self.isEmptyState = self.filteredCategories.isEmpty
         
        }
        
        present(UINavigationController(rootViewController: creatingVC), animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        print("Выбранная дата: \(currentDate)")
        reloadVisibleCategories()
    }
}

extension TrackersViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            cometImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            cometImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            cometImageView.widthAnchor.constraint(equalToConstant: 80),
            cometImageView.heightAnchor.constraint(equalToConstant: 80),
            
            largeTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            largeTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            largeTextLabel.heightAnchor.constraint(equalToConstant: 34),
            
            searchTextField.topAnchor.constraint(equalTo: largeTextLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            
            questionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            questionLabel.topAnchor.constraint(equalTo: cometImageView.bottomAnchor, constant: 8),
            
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    
         ])
    }
}

// MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadVisibleCategories()
        return true
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(("filteredCategories: \(filteredCategories.count)"))
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(("categoriesTrackers: \(filteredCategories[section].trackers.count)"))
        return filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TrackerCell",
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        
        cell.configure(
            with: tracker,
            completedDays: completedTrackers.filter { $0.trackerId == tracker.id }.count,
            isCompletedToday: isTrackerCompletedToday(tracker.id),
            currentDate: currentDate
        )
        
        cell.onPlusButtonTapped = { [weak self] trackerId, date, isCompleted in
            guard let self = self else { return }
            
            if isCompleted {
                self.completedTrackers.append(TrackerRecord(trackerId: trackerId, date: date))
            } else {
                self.completedTrackers.removeAll { $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: date) }
            }
            collectionView.reloadData()
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 41) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: section == 0 ? 12 : 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerSectionHeader.reuseIdentifier,
                for: indexPath
              ) as? TrackerSectionHeader else {
            return UICollectionReusableView()
        }
        
        let category = categories[indexPath.section]
        header.configure(with: category.title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 32)
    }
}

