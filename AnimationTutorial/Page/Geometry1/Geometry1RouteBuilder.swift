import LinkNavigator

struct Geometry1RouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.geometry1.rawValue
    
    return .init(matchPath: matchPath) { navigator, items, diContainer in
      WrappingController(matchPath: matchPath) {
        Geometry1Page()
      }
    }
  }
}
