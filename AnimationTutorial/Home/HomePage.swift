import SwiftUI
import LinkNavigator

struct HomePage {
  let navigator: LinkNavigatorProtocol
}

extension HomePage: View {
  var body: some View {
    
    List {
      Button(action: {
        navigator.backOrNext(
          linkItem: .init(path: Link.geometry1.rawValue),
          isAnimated: true) })
      {
        Text("Geometry 1")
      }
      
      Button(action: {
        navigator.backOrNext(
          linkItem: .init(path: Link.geometry2.rawValue),
          isAnimated: true) })
      {
        Text("Geometry 2")
      }
      
      Button(action: {
        navigator.backOrNext(
          linkItem: .init(path: Link.geometry3.rawValue),
          isAnimated: true) })
      {
        Text("Geometry 3")
      }
      
      Button(action: {
        navigator.backOrNext(
          linkItem: .init(path: Link.geometry4.rawValue),
          isAnimated: true) })
      {
        Text("Geometry 4")
      }
    }
    .navigationTitle("Home")
  }
}
