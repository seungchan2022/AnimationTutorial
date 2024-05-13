import SwiftUI
import LinkNavigator

@main
struct AppMain: App {
  
  let navigator: SingleLinkNavigator = .init(routeBuilderItemList: RouteBuilderGroup.release, dependency: AppDependency() )
  
  var body: some Scene {
    WindowGroup {
      LinkNavigationView(
        linkNavigator: navigator,
        item: .init(path: Link.home.rawValue),
      prefersLargeTitles: true)
      
      .ignoresSafeArea()
    }
  
  }
}
