import Foundation

struct Post: Identifiable, Equatable {
  let id: UUID = .init()
  let username: String
  let content: String
  let picList: [PicItem]

  var scrollPosition: UUID?
}

var postListMock: [Post] = [
  .init(username: "iJustine", content: "Nature Pics", picList: picListMock1, scrollPosition: .none),
  .init(username: "iJustine", content: "Nature Pics", picList: picListMock2, scrollPosition: .none),
]

private var picListMock1: [PicItem] = (1...5).compactMap {
  return .init(image: "Pic \($0)")
}


private var picListMock2: [PicItem] = (1...5).reversed().compactMap {
  return .init(image: "Pic \($0)")
}
