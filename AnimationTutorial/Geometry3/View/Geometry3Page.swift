import SwiftUI
import LinkNavigator

struct Geometry3Page {
  @State private var searchText: String = ""
  
  let navigator: LinkNavigatorProtocol

}

extension Geometry3Page: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 15) {
        HStack(spacing: 12) {
          Button(action: { navigator.back(isAnimated: true) }) {
            Image(systemName: "line.3.horizontal")
              .font(.title)
              .foregroundStyle(.blue)
          }
          
          HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
              .foregroundStyle(.gray)
            
            TextField("Search", text: $searchText)
          }
          .padding(.horizontal, 15)
          .padding(.vertical, 10)
          .background(.ultraThinMaterial, in: .capsule)
        }
        
        Text("Where do yo want to \ntravle?")
          .font(.largeTitle)
          .fontWeight(.bold)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top, 10)
        
        /// Parallax Carousel
        GeometryReader { geometry in
          
          ScrollView(.horizontal) {
            HStack(spacing: 10) {
              ForEach(tripCardList) { card in
                GeometryReader { proxy in
                  let minX = proxy.frame(in: .scrollView).minX - 30.0
                  
                  Image(card.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(x: -minX)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .overlay {
                      OverlayView(item: card)
                    }
                    .clipShape(.rect(cornerRadius: 15))
                    .shadow(color: .black.opacity(0.23), radius: 8, x: 5, y: 10)
                } // proxy
                .frame(width: geometry.size.width - 60, height: geometry.size.height - 50)
                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                  view.scaleEffect(phase.isIdentity ? 1 : 0.95)
                }
              }
            }
            .padding(.horizontal, 30)
            .scrollTargetLayout()
            .frame(height: geometry.size.height, alignment: .top)
          } // geometry
          .scrollTargetBehavior(.viewAligned)
          .scrollIndicators(.hidden)
          
        }
        .frame(height: 500)
        .padding(.horizontal, -15)
      }
      .padding(15)
    }
    .scrollIndicators(.hidden)
    .navigationBarTitleDisplayMode(.inline)
  }
  
  /// Overlay View
  @ViewBuilder
  func OverlayView(item: TripCard) -> some View {
    ZStack(alignment: .bottomLeading) {
      LinearGradient(
        colors: [
          .clear,
          .clear,
          .clear,
          .clear,
          .clear,
          .black.opacity(0.1),
          .black.opacity(0.5),
          .black
        ],
        startPoint: .top, endPoint: .bottom)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(item.title)
          .font(.title2)
          .fontWeight(.black)
          .foregroundStyle(.white)
        
        
        Text(item.subTitle)
          .font(.callout)
          .foregroundStyle(.white.opacity(0.67))
      }
      .padding(20)
    }
  }
}
