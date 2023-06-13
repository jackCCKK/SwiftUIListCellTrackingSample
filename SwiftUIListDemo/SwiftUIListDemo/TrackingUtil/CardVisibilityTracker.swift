import Foundation
import Combine

class CardVisibilityTracker: ObservableObject {
    @Published var visibleCards: Set<CardDataStructure> = []
    private var cancellables = Set<AnyCancellable>()
    
    weak var cellVisibilityDelegate: CellVisibilityDelegate?
    
    func cardAppeared(_ card: CardDataStructure) {
        visibleCards.insert(card)
    }
    
    func cardDisappeared(_ card: CardDataStructure) {
        visibleCards.remove(card)
    }
    
    func filterVisibleCards(_ visibleCards: Set<CardDataStructure>) -> Array<Int> {
        var validIds: Set<Int> = []
        
        for case let .basic(id, _, _) in visibleCards {
            let headerId = -id
            let footerId = -10 * id
            
            if visibleCards.contains(.header(id: headerId)) && visibleCards.contains(.footer(id: footerId)) {
                validIds.insert(id)
            }
        }
        
        for case let .detailed(id, _, _, _) in visibleCards {
            let headerId = -id
            let footerId = -10 * id
            
            if visibleCards.contains(.header(id: headerId)) && visibleCards.contains(.footer(id: footerId)) {
                validIds.insert(id)
            }
        }
        
        return validIds.sorted()
    }
    
    init() {
        setupSubscription()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    private func setupSubscription() {
        $visibleCards
            .debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] cards in
                if let self = self {
                    let validIds = self.filterVisibleCards(self.visibleCards)
                    self.cellVisibilityDelegate?.visibleCellsChanged(visibleCells: validIds)
                }
            }
            .store(in: &cancellables)
    }
}
