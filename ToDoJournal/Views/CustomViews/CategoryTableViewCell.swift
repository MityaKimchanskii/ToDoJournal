//
//  CategoryTableViewCell.swift
//  ToDoJournal
//
//  Created by Mitya Kim on 2/17/22.
//

import UIKit

protocol isDoneCategoryDelegate: AnyObject {
    func completeButtonTapped(_ sender: CategoryTableViewCell)
}

class CategoryTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var isDoneButton: UIButton!
    @IBOutlet weak var categoriLabel: UILabel!
    @IBOutlet weak var itemsCountLabel: UILabel!
    
    // MARK: - Properties
    var category: Category? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: isDoneCategoryDelegate?
    
    // MARK: - IBActions
    @IBAction func isDoneButtonTapped(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.completeButtonTapped(self)
        }
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        guard let category = category else { return }
        categoriLabel.text = category.name
        
        itemsCountLabel.text = "\(ItemController.shared.itemsCount(for: category))/\(ItemController.shared.countIsDoneItems(for: category))"
        
        if category.isDone {
            isDoneButton.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isDoneButton.tintColor = .green
        } else {
            isDoneButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            isDoneButton.tintColor = .red
        }
    }
}
