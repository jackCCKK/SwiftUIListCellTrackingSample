import SwiftUI
import Combine

protocol CellVisibilityDelegate: AnyObject {
    func visibleCellsChanged(visibleCells: [Int])
    func cardAppeared(_ card: CardDataStructure)
    func cardDisappeared(_ card: CardDataStructure)
}

class CardViewModel: ObservableObject, CellVisibilityDelegate {
    
    @Published var validIds: [Int] = []
    
    func visibleCellsChanged(visibleCells: [Int]) {
        self.validIds = visibleCells
        print("Filtered visible cards: \(visibleCells)")
    }
    
    private(set) var dataService: CardProvider
    
    private let cardVisibilityTracker: CardVisibilityTracker
    
    func cardAppeared(_ card: CardDataStructure) {
        cardVisibilityTracker.cardAppeared(card)
    }
    
    func cardDisappeared(_ card: CardDataStructure) {
        cardVisibilityTracker.cardDisappeared(card)
    }
    
    init(dataService: CardProvider) {
        self.dataService = dataService
        self.cardVisibilityTracker = CardVisibilityTracker()
        self.cardVisibilityTracker.cellVisibilityDelegate = self
    }
}
