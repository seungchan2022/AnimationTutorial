import SwiftUI

struct Geometry1DetailPage {
  @Binding var isShowDetail: Bool
  @Binding var isShowDetailAnimation: Bool
  var item: Post
  @Binding var selectedPickID: UUID?
  let updateScrollAction: (UUID?) -> Void

  @State private var detailScrollPosition: UUID?
  @State private var startTask1: DispatchWorkItem?
  @State private var startTask2: DispatchWorkItem?
}

extension Geometry1DetailPage {
  func initiateTask(
    ref: inout DispatchWorkItem?,
    task: DispatchWorkItem,
    duration: CGFloat)
  {
    ref = task
    DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
  }

  func cancelTasks() {
    if let startTask1, let startTask2 {
      startTask1.cancel()
      startTask2.cancel()
      self.startTask1 = .none
      self.startTask2 = .none
    }
  }
}

extension Geometry1DetailPage: View {
  var body: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: .zero) {
        ForEach(item.picList) { pic in
          Image(pic.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .containerRelativeFrame(.horizontal)
            .clipped()
            .anchorPreference(
              key: OffsetKey.self,
              value: .bounds,
              transform: { ["\(pic.id.uuidString)-detail": $0] })
            .opacity(selectedPickID == pic.id ? 0 : 1)
        }
      }
      .scrollTargetLayout()
    }
    .scrollPosition(id: $detailScrollPosition)
    .background(.black)
    .opacity(isShowDetailAnimation ? 1: .zero)
    .scrollTargetBehavior(.paging)
    .scrollIndicators(.hidden)
    .overlay(alignment: .topLeading) {
      Button(action: {
        cancelTasks()

        updateScrollAction(detailScrollPosition)
        selectedPickID = detailScrollPosition
        initiateTask(
          ref: &startTask1,
          task: .init(block: {
            withAnimation(.snappy(duration: 0.3, extraBounce: .zero)) {
              isShowDetailAnimation = false
            }

            initiateTask(
              ref: &startTask2,
              task: .init(block: {
                isShowDetail = false
                selectedPickID = .none
              }),
              duration: 0.3)
          }),
          duration: 0.05)
      }) {
        Image(systemName: "xmark.circle.fill")
      }
      .font(.title)
      .foregroundStyle(.white.opacity(0.8), .white.opacity(0.15))
      .padding()
    }
    .onAppear {
      cancelTasks()
      guard detailScrollPosition == .none else { return }
      detailScrollPosition = selectedPickID
      initiateTask(
        ref: &startTask1,
        task: .init(block: {
          withAnimation(.snappy(duration: 0.3, extraBounce: .zero)) {
            isShowDetailAnimation = true
          }

          initiateTask(
            ref: &startTask2,
            task: .init(block: {
              selectedPickID = .none
            }),
            duration: 0.3)
        }),
        duration: 0.05)
    }
  }
}
