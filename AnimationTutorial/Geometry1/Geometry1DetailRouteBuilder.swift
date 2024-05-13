import LinkNavigator

struct Geometry1DetailRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.geometry1Detail.rawValue
    
    return .init(matchPath: matchPath) { navigator, items, diContainer in
      WrappingController(matchPath: matchPath) {
        Geometry1DetailPage(
          isShowDetail: .constant(false),
          isShowDetailAnimation: .constant(false),
          item: .init(username: "", content: "", picList: .init()),
          selectedPickID: .constant(.none),
          updateScrollAction: { _ in })
        
      }
    }
  }
}
