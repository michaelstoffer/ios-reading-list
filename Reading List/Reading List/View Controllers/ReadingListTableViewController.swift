//
//  ReadingListTableViewController.swift
//  Reading List
//
//  Created by Michael Stoffer on 5/10/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ReadingListTableViewController: UITableViewController {
    
    let bookController = BookController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return self.bookController.readBooks.count > 0 ? "Read Books" : ""
            default:
                return self.bookController.unreadBooks.count > 0 ? "Unread Books" : ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return self.bookController.readBooks.count
            default:
                return self.bookController.unreadBooks.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookTableViewCell else { return UITableViewCell() }
        
        let book = bookFor(indexPath: indexPath)
        cell.bookLabel.text = book.title
        cell.delegate = self
        
        let image = book.hasBeenRead == true ? UIImage(named: "checked") : UIImage(named: "unchecked")
        cell.hasBeenReadButton.setImage(image, for: .normal)

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let book = bookFor(indexPath: indexPath)
            self.bookController.removeBook(withBook: book)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    private func bookFor(indexPath: IndexPath) -> Book {
        if indexPath.section == 0 {
            return self.bookController.readBooks[indexPath.row]
        } else {
            return self.bookController.unreadBooks[indexPath.row]
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddToDetail" {
            guard let bookDetailVC = segue.destination as? BookDetailViewController else { return }
            bookDetailVC.bookController = self.bookController
        } else if segue.identifier == "ToDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let bookDetailVC = segue.destination as? BookDetailViewController else { return }
            
            let book = bookFor(indexPath: indexPath)
            bookDetailVC.book = book
            bookDetailVC.bookController = self.bookController
        }
    }
}

extension ReadingListTableViewController: BookTableViewCellDelegate {
    func toggleHasBeenRead(for cell: BookTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }

        let book = bookFor(indexPath: indexPath)
        self.bookController.updateHasBeenRead(for: book)
        
        tableView.reloadData()
    }
}
