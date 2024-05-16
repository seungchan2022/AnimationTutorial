import LinkNavigator

struct Geometry3RouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.geometry3.rawValue
    
    return .init(matchPath: matchPath) { navigator, items, diContainer in
      WrappingController(matchPath: matchPath) {
        Geometry3Page(navigator: navigator)
      }
    }
  }
}
