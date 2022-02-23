//
//  CategoryListTableViewController.swift
//  ToDoJournal
//
//  Created by Mitya Kim on 2/17/22.
//

import UIKit

class ItemsListTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var categoryLabel: UILabel!
    
    // MARK: - Properties
    var selectedCategory: Category?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemController.shared.fetchItem()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedCategory = selectedCategory else { return 0 }
        return ItemController.shared.items(for: selectedCategory).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemInCategoryTableViewCell else { return UITableViewCell() }
        let item = ItemController.shared.items[indexPath.row]
        cell.item = item
        cell.delegate = self
        cell.updateViews()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemTodelete = ItemController.shared.items[indexPath.row]
            ItemController.shared.deleteItem(itemToDelete: itemTodelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        guard let category = selectedCategory else { return }
        categoryLabel.text = category.name

        guard let dateMonth = category.date?.formatted(.dateTime.month(.wide)),
              let dateNumber =  category.date?.formatted(.dateTime.day())
        else { return }
        
        title = "\(dateMonth) \(dateNumber)"
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editItemSegue",
           let indexPath = tableView.indexPathForSelectedRow,
           let destiationVC = segue.destination as? ItemDetailViewController {
            let item = ItemController.shared.items[indexPath.row]
            destiationVC.item = item
        }
    }
}

extension ItemsListTableViewController: isDoneItemDelegate {
    func isDoneButtonToggle(_ sender: ItemInCategoryTableViewCell) {
        guard let item = sender.item else { return }
        ItemController.shared.toggleIsDone(item: item)
        sender.updateViews()
    }
}
