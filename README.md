# ZipSortedly

`ZipSortedly` is a simple and lightweight Swift `Sequence` that takes two pre-ordered collections of any type plus a comparator function, and iterates through both sequences according to the comparator function until all the elements have been visited exactly once.

### Where could ZipSortedly be used?

Say you have an list of books ordered by date completed and book reviews ordered by date written, and you want to display an activity feed that displays both events in date order, merged to together, like so:

```
Review written (1 day ago)
Book finished (3 days ago)
Book finished (20 days ago)
Review written (42 daya ago)
```

### How is ZipSortedly used?

Here's a simple example:

```swift
// These dates are modeled as numbers for ease of testing but the comparison
// works for actual dates too (indeed, any Comparable object).
struct Review: Equatable {
    var dateWritten: Date
    // ...
}
struct Book: Equatable {
    var dateCompleted: Date
    // ...
}

// Reviews and books are sorted by dateWritten/dateCompleted ascending
var reviews = [...]
var books = [...]

let zipped = ZipSortedly(reviews, books) { $0.dateWritten < $1.dateCompleted }

for item in zipped {
    switch item {
    case .ofFirst(let review): // Do some rendering with the review
    	print("A\(review.dateWritten)")
    case .ofSecond(let book): // Do some rendering with the book
    	print("B\(book.dateCompleted)")
    }
}
```

Note that each item is visited in order of dateWritten/dateCompleted not just in the scope of its own original collection, but in the scope of both collections.

Check out ExampleUsage.swift for some working example code and check out the test suite to see what results you should expect.

### Why is ZipSortedly cool*?

1. It conforms to Swift's `Sequence` type, allowing it to be used in `for ... in` loops.
2. It's completely type-safe thanks to Swift features like enums with associated types, conditional protocol conformance, and type erasure.
3. It has the minimum possible time complexity: each element is visited exactly once. The alternative would be a sequence of maps and sorts, which will be worse than linear.
4. It's powerful & flexible. Using the comparator function, you can zip any two types without needing to have them conform to Comparable and you can compare any of their properties.



*in my opinion

