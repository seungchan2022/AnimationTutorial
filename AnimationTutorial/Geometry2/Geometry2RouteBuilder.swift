import LinkNavigator

struct Geometry2RouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.geometry2.rawValue
    
    return .init(matchPath: matchPath) { navigator, items, diContainer in
      WrappingController(matchPath: matchPath) {
        Geometry2Page(navigator: navigator)
      }
    }
  }
}
