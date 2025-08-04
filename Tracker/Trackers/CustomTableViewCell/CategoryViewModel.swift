//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 01.08.2025.
//

import Foundation

// MARK: - CategoryViewModel

final class CategoryViewModel {
    typealias Binding<T> = (T) -> Void
    
    // MARK: Public Property
    
    var updateHandler: (() -> Void)?
    
    // MARK: Private Property
    
    private let categoryStore: TrackerCategoryStoreProtocol
    private var categories: [TrackerCategory] = []
    
    // MARK: Constructor

    init(categoryStore: TrackerCategoryStoreProtocol) {
        self.categoryStore = categoryStore
    }
}

// MARK: - Public Methods

extension CategoryViewModel {
    
    func fetchCategories() {
        categoryStore.getCategories { [weak self] categories in
            guard let self else { return }
            self.categories = categories
            self.updateHandler?()
        }
    }
    
    func numberOfCategories() -> Int {
        return categories.count
    }
    
    func category(at index: Int) -> TrackerCategory {
        return categories[index]
    }
    
    func categoryNames() -> [String] {
        return categories.map { $0.headingCategory }
    }
    
    func didSelectCategory(at index: Int) {
        updateHandler?()
    }
    
    func addCategory(_ category: TrackerCategory) {
        categoryStore.addCategory(category) { [weak self] error in
            guard let self else { return }
            if let error = error {
                print("Failed to add category with error: \(error)")
                return
            }
            self.fetchCategories()
        }
    }
}

