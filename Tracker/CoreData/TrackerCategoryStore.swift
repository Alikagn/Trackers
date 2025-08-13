//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 23.07.2025.
//

import CoreData
import UIKit

// MARK: - TrackerCategoryStoreError

private enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidTrackers
    case failedToInitializeTracker
    case failedToFetchCategory
}

// MARK: - TrackerCategoryStoreUpdate

struct TrackerCategoryStoreUpdate {
    let insertedIndexPaths: [IndexPath]
    let deletedIndexPaths: [IndexPath]
}

// MARK: - Protocols

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdate(_ update: TrackerCategoryStoreUpdate)
}

protocol TrackerCategoryStoreProtocol {
    func setDelegate(_ delegate: TrackerCategoryStoreDelegate)
    func getCategories(completion: @escaping ([TrackerCategory]) -> Void)
    func fetchCategoryCoreData(for category: TrackerCategory) throws -> TrackerCategoryCoreData
    func addCategory(_ category: TrackerCategory, completion: @escaping (Error?) -> Void)
}

// MARK: - TrackerCategoryStore

final class TrackerCategoryStore: NSObject {
    
    // MARK: Public Property
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    // MARK: Private Property
    
    private var insertedIndexPaths: [IndexPath] = []
    private var deletedIndexPaths: [IndexPath] = []
    
    private let context: NSManagedObjectContext
    
    private lazy var trackerStore: TrackerStore = {
        TrackerStore(context: context)
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchedRequest = TrackerCategoryCoreData.fetchRequest()
        fetchedRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.headingCategory, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchedRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        
        try? controller.performFetch()
        return controller
    }()
    
    // MARK: Lifecycle
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
}

// MARK: - Private Methods

private extension TrackerCategoryStore {
    
    func convertToTrackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.headingCategory else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        guard let trackersSet = trackerCategoryCoreData.trackers as? Set<TrackerCoreData> else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackers
        }
        let trackerList = try trackersSet.compactMap { trackerCoreData in
            guard let tracker = try? trackerStore.fetchTracker(trackerCoreData) else {
                throw TrackerCategoryStoreError.failedToInitializeTracker
            }
            return tracker
        }
        return TrackerCategory(headingCategory: title, trackers: trackerList)
    }
    
    func fetchCategories() throws -> [TrackerCategory] {
        guard let objects = fetchedResultsController.fetchedObjects else {
            throw TrackerCategoryStoreError.failedToFetchCategory
        }
        let categories = try objects.map { try convertToTrackerCategory(from: $0) }
        return categories
    }
    
    func fetchTrackerCategoryCoreData(for category: TrackerCategory) throws -> TrackerCategoryCoreData {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(TrackerCategoryCoreData.headingCategory), category.headingCategory
        )
        guard let categoryCoreData = try context.fetch(request).first else {
            throw TrackerCategoryStoreError.failedToFetchCategory
        }
        return categoryCoreData
    }
    
    func ensureUniqueCategoryTitle(with title: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(TrackerCategoryCoreData.headingCategory), title
        )
        let count = try context.count(for: request)
        guard count == 0 else {
            return
        }
    }
    
    func addNewCategory(_ category: TrackerCategory) throws {
        try ensureUniqueCategoryTitle(with: category.headingCategory)
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.headingCategory = category.headingCategory
        categoryCoreData.trackers = NSSet()
        try saveContext()
    }
    
    func saveContext() throws {
        guard context.hasChanges else {
            return }
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths.removeAll()
        deletedIndexPaths.removeAll()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            TrackerCategoryStoreUpdate(
                insertedIndexPaths: insertedIndexPaths,
                deletedIndexPaths: deletedIndexPaths
            )
        )
        insertedIndexPaths.removeAll()
        deletedIndexPaths.removeAll()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexPaths.append(indexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                deletedIndexPaths.append(indexPath)
            }
        default:
            break
        }
    }
}

// MARK: - TrackerCategoryStoreProtocol

extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    
    func setDelegate(_ delegate: TrackerCategoryStoreDelegate) {
        self.delegate = delegate
    }
    
    func getCategories(completion: @escaping ([TrackerCategory]) -> Void) {
        do {
            let categories = try fetchCategories()
            completion(categories)
        } catch {
            print("Failed to fetch categories with error: \(error)")
            completion([])
        }
    }

    func fetchCategoryCoreData(for category: TrackerCategory) throws -> TrackerCategoryCoreData {
        do {
            let categoryCoreData = try fetchTrackerCategoryCoreData(for: category)
            return categoryCoreData
        } catch {
            throw error
        }
    }

    func addCategory(_ category: TrackerCategory, completion: @escaping (Error?) -> Void) {
        do {
            try addNewCategory(category)
            completion(nil)
        } catch {
            print("Failed to add category with error: \(error)")
            completion(error)
        }
    }
}
