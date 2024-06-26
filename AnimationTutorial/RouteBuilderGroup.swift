import LinkNavigator

struct RouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public init() { }
}

extension RouteBuilderGroup {
  static var release: [RouteBuilderOf<RootNavigator>] {
    [
      HomeRouteBuilder.generate(),
      Geometry1RouteBuilder.generate(),
      Geometry1DetailRouteBuilder.generate(),
      Geometry2RouteBuilder.generate(),
      Geometry3RouteBuilder.generate(),
      Geometry4RouteBuilder.generate(),
    ]
  }
}
