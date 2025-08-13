//
//  TrackerStore.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 23.07.2025.
//

import CoreData
import UIKit

// MARK: - TrackerStoreError

enum TrackerStoreError: Error {
    case decodingErrorInvalidID
    case trackerNotFound
    case contextSaveError
}

// MARK: - TrackerStoreUpdate

struct TrackerStoreUpdate {
    let insertedSections: IndexSet
    let insertedIndexPaths: [IndexPath]
}

// MARK: - Protocols

protocol TrackerStoreDelegate: AnyObject {
    func trackerStore(_ store: TrackerStoreUpdate)
}

protocol TrackerStoreProtocol {
    func setDelegate(_ delegate: TrackerStoreDelegate)
    func fetchTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker
    func addTracker(_ tracker: Tracker, toCategory category: TrackerCategory) throws
    func pinTracker(id: UUID, at indexPath: IndexPath) throws
    func deleteTracker(id: UUID, at indexPath: IndexPath) throws
    func fetchTrackerByID(id: UUID, at indexPath: IndexPath) throws -> Tracker
}

// MARK: - TrackerStore

final class TrackerStore: NSObject {
    
    // MARK: Public Property
    
    weak var delegate: TrackerStoreDelegate?
    
    // MARK: Private Property
    
    private let uiColorMarshalling = UIColorMarshalling()
    private let context: NSManagedObjectContext
    private var insertedSections: IndexSet = []
    private var insertedIndexPaths: [IndexPath] = []
    
    private var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.modelEntitiesTracker(trackerCoreData: $0) })
        else { return [] }
        return trackers
    }
    private lazy var trackerCategoryStore: TrackerCategoryStoreProtocol = {
        TrackerCategoryStore(context: context)
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true),
            NSSortDescriptor(keyPath: \TrackerCoreData.category?.headingCategory, ascending: false)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            assertionFailure("Failed to fetch trackers: \(error)")
        }
        return controller
    }()
    
    // MARK: Lifecycle
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

// MARK: - Private Methods

extension TrackerStore {
    
    func modelEntitiesTracker(trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let idTracker = trackerCoreData.trackerID,
              let name = trackerCoreData.name,
              let colorString = trackerCoreData.color,
              let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidID
        }
        
        let color = uiColorMarshalling.color(from: colorString)
        let schedule = WeekDay.calculateScheduleArray(from: trackerCoreData.schedule)
        let isPinned = trackerCoreData.isPinned
        
        return Tracker(
            trackerID: idTracker,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule,
            type: .habit,
            isPinned: isPinned
        )
    }
    
    func addTracker(tracker: Tracker, category: TrackerCategory) throws {
        let trackerCategoryCoreData = try trackerCategoryStore.fetchCategoryCoreData(for: category)
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.trackerID = tracker.trackerID
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = WeekDay.calculateScheduleValue(for: tracker.schedule)
        trackerCoreData.category = trackerCategoryCoreData
        trackerCoreData.isPinned = tracker.isPinned
        
        try saveContext()
    }
    
    func saveContext() throws {
        guard context.hasChanges else {
            print("Нет изменений для сохранения")
            return }
        do {
            try context.save()
            print("Контекст сохранился")
        } catch {
            print("Контекст не сохранился")
            context.rollback()
            throw TrackerStoreError.contextSaveError
        }
    }
    
    internal func deleteTracker(id: UUID, at indexPath: IndexPath) throws {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerID == %@", id as CVarArg)
        if let result = try context.fetch(fetchRequest).first {
            context.delete(result)
            try saveContext()
        } else {
            throw TrackerStoreError.trackerNotFound
        }
    }
     
    
    internal func pinTracker(id: UUID, at indexPath: IndexPath) throws {
            let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "trackerID == %@", id as CVarArg)
            if let result = try context.fetch(fetchRequest).first {
                result.isPinned = !result.isPinned
                try saveContext()
            } else {
                throw TrackerStoreError.trackerNotFound
            }
        }

        internal func fetchTrackerByID(id: UUID, at indexPath: IndexPath) throws -> Tracker {
            let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "trackerID == %@", id as CVarArg)
            if let result = try context.fetch(fetchRequest).first {
                return try modelEntitiesTracker(trackerCoreData: result)
            } else {
                throw TrackerStoreError.trackerNotFound
            }
        }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedSections.removeAll()
        insertedIndexPaths.removeAll()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.trackerStore(
            TrackerStoreUpdate(
                insertedSections: insertedSections,
                insertedIndexPaths: insertedIndexPaths
            )
        )
        insertedSections.removeAll()
        insertedIndexPaths.removeAll()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            insertedSections.insert(sectionIndex)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexPaths.append(indexPath)
            }
        default:
            break
        }
    }
}

// MARK: - TrackerStoreProtocol

extension TrackerStore: TrackerStoreProtocol {
    
    func setDelegate(_ delegate: TrackerStoreDelegate) {
        self.delegate = delegate
    }
    
    func fetchTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker {
        try modelEntitiesTracker(trackerCoreData: trackerCoreData)
    }
    
    func addTracker(_ tracker: Tracker, toCategory category: TrackerCategory) throws {
        try addTracker(tracker: tracker, category: category)
    }
}
