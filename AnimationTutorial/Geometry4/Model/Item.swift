import Foundation
import SwiftUI

struct Item: Equatable, Identifiable {
  let id: UUID = .init()
  let cardColor: Color
}

let itemList: [Item] = [
  .init(cardColor: .red),
  .init(cardColor: .blue),
  .init(cardColor: .green),
  .init(cardColor: .yellow),
  .init(cardColor: .pink),
  .init(cardColor: .purple),
]

extension [Item] {
  func zIndex(item: Item) -> CGFloat {
    if let index = firstIndex(where: { $0.id == item.id }) {
      return CGFloat(count) - CGFloat(index)
    }
    
    return .zero
  }
}
