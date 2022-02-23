//
//  ToDoViewController.swift
//  ToDoJournal
//
//  Created by Mitya Kim on 2/16/22.
//

import UIKit
import FSCalendar

class CategoryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var monthWeekButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var heightCalendarConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var selectedDate: Date?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CategoryController.shared.fetchCategory(selectedDate: Date())
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.reloadData()
        
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.categoryTableView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func monthWeekButtonTapped(_ sender: Any) {
        if calendar.scope == .week {
            calendar.scope = .month
            
            UIView.animate(withDuration: 1) {
                self.heightCalendarConstraint.constant = 280
            }
            monthWeekButton.setTitle("Week", for: .normal)
           
        } else {
            calendar.scope = .week
            monthWeekButton.setTitle("Month", for: .normal)
            heightCalendarConstraint.constant = 120
        }
    }
    
    @IBAction func addCategoryButtonTapped(_ sender: Any) {

        var textField = UITextField()

        let alertController = UIAlertController(title: "Add a New Category", message: "Create a new category or list of task. Each category or list can have many task.", preferredStyle: .alert)
    
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            guard let category = textField.text, !category.isEmpty else { return }
            
            let date = self.selectedDate ?? Date()
            
            CategoryController.shared.createCategory(name: category, date: date)
            CoreDataStack.saveContext()
            
            self.categoryTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { text in
            textField = text
            textField.placeholder = "Add a New Category"
        }
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        navigationController?.tabBarController?.tabBar.scrollEdgeAppearance = navigationController?.tabBarController?.tabBar.standardAppearance
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemListSegue",
           let inidexPath = categoryTableView.indexPathForSelectedRow,
           let destinationVC = segue.destination as? ItemsListTableViewController {
            let category = CategoryController.shared.categories[inidexPath.row]
            ItemController.shared.selectedCategory = category
            destinationVC.selectedCategory = category
        }
    }
}

    // MARK: - Extensions for UITableView
extension CategoryViewController: UITableViewDelegate {}

extension CategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryController.shared.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoryTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        let category = CategoryController.shared.categories[indexPath.row]
        cell.category = category
        cell.delegate = self
        cell.updateViews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let categoryToDelete = CategoryController.shared.categories[indexPath.row]
            CategoryController.shared.deleteCategory(categoryToDelete: categoryToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Extension for Toggle Delegate
extension CategoryViewController: isDoneCategoryDelegate {
    func completeButtonTapped(_ sender: CategoryTableViewCell) {
        guard let isDoneCategory = sender.category else { return }
        CategoryController.shared.toggleIsDone(category: isDoneCategory)
        categoryTableView.reloadData()
    }
}

extension CategoryViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        CategoryController.shared.fetchCategory(selectedDate: date)
        self.categoryTableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let datesWithEvents = CategoryController.shared.fetchCategoriesDates(categories: CategoryController.shared.categories)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.string(from: date)
        
        if datesWithEvents.contains(dateString) {
            return 1
        }
        return 0
    }
}

