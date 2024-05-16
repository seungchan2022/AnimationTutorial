import Foundation

struct TripCard: Equatable, Identifiable {
  let id: UUID = .init()
  let title: String
  let subTitle: String
  let image: String
}

let tripCardList: [TripCard] = [
  .init(title: "London", subTitle: "England", image: "pic1"),
  .init(title: "New York", subTitle: "USA", image: "pic2"),
  .init(title: "Prague", subTitle: "Czech Republic", image: "pic3"),
]
