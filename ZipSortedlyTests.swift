import XCTest

class ZipSortedlyTests: XCTestCase {
    /// Takes two arrays, zips them, and returns an array of zipped results.
    func compile<A, B>(
        _ a: [A],
        _ b: [B],
        comparator: @escaping (A, B) -> Bool
    ) -> [ZipSortedly<A, B>.ZippedElement]
    {
        var result = [ZipSortedly<A, B>.ZippedElement]()
        for item in ZipSortedly(a, b, comparingWith: comparator) {
            result.append(item)
        }
        
        return result
    }
    
    func testEmptyInputs_EmptyOutput() {
        let reviews = [Review]()
        let books = [Book]()
        let result = compile(reviews, books, comparator: { $0.dateWritten <= Double($1.dateCompleted) })
        XCTAssertEqual(result, [])
    }
    
    func testEmptyFirst_ExactSecond() {
        let reviews = [Review]()
        let books = [4, 6, 8, 10].map(Book.init)
        let result = compile(reviews, books, comparator: { $0.dateWritten <= Double($1.dateCompleted) })
        let expected = books.map(ZipSortedly<Review, Book>.ZippedElement.ofSecond)
        XCTAssertEqual(result, expected)
    }
    
    func testEmptySecond_ExactFirst() {
        let reviews = [4, 6, 8, 10].map(Review.init)
        let books = [Book]()
        let result = compile(reviews, books, comparator: { $0.dateWritten <= Double($1.dateCompleted) })
        let expected = reviews.map(ZipSortedly<Review, Book>.ZippedElement.ofFirst)
        XCTAssertEqual(result, expected)
    }
    
    func testBothFull_NoMerging() {
        let reviews = [1, 2, 4].map(Review.init)
        let books = [10, 23].map(Book.init)
        let result = compile(reviews, books, comparator: { $0.dateWritten <= Double($1.dateCompleted) })
        let expected: [ZipSortedly<Review, Book>.ZippedElement] = [
            .ofFirst(Review(dateWritten: 1)),
            .ofFirst(Review(dateWritten: 2)),
            .ofFirst(Review(dateWritten: 4)),
            .ofSecond(Book(dateCompleted: 10)),
            .ofSecond(Book(dateCompleted: 23))
        ]
        XCTAssertEqual(result, expected)
    }
    
    func testBothFull_MergingCorrectly() {
        let reviews = [1, 5, 10].map(Review.init)
        let books = [3, 7].map(Book.init)
        let result = compile(reviews, books, comparator: { $0.dateWritten <= Double($1.dateCompleted) })
        let expected: [ZipSortedly<Review, Book>.ZippedElement] = [
            .ofFirst(Review(dateWritten: 1)),
            .ofSecond(Book(dateCompleted: 3)),
            .ofFirst(Review(dateWritten: 5)),
            .ofSecond(Book(dateCompleted: 7)),
            .ofFirst(Review(dateWritten: 10))
        ]
        XCTAssertEqual(result, expected)
    }
    
    func testEquivalentElements_MergingCorrectly() {
        let reviews = [1, 5, 10].map(Review.init)
        let books = [5, 10].map(Book.init)
        let result = compile(reviews, books, comparator: { $0.dateWritten <= Double($1.dateCompleted) })
        let expected: [ZipSortedly<Review, Book>.ZippedElement] = [
            .ofFirst(Review(dateWritten: 1)),
            .ofFirst(Review(dateWritten: 5)),
            .ofSecond(Book(dateCompleted: 5)),
            .ofFirst(Review(dateWritten: 10)),
            .ofSecond(Book(dateCompleted: 10))
        ]
        XCTAssertEqual(result, expected)
    }
    
    func testMergingSandwiching() {
        let reviews = [1, 2, 20].map(Review.init)
        let books = [10, 11].map(Book.init)
        let result = compile(reviews, books, comparator: { $0.dateWritten <= Double($1.dateCompleted) })
        let expected: [ZipSortedly<Review, Book>.ZippedElement] = [
            .ofFirst(Review(dateWritten: 1)),
            .ofFirst(Review(dateWritten: 2)),
            .ofSecond(Book(dateCompleted: 10)),
            .ofSecond(Book(dateCompleted: 11)),
            .ofFirst(Review(dateWritten: 20)),
        ]
        XCTAssertEqual(result, expected)
    }
    
    func testComparator_ControlsOrdering() {
        let reviews = [12, 11, 10].map(Review.init)
        let books = [11, 10].map(Book.init)
        let result = compile(reviews, books, comparator: { $0.dateWritten >= Double($1.dateCompleted) })
        let expected: [ZipSortedly<Review, Book>.ZippedElement] = [
            .ofFirst(Review(dateWritten: 12)),
            .ofFirst(Review(dateWritten: 11)),
            .ofSecond(Book(dateCompleted: 11)),
            .ofFirst(Review(dateWritten: 10)),
            .ofSecond(Book(dateCompleted: 10)),
        ]
        XCTAssertEqual(result, expected)
    }
}
