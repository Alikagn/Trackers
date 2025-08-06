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

/*
// MARK: - Public Methods

 func addTracker(_ tracker: Tracker, to category: TrackerCategory) throws {
    guard !tracker.name.isEmpty else {
        throw NSError(domain: "Validation", code: 400, userInfo: [NSLocalizedDescriptionKey: "Название трекера не может быть пустым"])
    }
    
    guard !trackerExists(name: tracker.name, in: category) else {
        throw NSError(domain: "Validation", code: 409, userInfo: [NSLocalizedDescriptionKey: "Трекер с таким названием уже существует в этой категории"])
    }
    
    let trackerEntity = TrackerCoreData(context: context)
    trackerEntity.id = tracker.id
    trackerEntity.name = tracker.name
    trackerEntity.emoji = tracker.emoji
    trackerEntity.color = UIColor(named: tracker.color)
    trackerEntity.colorAssetName = tracker.color
    trackerEntity.schedule = tracker.schedule as NSObject
    
    let categoryRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
    categoryRequest.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)
    
    if let categoryEntity = try? context.fetch(categoryRequest).first {
        trackerEntity.category = categoryEntity
    }
    
    saveContext()
}
 
 func fetchTrackers() -> [Tracker] {
     guard let trackerObjects = fetchedResultsController?.fetchedObjects else { return [] }
     return trackerObjects.compactMap { createTracker(from: $0) }
 }
 
 func deleteTracker(_ tracker: Tracker) throws {
     let request = TrackerCoreData.fetchRequest()
     request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
     
     guard let trackerToDelete = try? context.fetch(request).first else {
         throw NSError(domain: "Tracker", code: 404, userInfo: [NSLocalizedDescriptionKey: "Трекер не найден"])
     }
     
     context.delete(trackerToDelete)
     saveContext()
 }
*/
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
        
        return Tracker(
            trackerID: idTracker,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule,
            type: .habit
        )
    }
    
    func addTracker(tracker: Tracker, category: TrackerCategory) throws {
        guard !tracker.name.isEmpty else {
            throw NSError(domain: "Validation", code: 400, userInfo: [NSLocalizedDescriptionKey: "Название трекера не может быть пустым"])
        }
        
        guard !trackerExists(name: tracker.name, in: category) else {
            throw NSError(domain: "Validation", code: 409, userInfo: [NSLocalizedDescriptionKey: "Трекер с таким названием уже существует в этой категории"])
        }
        
        let trackerCategoryCoreData = try trackerCategoryStore.fetchCategoryCoreData(for: category)
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.trackerID = tracker.trackerID
        trackerEntity.name = tracker.name
        trackerEntity.emoji = tracker.emoji
        trackerEntity.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerEntity.schedule = WeekDay.calculateScheduleValue(for: tracker.schedule)
        
        let categoryRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        categoryRequest.predicate = NSPredicate(format: "headingCategory == %@", category.headingCategory as CVarArg)
        
        if let categoryEntity = try? context.fetch(categoryRequest).first {
            trackerEntity.category = categoryEntity
        }
        
        try saveContext()
    }
    
    private func trackerExists(name: String, in category: TrackerCategory) -> Bool {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "name == %@ AND category.headingCategory == %@",
            name,
            category.headingCategory as CVarArg
        )
        return (try? context.count(for: request)) ?? 0 > 0
    }
    
    /*
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) throws {
       guard !tracker.name.isEmpty else {
           throw NSError(domain: "Validation", code: 400, userInfo: [NSLocalizedDescriptionKey: "Название трекера не может быть пустым"])
       }
       
       guard !trackerExists(name: tracker.name, in: category) else {
           throw NSError(domain: "Validation", code: 409, userInfo: [NSLocalizedDescriptionKey: "Трекер с таким названием уже существует в этой категории"])
       }
       
       let trackerEntity = TrackerCoreData(context: context)
       trackerEntity.id = tracker.id
       trackerEntity.name = tracker.name
       trackerEntity.emoji = tracker.emoji
       trackerEntity.color = UIColor(named: tracker.color)
       trackerEntity.colorAssetName = tracker.color
       trackerEntity.schedule = tracker.schedule as NSObject
       
       let categoryRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
       categoryRequest.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)
       
       if let categoryEntity = try? context.fetch(categoryRequest).first {
           trackerEntity.category = categoryEntity
       }
       
       saveContext()
   }
   */
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
            throw error
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
