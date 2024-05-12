import SwiftUI
import LinkNavigator

struct HomePage {
  let navigator: LinkNavigatorProtocol
}

extension HomePage: View {
  var body: some View {
    ScrollView {
      VStack {
        Text("HomePage")
        Button(action: {
          navigator.backOrNext(
            linkItem: .init(path: Link.geometry1.rawValue),
            isAnimated: true) })
        {
          Text("Geometry 1")
        }
      }
    }
    .navigationTitle("")
  }
}
