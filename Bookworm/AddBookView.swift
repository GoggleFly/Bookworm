//
//  AddBookView.swift
//  Bookworm
//
//  Created by David Ash on 30/08/2023.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = "Fantasy"
    @State private var review = ""
    
    @State private var showingValidationAlert = false
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        if performValidation() {
                            let newBook = Book(context: moc)
                            newBook.id = UUID()
                            newBook.title = title
                            newBook.author = author
                            newBook.rating = Int16(rating)
                            newBook.genre = genre
                            newBook.review = review
                            newBook.date = Date.now
                            
                            try? moc.save()
                            dismiss()
                        } else {
                            showingValidationAlert.toggle()
                        }
                    }
                }
            }
            .navigationTitle("Add Book")
            .alert("Uh oh!", isPresented: $showingValidationAlert) {
                Button("OK") { }
            } message: {
                Text("Please complete all details to save a book review.")
            }

        }
    }
    
    func performValidation() -> Bool {
        if title != "" && author != "" && review != "" {
            return true
        }
        
        return false
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
