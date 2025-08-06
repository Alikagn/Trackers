//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 23.07.2025.
//

import CoreData
import UIKit

// MARK: - TrackerRecordStoreError

private enum TrackerRecordStoreError: Error {
    case failedToFetchTracker
    case failedToFetchRecord
}

// MARK: - TrackerRecordStoreProtocol

protocol TrackerRecordStoreProtocol {
    func recordsFetch(for tracker: Tracker) throws -> [TrackerRecord]
    func addRecord(with id: UUID, by date: Date) throws
    func deleteRecord(with id: UUID, by date: Date) throws
}

// MARK: - TrackerRecordStore

final class TrackerRecordStore: NSObject {
    
    // MARK: Private Property
    
    private let context: NSManagedObjectContext
    
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

private extension TrackerRecordStore {
    
    func fetchRecords(_ tracker: Tracker) throws -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(TrackerRecordCoreData.trackerRecordID), tracker.trackerID as CVarArg
        )
        let objects = try context.fetch(request)
        let records = objects.compactMap { object -> TrackerRecord? in
            guard let date = object.date, let id = object.trackerRecordID else { return nil }
            return TrackerRecord(trackerRecordID: id, date: date)
        }
        return records
    }
    
    func fetchTrackerCoreData(for trackerID: UUID) throws -> TrackerCoreData? {
        let request = TrackerCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(TrackerCoreData.trackerID), trackerID as CVarArg
        )
        return try context.fetch(request).first
    }
    
    func fetchTrackerRecordCoreData(for trackerID: UUID, and date: Date) throws -> TrackerRecordCoreData? {
        let request = TrackerRecordCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K = %@ AND %K = %@",
            #keyPath(TrackerRecordCoreData.trackers.trackerID), trackerID as CVarArg,
            #keyPath(TrackerRecordCoreData.date), date as CVarArg
        )
        return try context.fetch(request).first
    }
    
    func saveContext() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
    
    func createNewRecord(id: UUID, date: Date) throws {
        guard let trackerCoreData = try fetchTrackerCoreData(for: id) else {
            throw TrackerRecordStoreError.failedToFetchTracker
        }
        
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.trackerRecordID = id
        trackerRecordCoreData.date = date
        trackerRecordCoreData.trackers = trackerCoreData
        
        try saveContext()
    }
    
    func removeRecord(idTracker: UUID, date: Date) throws {
        guard let trackerRecordCoreData = try fetchTrackerRecordCoreData(for: idTracker, and: date) else {
            throw TrackerRecordStoreError.failedToFetchRecord
        }
        context.delete(trackerRecordCoreData)
        try saveContext()
    }
}

// MARK: - TrackerRecordStoreProtocol

extension TrackerRecordStore: TrackerRecordStoreProtocol {
    
    func recordsFetch(for tracker: Tracker) throws -> [TrackerRecord] {
        try fetchRecords(tracker)
    }
    
    func addRecord(with id: UUID, by date: Date) throws {
        try createNewRecord(id: id, date: date)
    }
    
    func deleteRecord(with id: UUID, by date: Date) throws {
        try removeRecord(idTracker: id, date: date)
    }
}
