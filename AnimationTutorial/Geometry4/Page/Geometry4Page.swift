import SwiftUI

struct Geometry4Page {
  @State private var isRotationEnabled = true
  @State private var isShowIndicator = false
  
  @State private var isShowSheet = false
}


extension Geometry4Page  {
  /// Stack Cards Animation
  func minX(proxy: GeometryProxy) -> CGFloat {
    let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
    
    return minX < .zero ? .zero : -minX
  }
  
  /// 여기서 limit는 뒤에 보여질 카드 개수
  func progress(proxy: GeometryProxy, limit: CGFloat = 2) -> CGFloat  {
    let maxX = proxy.frame(in: .scrollView(axis: .horizontal)).maxX
    let width = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? .zero
    
    let progress = (maxX / width) - 1.0
    let cappedProgress = min(progress, limit)
    
    
    return cappedProgress
  }
  
  func scale(proxy: GeometryProxy, scale: CGFloat = 0.1) -> CGFloat {
    let progress = progress(proxy: proxy)
    
    return 1 - (progress * scale)
  }
  
  func excessMinX(proxy: GeometryProxy, offset: CGFloat = 10) -> CGFloat {
    let progress = progress(proxy: proxy)
    
    return progress * offset
  }
  
  func rotation(proxy: GeometryProxy, rotation: CGFloat = 5) -> Angle {
    let progress = progress(proxy: proxy)
    
    return .init(degrees: progress * rotation)
  }
}

extension Geometry4Page: View {
  /// Card View
  @ViewBuilder
  func CardView(item: Item) -> some View {
    RoundedRectangle(cornerRadius: 15)
      .fill(item.cardColor.gradient)
      .overlay {
        Text("\(item.cardColor)")
          .font(.largeTitle)
      }
  }
  
  var body: some View {
    
    VStack {
      GeometryReader { proxy in
        
        ScrollView(.horizontal) {
          HStack(spacing: .zero) {
            ForEach(itemList) { item in
              CardView(item: item)
                .padding(.horizontal, 64)
                .frame(width: proxy.size.width)
                .visualEffect { content, geometryProxy in
                  content
                    .scaleEffect(scale(proxy: geometryProxy, scale: 0.1), anchor: .trailing)
                    .rotationEffect(rotation(proxy: geometryProxy, rotation: isRotationEnabled ? 5 : .zero))
                    .offset(x: minX(proxy: geometryProxy))
                    .offset(x: excessMinX(proxy: geometryProxy, offset: 10))
                }
                .zIndex(itemList.zIndex(item: item))
            }
          }
          .padding(.vertical, 15)
        }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(isShowIndicator ? .visible : .hidden)
        .scrollIndicatorsFlash(trigger: isShowIndicator)
      }
      .frame(height: 400)
      .animation(.snappy, value: isRotationEnabled)
      
      
      GroupBox {
        Toggle("Rotation Enabled", isOn: $isRotationEnabled)
        
        Divider()
        
        Toggle("Shows Scroll Indicator", isOn: $isShowIndicator)
      }
      .padding(15)      
    }
    .navigationTitle("Stacked Cards")
  }
}

