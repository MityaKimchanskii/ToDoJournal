//
//  CategoryController.swift
//  ToDoJournal
//
//  Created by Mitya Kim on 2/16/22.
//

import Foundation
import CoreData

class CategoryController {
    
    static let shared = CategoryController()
    
    private init() {}
    
    var selectedDate: Date?
    
    private var fetchRequest: NSFetchRequest<Category> {
        let request = NSFetchRequest<Category>(entityName: "Category")
        let startTime = Calendar.current.startOfDay(for: selectedDate ?? Date())
        request.predicate = NSPredicate(format: "date == %@", argumentArray: [startTime])
        return request
    }
    
    var categories: [Category] = []
    
    private var fetchRequestDateEvents: NSFetchRequest<Category> {
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.predicate = NSPredicate(value: true)
        return request
    }

    var eventDates: [String] = []

    // MARK: - CRUD
    func fetchCategoriesDates(categories: [Category]) -> [String] {
        self.categories = categories
        let categories = (try? CoreDataStack.context.fetch(self.fetchRequestDateEvents)) ?? []
        for category in categories {
            guard let categoryDate = category.date?.dateForEvents() else { return [] }
            eventDates.append(categoryDate)
        }
        return eventDates
    }
    
    func createCategory(name: String, date: Date) {
        let startTime = Calendar.current.startOfDay(for: date)
        let newCategory = Category(name: name, date: startTime)
        categories.append(newCategory)
        CoreDataStack.saveContext()
    }
    
    func fetchCategory(selectedDate: Date) {
        self.selectedDate = selectedDate
        let categories = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        self.categories = categories
    }
    
    func updateCategory(category: Category, name: String, isDone: Bool) {
        category.name = name
        category.isDone = isDone
        CoreDataStack.saveContext()
    }
    
    func deleteCategory(categoryToDelete: Category) {
        guard let index = categories.firstIndex(of: categoryToDelete) else { return }
        categories.remove(at: index)
        CoreDataStack.context.delete(categoryToDelete)
        CoreDataStack.saveContext()
    }
    
    func toggleIsDone(category: Category) {
        category.isDone.toggle()
        CoreDataStack.saveContext()
    }
}
