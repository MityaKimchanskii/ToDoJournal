//
//  ItemController.swift
//  ToDoJournal
//
//  Created by Mitya Kim on 2/16/22.
//

import Foundation
import CoreData

class ItemController {
    
    // MARK: - Properties
    static let shared = ItemController()
    
    var selectedCategory : Category?
    
    private init() {}
    
    private lazy var fetchRequest: NSFetchRequest<Item> = {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    var items: [Item] = []

    
    // MARK: - Helper Methods
    func items(for categoty: Category) -> [Item] {
            return categoty.item?.allObjects as! [Item]
    }
    
    func itemsCount(for categoty: Category) -> Int  {
        return categoty.item?.allObjects.count ?? 0
    }
    
    
    
    var itemsIsDone: [Item] = []

    func countIsDoneItems(for categoty: Category) -> Int  {
        let itemsAr = categoty.item?.allObjects as! [Item]
        for item in itemsAr {
            if item.isDone {
                itemsIsDone.append(item)
            }
        }
        print(itemsIsDone.count)
        return itemsIsDone.count
    }
    
    
    
    
    
    
    
    // MARK: - CRUD
    func createItem(name: String, time: Date? = Date()) {
        guard let selectedCategory = selectedCategory else { return }
        let newItem = Item(name: name, time: time ?? Date())
        newItem.parentCategory = selectedCategory
        items.append(newItem)
        CoreDataStack.saveContext()
    }
    
    func fetchItem() {
        let items = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        self.items = items
    }
    
    func updateItem(item: Item, name: String, time: Date?) {
        guard let selectedCategory = selectedCategory else { return }
        item.parentCategory = selectedCategory
        item.time = time
        item.name = name
        CoreDataStack.saveContext()
    }
    
    func deleteItem(itemToDelete: Item) {
//        guard let selectedCategory = selectedCategory else { return }
//        itemToDelete.parentCategory = selectedCategory
        guard let index = items.firstIndex(of: itemToDelete) else { return }
        items.remove(at: index)
        CoreDataStack.context.delete(itemToDelete)
        CoreDataStack.saveContext()
    }
    
    func toggleIsDone(item: Item) {
        item.isDone.toggle()
        CoreDataStack.saveContext()
    }
}
