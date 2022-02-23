//
//  Item+Convenience.swift
//  ToDoJournal
//
//  Created by Mitya Kim on 2/16/22.
//

import Foundation
import CoreData

extension Item {
    @discardableResult convenience init(name: String, time: Date, isDone: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.time = time
        self.isDone = isDone
    }
}
