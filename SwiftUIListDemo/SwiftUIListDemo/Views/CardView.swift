import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: CardViewModel
    var card: CardDataStructure
    
    var validIds: [Int] = [1, 2, 3, 4]
    
    var body: some View {
        Group {
            switch card {
            case .basic, .detailed:
                BasicCardView(viewModel: viewModel, card: card)
            case .header, .footer:
                HorizontalLine(color: .white.opacity(0), height: 1.0)
                    .frame(height: 1)
            }
        }
        .onAppear { viewModel.cardAppeared(card) }
        .onDisappear { viewModel.cardDisappeared(card) }
    }
}
