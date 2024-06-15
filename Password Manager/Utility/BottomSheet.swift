//
//  BottomSheet.swift
//  Password Manager
//
//  Created by Mohd Kashif on 15/06/24.
//

import Foundation
import SwiftUI

struct BottomSheet<Content: View>: View {
    var content: () -> Content
    
    @Environment(\.dismiss) private var dismiss
    
    private let maxHeight: CGFloat = UIScreen.main.bounds.height - 154
    private let topSpace: CGFloat = 120

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack {
            VStack {
                Spacer(minLength: topSpace)
                getContentView()
                    //.frame(maxHeight: maxHeight)
//                    .padding(.top, 2)
                    .padding(.bottom, 16)
                    .background(Color.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
            }
            .background(Color.black.opacity(0.3))
        }
        .gesture(
                    DragGesture().onEnded { value in
                        if value.location.y - value.startLocation.y > 150 {
                            dismiss()
//                            onDismiss()
                        }
                    }
                )
        .background(BackgroundClearView())
        .ignoresSafeArea([.container], edges: [.bottom, .top])
    }
    
    private func getContentView() -> some View {
        VStack (alignment:.leading){
            getCloseButtonRow()
                content()
     
        }
        .padding([.leading,.trailing],20)
    }
    
    private func getCloseButtonRow() -> some View {
        ZStack {
            HStack {
                Spacer()
                Capsule()
                    .onTapGesture {
                        dismiss()
                    }
                    .frame(width: 28, height: 5)
                    .foregroundColor(Color.color("#E3E3E3"))
                Spacer()
            }
            .padding(.top)
        }
    }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
extension View {
    func passwordBottomSheet<T: View>(isPresented: Binding<Bool>,email:String?=nil, accountName:String?=nil, password:String?=nil, @ViewBuilder _ content: @escaping () -> T) -> some View {
        fullScreenCover(isPresented: isPresented) {
            BottomSheet(content: content)
        }
    }
}

extension View{
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
