import Foundation

enum CardDataStructure: Identifiable, Hashable {
    case basic(id: Int, imageName: String, title: String)
    case detailed(id: Int, imageName: String, title: String, type: String)
    case header(id: Int)
    case footer(id: Int)
    
    var id: Int {
        switch self {
        case let .basic(id, _, _),
             let .detailed(id, _, _, _),
             let .header(id),
             let .footer(id):
            return id
        }
    }
}

