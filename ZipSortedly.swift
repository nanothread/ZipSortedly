
/// This sequence allows iteration over two separate collections as one using a comparator
/// function that decides which element of the two sequences to return next. This could be useful
/// if you want to iterate over two pre-sorted arrays such that each element is operated on with respect
/// to its order in its counterpart array as well.
///
/// For example:
///
///     var ones = [1, 3, 5, 6, 6, 8, 9].map(TypeOne.init)
///     var twos = [2, 3, 6, 9].map(TypeOne.init)
///
///     let zipped = ZipSortedly(ones, twos) { $0.value < $1.value }
///
///     for item in zipped {
///         switch item {
///         case .ofFirst(let one): print("A\(one.value)")
///         case .ofSecond(let two): print("B\(two.value)")
///         }
///     }
///
/// will provide the following output:
///
///     A1 B2 B3 A3 A5 B6 A6 A6 A8 B9 A9
///
/// If the comparator function returns `true`, the first element will be evaluated before the second.
///
/// - Complexity: O(*N* + *M*) where *N* and *M* are the length of the two input arrays.
class ZipSortedly<A, B>: Sequence {
    enum ZippedElement {
        case ofFirst(A)
        case ofSecond(B)
    }
    
    private var aIterator: AnyIterator<A>
    private var bIterator: AnyIterator<B>
    
    private var currentA: A?
    private var currentB: B?
    
    private var comparator: (A, B) -> Bool
    
    init<X: Collection, Y: Collection>(
        _ aSequence: X,
        _ bSequence: Y,
        comparingWith shouldComeFirst: @escaping (A, B) -> Bool
    ) where
        X.Iterator.Element == A, Y.Iterator.Element == B
    {
        self.aIterator = AnyIterator(aSequence.makeIterator())
        self.bIterator = AnyIterator(bSequence.makeIterator())
        
        self.comparator = shouldComeFirst
        
        self.currentA = self.aIterator.next()
        self.currentB = self.bIterator.next()
    }
    
    private func nextElement() -> ZippedElement? {
        switch (currentA, currentB) {
        case (.none, .none): return nil
            
        case (.none, .some(let b)):
            currentB = bIterator.next()
            return .ofSecond(b)
            
        case (.some(let a), .none):
            currentA = aIterator.next()
            return .ofFirst(a)
            
        case (.some(let a), .some(let b)):
            if comparator(a, b) {
                currentA = aIterator.next()
                return .ofFirst(a)
            } else {
                currentB = bIterator.next()
                return .ofSecond(b)
            }
        }
    }
    
    func makeIterator() -> AnyIterator<ZippedElement> {
        AnyIterator<ZippedElement> {
            self.nextElement()
        }
    }
}

extension ZipSortedly.ZippedElement: Equatable where A: Equatable, B: Equatable { }
