import SwiftUI
import LinkNavigator

struct Geometry2Page {
  let navigator: LinkNavigatorProtocol

  
  @State private var currentItem: Today?
  @State private var isShowDetail = false
  
  @Namespace var animation
  
  // MARK: Detail Animation Properties
  @State private var isShowDetailAnimation = false
  @State private var isShowAnimateContent = false
  @State private var scrollOffset: CGFloat = .zero
}

extension Geometry2Page: View {
  
  // MARK: CardView
  @ViewBuilder
  func CardView(item: Today) -> some View {
    VStack(alignment: .leading, spacing: 15) {
      ZStack(alignment: .topLeading) {
        
        // Banner Image
        GeometryReader { proxy in
          
          Image(item.artwork)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 15))
        }
        .frame(height: 400)
        
        LinearGradient(
          colors: [.black.opacity(0.5), .black.opacity(0.2)],
          startPoint: .top,
          endPoint: .bottom)
        
        VStack(alignment: .leading, spacing: 8) {
          Text(item.platfomrTitle.uppercased())
            .font(.callout)
            .fontWeight(.semibold)
          
          Text(item.bannerTitle)
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
        }
        .padding()
        .offset(y: currentItem?.id == item.id ? safeArea().top : .zero)
      }
      
      HStack(spacing: 12) {
        Image(item.appLogo)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 60, height: 60)
          .clipShape(RoundedRectangle(cornerRadius: 15))
        
        VStack(alignment: .leading, spacing: 4) {
          Text(item.platfomrTitle.uppercased())
            .font(.caption)
            .foregroundStyle(.gray)
          
          Text(item.appName)
            .fontWeight(.bold)
          
          Text(item.appDescription)
            .font(.caption)
            .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Button(action: { }) {
          Text("GET")
            .fontWeight(.bold)
            .foregroundStyle(.blue)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background {
              Capsule()
                .fill(.ultraThinMaterial)
            }
        }
      }
      
      .padding([.horizontal, .bottom])
      
    }
    .background {
      RoundedRectangle(cornerRadius: 15)
        .fill(.gray.opacity(0.3))
    }
    .matchedGeometryEffect(id: item.id, in: animation)
  }
    
  
  var body: some View {
    ScrollView {
      VStack(spacing: .zero) {
        HStack(alignment: .bottom) {
          VStack(alignment: .leading, spacing: 8) {
            Text("MONDAY 4 APRIL")
              .font(.callout)
              .foregroundStyle(.gray)
            
            Text("Today")
              .font(.largeTitle)
              .fontWeight(.bold)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          
          Button(action: { 
            navigator.back(isAnimated: true)
            
          }) {
            Image(systemName: "person.circle.fill")
              .font(.largeTitle)
          }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .opacity(isShowDetail ? .zero : 1)
        
        ForEach(todayItemList) { item in
          Button(action: {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
              currentItem = item
              isShowDetail = true
            }
          }) {
            CardView(item: item)
            /// For Matched Geometry Effect We Didnt applied Padding
            /// Instead Applying Scaling
            /// Approx Scaling Value to match Padding
              .scaleEffect(currentItem?.id == item.id && isShowDetail ? 1 : 0.93)
          }
          .foregroundStyle(.primary)
          .buttonStyle(ScaledButtonStyle())
          .opacity(isShowDetail ? (currentItem?.id == item.id ? 1 : .zero) : 1)
        }
      }
      .padding(.vertical)
    }
    .toolbar(.hidden, for: .navigationBar)
    .overlay {
      if let currentItem = currentItem, isShowDetail {
        DetailView(item: currentItem)
          .ignoresSafeArea(.container, edges: .all)
      }
    }
    .background(alignment: .top) {
      RoundedRectangle(cornerRadius: 15)
        .fill(.gray.opacity(0.3))
        .frame(height: isShowDetailAnimation ? .none : 350, alignment: .top)
        .scaleEffect(isShowDetailAnimation ? 1 : 0.93)
        .opacity(isShowDetailAnimation ? 1 : .zero)
        .ignoresSafeArea()
    }
  }
  
  // MARK: Detail View
  func DetailView(item: Today) -> some View {
    ScrollView {
      VStack {
        CardView(item: item)
          .scaleEffect(isShowDetailAnimation ? 1 : 0.93)
        
        VStack(spacing: 15) {
          Text(dummyText)
            .multilineTextAlignment(.leading)
            .lineSpacing(10)
            .padding(.bottom, 20)
          
          Divider()
          
          Button(action: {}) {
            HStack {
              Image(systemName: "square.and.arrow.up.fill")
              
              Text("Share Story")
            }
          }
          .foregroundStyle(.primary)
          .padding(.vertical, 10)
          .padding(.horizontal, 25)
          .background {
            RoundedRectangle(cornerRadius: 5)
              .fill(.ultraThinMaterial)
          }
        }
        .padding()
        .offset(y: scrollOffset > .zero ? scrollOffset : .zero)
        .opacity(isShowAnimateContent ? 1 : .zero)
        .scaleEffect(isShowDetail ? 1 : .zero, anchor: .top )
      }
      .offset(y: scrollOffset > .zero ? -scrollOffset : .zero)
      .offset(offset: $scrollOffset)
    }
    .overlay(alignment: .topTrailing) {
      Button(action: {
        // Closing
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
          isShowDetailAnimation = false
          isShowAnimateContent = false
        }
        
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.05)) {
          currentItem = .none
          isShowDetail = false
        }
        
      }) {
        Image(systemName: "xmark.circle.fill")
          .font(.title)
          .foregroundStyle(.white)
      }
      .padding()
      .padding(.top, safeArea().top)
      .opacity(isShowDetailAnimation ? 1 : .zero)
    }
    .onAppear {
      withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
        isShowDetailAnimation = true
      }
      
      withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.1)) {
        isShowAnimateContent = true
      }
    }
    .transition(.identity)
  }
}
// MARK: ScaledButton Style
struct ScaledButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.93 : 1)
      .animation(.easeInOut, value: configuration.isPressed)
  }
}

// MARK: Safe Area Value
extension View {
  func safeArea() -> UIEdgeInsets {
    guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
    
    guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
    
    return safeArea
  }
  
  // MARK: ScrollView Offset
  func offset(offset: Binding<CGFloat>) -> some View {
    return self
      .overlay {
        GeometryReader { proxy in
          let minY = proxy.frame(in: .named("SCROLL")).minY
          
          Color.clear
            .preference(key: OffsetKey2.self, value: minY)
        }
        .onPreferenceChange(OffsetKey2.self) { value in
          offset.wrappedValue = value
        }
      }
  }
}


// MARK: Offset Key
 struct OffsetKey2: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
