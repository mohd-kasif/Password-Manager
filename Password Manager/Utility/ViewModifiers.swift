//
//  ViewModifiers.swift
//  Password Manager
//
//  Created by Mohd Kashif on 15/06/24.
//

import Foundation
import SwiftUI
struct SingleTextField:ViewModifier{
    func body(content: Content) -> some View {
        content
            .frame(maxWidth:.infinity)
            .frame(height:52)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1).foregroundColor(Color.color("#CBCBCB")))
    }
}

extension View{
    func textFieldStyle()->some View{
        modifier(SingleTextField())
    }
}
