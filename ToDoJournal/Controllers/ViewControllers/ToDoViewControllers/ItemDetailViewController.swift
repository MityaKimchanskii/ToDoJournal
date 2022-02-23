//
//  ItemDetailViewController.swift
//  ToDoJournal
//
//  Created by Mitya Kim on 2/18/22.
//

import UIKit

class ItemDetailViewController: UIViewController {

    // MARK: - Properties
    var item: Item?
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameItemTextField: UITextField!
    @IBOutlet weak var timeDatePicker: UIDatePicker!
    
    // MARK: - Properties
    var item: Item?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameItemTextField.text, !name.isEmpty else { return }
        let time = timeDatePicker.date
        if let item = item {
            ItemController.shared.updateItem(item: item, name: name, time: time)
        } else {
            ItemController.shared.createItem(name: name, time: time)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onOfTimeSwitchTapped(_ sender: UISwitch) {
        
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        if let item = item {
            title = "Edit Item"
            nameItemTextField.text = item.name
            timeDatePicker.date = item.time ?? Date()
        } else {
            title = "Add New Item"
        }
    }
}
