import LinkNavigator

struct Geometry4RouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.geometry4.rawValue
    
    return .init(matchPath: matchPath) { navigator, items, diContainer in
      WrappingController(matchPath: matchPath) {
        Geometry4Page()
      }
    }
  }
}
