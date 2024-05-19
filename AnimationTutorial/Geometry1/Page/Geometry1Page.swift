import SwiftUI

struct Geometry1Page {

  @State private var postList: [Post] = postListMock
  @State private var isShowDetail = false
  @State private var isShowDetailAnimation = false
  @State private var selectedPicID: UUID?
  @State private var selectedPost: Post?
}

extension Geometry1Page {
  @ViewBuilder
  private func CardView(item: Post) -> some View {
    VStack(spacing: 10) {
      HStack(spacing: 10) {
        Image(systemName: "person.circle.fill")
          .font(.largeTitle)
          .foregroundStyle(.teal)
          .frame(width: 30, height: 30)
          .background(.background)

        VStack(alignment: .leading, spacing: 4) {
          Text(item.username)
            .fontWeight(.semibold)
            .textScale(.secondary)

          Text(item.content)
        }

        Spacer(minLength: .zero)

        Button(action: {}) {
          Image(systemName: "ellipsis")
        }
        .foregroundStyle(.primary)
        .offset(y: -10)
      }

      VStack(alignment: .leading, spacing: 10) {
        GeometryReader { proxy in

          ScrollView(.horizontal) {
            HStack(spacing: 10) {
              ForEach(item.picList) { pic in
                LazyHStack(spacing: .zero) {
                  Image(pic.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: proxy.size.width)
                    .clipShape(.rect(cornerRadius: 10))
                }
                .frame(maxWidth: proxy.size.width)
                .frame(height: proxy.size.height)
                .anchorPreference(
                  key: OffsetKey.self,
                  value: .bounds,
                  transform: { [pic.id.uuidString: $0] })
                .onTapGesture {
                  selectedPost = item
                  selectedPicID = pic.id
                  isShowDetail = true
                }
                .contentShape(.rect)
                .opacity(selectedPicID == pic.id ? .zero : 1)
              }
            }
            .scrollTargetLayout()
          }
          .scrollPosition(id: .init(
            get: { item.scrollPosition },
            set: { _ in }))
          .scrollIndicators(.hidden)
          .scrollTargetBehavior(.viewAligned)
          .scrollClipDisabled()
        }
        .frame(height: 200)

        HStack(spacing: 10) {
          ImageButton(icon: "suit.heart") {

          }
          ImageButton(icon: "message") {

          }
          ImageButton(icon: "arrow.2.squarepath") {

          }
          ImageButton(icon: "paperplane") {

          }
        }
      }
      .safeAreaPadding(.leading, 45)

      HStack(spacing: 15) {
        Image(systemName: "person.circle.fill")
          .frame(width: 30, height: 30)
          .background(.background)

        Button("10 replies") {

        }

        Button("810 likes") {

        }
        .padding(.leading, -5)

        Spacer()
      }
      .textScale(.secondary)
      .foregroundStyle(.secondary)
    }
    .background(alignment: .leading) {
      Rectangle()
        .fill(.secondary)
        .frame(width: 1)
        .padding(.bottom, 30)
        .offset(x: 15, y: 10)
    }
  }

  @ViewBuilder
  func ImageButton(icon: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Image(systemName: icon)
    }
    .font(.title3)
    .foregroundStyle(.primary)
  }
}

extension Geometry1Page: View {
  var body: some View {
    VStack {
      ScrollView(.vertical) {
        VStack(spacing: 15) {
          ForEach(postList) { post in
            CardView(item: post)
          }
        }
        .safeAreaPadding(15)
      }
      .toolbar(isShowDetail ? .hidden : .visible, for: .navigationBar)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("Animation")
    }
    .overlay {
      if let selectedPost, isShowDetail {
        Geometry1DetailPage(
          isShowDetail: $isShowDetail,
          isShowDetailAnimation: $isShowDetailAnimation,
          item: selectedPost,
          selectedPickID: $selectedPicID,
          updateScrollAction: { id in
            if let index = postList.firstIndex(where: { $0.id == selectedPost.id }) {
              postList[index].scrollPosition = id
            }
          })
        .transition(.offset(y: 5))
      }
    }
    .overlayPreferenceValue(OffsetKey.self) { value in
      GeometryReader { proxy in
        if
          isShowDetail,
          let selectedPicID,
          let source = value[selectedPicID.uuidString],
          let detail = value["\(selectedPicID.uuidString)-detail"],
          let picItem = selectedImage()
        {
          let sourceRect = proxy[source]
          let detailRect = proxy[detail]

          Image(picItem.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
              width: {
                isShowDetailAnimation
                ? detailRect.width : sourceRect.width
              }(),
              height: {
                isShowDetailAnimation
                ? detailRect.height : sourceRect.height
              }())
            .clipShape(.rect(
              cornerRadius: isShowDetailAnimation ? .zero : 10))
            .offset(
              x:{
                isShowDetailAnimation
                ? detailRect.minX
                : sourceRect.minX
              }(),
              y:{
                isShowDetailAnimation
                ? detailRect.minY
                : sourceRect.minY
              }())
            .allowsHitTesting(false)
        }
      }
    }
  }

  func selectedImage() -> PicItem? {
    selectedPost?.picList.first(where: { $0.id == selectedPicID })
  }
}
