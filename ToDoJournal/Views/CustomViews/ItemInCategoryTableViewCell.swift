//
//  CategoryListTableViewCell.swift
//  ToDoJournal
//
//  Created by Mitya Kim on 2/17/22.
//

import UIKit

protocol isDoneItemDelegate: AnyObject {
    func isDoneButtonToggle(_ sender: ItemInCategoryTableViewCell)
}

class ItemInCategoryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameItemLabel: UILabel!
    @IBOutlet weak var timeItemLabel: UILabel!
    @IBOutlet weak var isDoneItemButton: UIButton!
    
    // MARK: - Properties
    var item: Item? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: isDoneItemDelegate?

    // MARK: - IBActions
    @IBAction func isDoneItemButtonTapped(_ sender: Any) {
        if let delegate = delegate {
            delegate.isDoneButtonToggle(self)
        }
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        guard let item = item, let time = item.time else { return }
        nameItemLabel.text = item.name
        timeItemLabel.text = "\(time.formatted(date: .omitted, time: .shortened))"
        if item.isDone {
            isDoneItemButton.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isDoneItemButton.tintColor = .green
        } else {
            isDoneItemButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            isDoneItemButton.tintColor = .red
        }
    }
}
