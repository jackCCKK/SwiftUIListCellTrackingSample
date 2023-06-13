import Combine

protocol CardProvider {
    var cards: [CardDataStructure] { get }
}

extension CardProvider {
    func addHeaderAndFooterToCards(_ cards: [CardDataStructure]) -> [CardDataStructure] {
        var modifiedCards: [CardDataStructure] = []
        
        for (_, card) in cards.enumerated() {
            switch card {
            case .basic(let id, _, _), .detailed(let id, _, _, _), .header(let id),.footer(let id):
                let headerCard = CardDataStructure.header(id: id * -1)
                let footerCard = CardDataStructure.footer(id: id * -10)
                
                modifiedCards.append(headerCard)
                modifiedCards.append(card)
                modifiedCards.append(footerCard)
            }
        }

        
        return modifiedCards
    }
}


class DataService: ObservableObject, CardProvider {
    @Published var cards = [CardDataStructure]()
    
    init() {
        cards = [
            .detailed(id: 1,imageName: "star", title: "Card 1", type: "detail"),
            .basic(id: 2, imageName: "star", title: "Card 2"),
            .detailed(id: 3,imageName: "star", title: "Card 3", type: "detail"),
            .basic(id: 4, imageName: "star", title: "Card 4"),
            .detailed(id: 5,imageName: "star", title: "Card 5", type: "detail"),
            .basic(id: 6, imageName: "star", title: "Card 6"),
            .detailed(id: 7,imageName: "star", title: "Card 7", type: "detail"),
            .basic(id: 8, imageName: "star", title: "Card 8"),
            .detailed(id: 9,imageName: "star", title: "Card 9", type: "detail"),
        ]
        
        cards = addHeaderAndFooterToCards(cards)
    }
}
