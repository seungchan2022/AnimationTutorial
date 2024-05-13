import Foundation

struct PicItem: Equatable, Identifiable {
  let id: UUID = .init()
  let image: String
}
