import SwiftUI
import Combine

struct ContentView: View {
    
    @ObservedObject var viewModel: CardViewModel
    
    init(dataService: CardProvider) {
        self.viewModel = CardViewModel(dataService: dataService)
    }
    
    @State private var animationAmount = 1.0
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 1) {
                ForEach(viewModel.dataService.cards) { card in
                    CardView(viewModel: viewModel, card: card)
                }
            }
        }
    }
}

struct HorizontalLine: View {
    var color: Color = .black
    var height: CGFloat = 1.0
    
    var body: some View {
        Rectangle()
            .foregroundColor(color)
            .frame(height: height)
    }
}

struct BasicCardView: View {
    @ObservedObject var viewModel: CardViewModel
    var card: CardDataStructure
    
    var isValidCard: Bool {
        switch card {
        case let .basic(id, _, _),
            let .detailed(id, _, _, _),
            let .header(id),
            let .footer(id):
            return viewModel.validIds.contains(id)
        }
    }
    
    
    
    @State private var scale: CGFloat = 1.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var backgroundColor: Color {
        switch card {
        case .basic:
            return Color.yellow
        case .detailed:
            return Color.blue
        case .header, .footer:
            return Color.clear
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(1...2, id: \.self) { _ in
                    Image(systemName: "eye.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .opacity(0)
                }
            }
            .padding(.trailing, 10)
            
            switch card {
            case let .basic(_, imageName, title),
                let .detailed(_, imageName, title, _):
                Image(systemName: imageName)
                    .imageScale(.large)
                    .foregroundColor(.white)
                Text(title)
                    .foregroundColor(.white)
                Text("This is a Car card.")
                    .foregroundColor(.white)
            case .header, .footer:
                EmptyView()
            }
        }
        .padding(.leading, 10)
        .padding(.top, 10)
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: .infinity,
               alignment: .topLeading)
        .frame(height: 200)
        .background(backgroundColor)
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(radius: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                .padding(.horizontal)
        )
        .scaleEffect(isValidCard ? scale : 1.0)
        .onAppear {
            if isValidCard {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    scale = 0.9
                }
            }
        }
        .onReceive(timer) { _ in
            if self.isValidCard {
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.scale = self.scale == 1.0 ? 0.9 : 1.0
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataService: DataService())
    }
}

enum CardType {
    case basic
    case detailed
    case header
    case footer
}


