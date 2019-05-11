//
//  BookController.swift
//  Reading List
//
//  Created by Michael Stoffer on 5/10/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class BookController {
    
    init() {
        self.loadFromPersistentStore()
    }
    
    private (set) var books: [Book] = []
    
    private var readingListURL: URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentsDirectory.appendingPathComponent("ReadingList.plist")
    }
    
    var readBooks: [Book] {
        return self.books.filter { $0.hasBeenRead == true }
    }
    
    var unreadBooks: [Book] {
        return self.books.filter { $0.hasBeenRead == false }
    }
    
    func createBook(withTitle title: String, withReasonToRead reasonToRead: String) {
        let book = Book(title: title, reasonToRead: reasonToRead)
        books.append(book)
        self.saveToPersistentStore()
    }
    
    func updateBook(withBook book: Book, withTitle title: String, withReasonToRead reasonToRead: String) {
        guard let i = books.firstIndex(of: book) else { return }
        books[i].title = title
        books[i].reasonToRead = reasonToRead
        self.saveToPersistentStore()
    }

    func updateHasBeenRead(for book: Book) {
        guard let i = books.firstIndex(of: book) else { return }
        books[i].hasBeenRead = !books[i].hasBeenRead
        self.saveToPersistentStore()
    }

    func removeBook(withBook book: Book) {
        guard let i = books.firstIndex(of: book) else { return }
        books.remove(at: i)
        self.saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        guard let url = self.readingListURL else { return }
        
        do {
            let encoder = PropertyListEncoder()
            let booksData = try encoder.encode(self.books)
            try booksData.write(to: url)
        } catch {
            NSLog("Error saving books data: \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        let fileManager = FileManager.default
        guard let url = self.readingListURL,
            fileManager.fileExists(atPath: url.path) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let decodedBooks = try decoder.decode([Book].self, from: data)
            self.books = decodedBooks
        } catch {
            NSLog("Error loading books data: \(error)")
        }
    }
}
