
// These dates are modeled as numbers for ease of testing but the comparison
// works for actual dates too (indeed, any Comparable object).
// Equatable conformance is simply to make tests run more smoothly.
struct Review: Equatable {
    var dateWritten: Double
    // ...
}
struct Book: Equatable {
    var dateCompleted: Int
    // ...
}

var reviews = [1, 3, 5, 6, 6, 8, 9].map(Review.init)
var books = [2, 3, 6, 9].map(Book.init)

let zipped = ZipSortedly(reviews, books) { $0.dateWritten < Double($1.dateCompleted) }

for item in zipped { // Each item is visited in date order
    switch item {
    case .ofFirst(let review): // Do some rendering with the review
        print("A\(review.dateWritten)")
    case .ofSecond(let book): // Do some rendering with the book
        print("B\(book.dateCompleted)")
    }
}

// Prints out: A1 B2 B3 A3 A5 B6 A6 A6 A8 B9 A9
