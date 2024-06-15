//
//  SinglePasswordView.swift
//  Password Manager
//
//  Created by Mohd Kashif on 15/06/24.
//

import SwiftUI

struct SinglePasswordView: View {
    var title:String
    var body: some View {
        HStack{
            Text(title)
                .padding()
                .foregroundColor(Color.color("#333333"))
                .font(.system(size: 20))
            Text("*******")
                .foregroundColor(Color.color("#C6C6C6"))
                .font(.system(size: 20))
                .offset(y:4)
            Spacer()
            Image(systemName: "chevron.right")
                .padding(.trailing)
        }
        .frame(width:345, height:69)
        .clipShape(Rectangle())
        .background(.white)
        .cornerRadius(50)
    }
}

//#Preview {
//    SinglePasswordView()
//}
