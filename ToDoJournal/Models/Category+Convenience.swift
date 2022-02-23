//
//  Category+Convenience.swift
//  ToDoJournal
//
//  Created by Mitya Kim on 2/16/22.
//

import Foundation
import CoreData

extension Category {
    @discardableResult convenience init(name: String, date: Date, isDone: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.date = date
        self.isDone = isDone
    }
}
