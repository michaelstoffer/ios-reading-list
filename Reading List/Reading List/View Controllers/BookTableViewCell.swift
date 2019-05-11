//
//  BookTableViewCell.swift
//  Reading List
//
//  Created by Michael Stoffer on 5/10/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var hasBeenReadButton: UIButton!
    
    var book: Book? {
        didSet {
            self.updateViews()
        }
    }
    
    weak var delegate: BookTableViewCellDelegate?
    
    private func updateViews() {
        guard let book = self.book else { return }
        
        self.bookLabel.text = book.title

        if book.hasBeenRead == true {
            let checked = UIImage(named: "checked")
            self.hasBeenReadButton.setImage(checked, for: .normal)
        } else {
            let unchecked = UIImage(named: "unchecked")
            self.hasBeenReadButton.setImage(unchecked, for: .normal)
        }
    }
    
    @IBAction func hasBeenReadButtonTapped(_ sender: Any) {
        delegate?.toggleHasBeenRead(for: self)
    }
}
