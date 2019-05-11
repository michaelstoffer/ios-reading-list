//
//  BookDetailViewController.swift
//  Reading List
//
//  Created by Michael Stoffer on 5/10/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var reasonToReadTextView: UITextView!
    
    var book: Book?
    var bookController: BookController?
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateViews()
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = self.titleTextField.text,
            let reasonToRead = self.reasonToReadTextView.text else { return }
        
        if self.book == nil {
            self.bookController?.createBook(withTitle: title, withReasonToRead: reasonToRead)
            navigationController?.popViewController(animated: true)
        } else {
            guard let book = self.book else { return }
            self.bookController?.updateBook(withBook: book, withTitle: title, withReasonToRead: reasonToRead)
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func updateViews() {
        if let book = self.book {
            self.title = book.title
            self.titleTextField.text = book.title
            self.reasonToReadTextView.text = book.reasonToRead
        } else {
            self.title = "Add a new book"
        }
    }
}
