import LinkNavigator

struct HomeRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.home.rawValue
    
    return .init(matchPath: matchPath) { navigator, items, diContainer in
      WrappingController(matchPath: matchPath) {
        HomePage(navigator: navigator)
      }
    }
  }
}
