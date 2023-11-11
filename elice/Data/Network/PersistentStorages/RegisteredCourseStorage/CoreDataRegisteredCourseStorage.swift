//
//  CoreDataRegisteredCourseStorage.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation
import RxSwift
import CoreData

final class CoreDataRegisteredCourseStorage {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = .shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: - Private
    
    private func delete(
        id: String,
        in context: NSManagedObjectContext
    ) {
        let request = fetchRequest(id: id)
        
        do {
            let courses = try context.fetch(request)
            for course in courses{
                context.delete(course)
            }
            try context.save()
        } catch {
            context.rollback()
        }
    }
    
    private func append(
        id: String,
        in context: NSManagedObjectContext
    ) {
        let course = RegisteredCourseEntity(context: context)
        course.courseId = id
        
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
    
    private func fetchRequest(
        id: String
    ) -> NSFetchRequest<RegisteredCourseEntity> {
        let request: NSFetchRequest = RegisteredCourseEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(RegisteredCourseEntity.courseId), id
        )
        return request
    }
}

extension CoreDataRegisteredCourseStorage: RegisteredCourseStorage {
    func fetchRegisterCoursesIds() -> Observable<Result<[String], Error>> {
        return Observable.create { [weak self] observer -> Disposable in
            self?.coreDataStorage.performBackgroundTask { context in
                do {
                    let request = RegisteredCourseEntity.fetchRequest()
                    let entities = try context.fetch(request)
                    observer.onNext(.success(entities.compactMap { $0.courseId }))
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func request(
        query: CourseRegisterQuery, id: String
    ) {
        coreDataStorage.performBackgroundTask { [weak self] context in
            switch query {
            case .register:
                self?.append(id: id, in: context)
            case .unregister:
                self?.delete(id: id, in: context)
            }
        }
    }
}
