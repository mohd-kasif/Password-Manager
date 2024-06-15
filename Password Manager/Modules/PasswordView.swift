//
//  PasswordView.swift
//  Password Manager
//
//  Created by Mohd Kashif on 15/06/24.
//

import SwiftUI
//f4f5fa
struct PasswordView: View {
    @State var addItem=false
    @State var showDetail=false
    @State var showEmail:String=""
    @State var showPassword:String=""
    @State var showAccoutn:String=""
    @State var selectedItem:PasswordContainer?
    @State var isVisible:Bool=false
    @State var isEdit:Bool=false
    @ObservedObject var vm=PasswordViewModel()
    var body: some View {
        ZStack{
            Color.color("#F4F5FA").ignoresSafeArea()
            VStack(alignment:.leading){
                Text("Password Manager")
                    .foregroundColor(Color.color("#333333"))
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                Divider()
                    .padding(.bottom)
                ScrollView(){
                    ForEach(vm.passwordManager){item in
                        SinglePasswordView(title: item.account ?? "")
                            .padding(.top)
                            .onTapGesture {
                                DispatchQueue.main.async {
                                    self.selectedItem=item
                                    self.showEmail=item.email ?? ""
                                    self.showPassword=item.password ?? ""
                                    self.showAccoutn=item.account ?? ""
                                }
                            
                                self.showDetail.toggle()
                            }
                    }
                    
                }
                HStack{
                    Spacer()
                    Image("addIcon")
                        .onTapGesture {
                            self.addItem.toggle()
                        }
                }
                .passwordBottomSheet(isPresented: $addItem){
                    AddPasswordSheet(title: "Account Name", text: $vm.accountName)
                    AddPasswordSheet(title: "Username/Email", text: $vm.email)
                        .padding(.top)
                    AddPasswordSheet(title: "Password", text: $vm.password)
                        .padding(.top)
                    MyButton(title: "Add New Account"){
                        vm.addData()
                        addItem=false
                    }
                  
                }
                .passwordBottomSheet(isPresented: $isEdit){
                    AddPasswordSheet(title: "Account Name", text: $vm.accountName)
                    AddPasswordSheet(title: "Username/Email", text: $vm.email)
                        .padding(.top)
                    AddPasswordSheet(title: "Password", text: $vm.password)
                        .padding(.top)
                    MyButton(title: "Update"){
                        self.isEdit.toggle()
                        if let item=selectedItem{
                            vm.updateData(entitly: item)
                        }
                       
                    }
                  
                }
                .passwordBottomSheet(isPresented: $showDetail){
                    VStack(alignment: .leading){
                        VStack{
                            Text("Account Details")
                                .foregroundColor(Color.color("#3F7DE3"))
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                        }
                       
                        VStack(alignment:.leading){
                            Text("Account Type")
                                .foregroundColor(Color.color("#CCCCCC"))
                                .font(.system(size: 11))
                            Text(showAccoutn)
                                .foregroundColor(Color.color("#333333"))
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                        }
                        .padding(.top)
                        VStack(alignment:.leading){
                            Text("Username/Email")
                                .foregroundColor(Color.color("#CCCCCC"))
                                .font(.system(size: 11))
                            Text(showEmail)
                                .foregroundColor(Color.color("#333333"))
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                        }
                        .padding(.top)
                        VStack(alignment:.leading){
                            HStack{
                                Text("Password")
                                    .foregroundColor(Color.color("#CCCCCC"))
                                    .font(.system(size: 11))
                                Spacer()
                                Image(systemName: !vm.isVisible ? "eye.slash" : "eye.fill")
                                    .offset(y:10)
                                    .onTapGesture {
                                        self.vm.isVisible.toggle()
                                        vm.showPassword(pass: self.showPassword)
                                    }
                                
                            }
                            Text(vm.isVisible ? vm.password : "*******")
                                .foregroundColor(Color.color("#333333"))
                                .font(.system(size: 10))
                                .fontWeight(.bold)
                        }
                        .padding(.top)
                    }
                    HStack{
                        MyButton(title: !isEdit ? "Edit" : "Save"){
                            self.showDetail.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.isEdit.toggle()
                                if let item=selectedItem{
                                    vm.getDataFromDB(data: item)
                                }
                                
                            }
                            
                        }
                        MyButton(title: "Delete",color: "#F04646"){
                            if let item=selectedItem{
                                vm.deleteData(item: item)
                                self.showDetail.toggle()
                            }
                        
                        }
                    }
                    .padding(.bottom)
                }
             
            } .padding([.leading,.trailing],20)
         
    
        }

    }
}

//#Preview {
//    PasswordView(index:0)
//}

struct AddPasswordSheet:View{
    var title:String
    @Binding var text:String
    
    var body: some View{
        HStack{
            TextField(title, text: $text)
//                .onChange(of: text){val in
//                    text=val.uppercased()
//                    
//                    if text.count>2{
//                        print(text,"search character")
//                        vm.searchInfo(text: text)
//                    }
//                }
                .padding()
        }
        .textFieldStyle()
    }
}

struct MyButton:View {
    var title:String
    var color:String
    var onTap:(()->Void)?
    init(title: String, color: String="#2C2C2C", onTap: ( () -> Void)? = nil) {
        self.title = title
        self.color = color
        self.onTap = onTap
    }
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            Text(title)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth:.infinity)
        .background(Color.color(color))
        .clipShape(Rectangle())
        .cornerRadius(50)
        .padding(.top)
        .shadow(radius: 2.5, x: 0, y: 1)
    }
}


struct DetailSheet:View {
    var body: some View {
        VStack(alignment: .leading){
            VStack{
                Text("Account Details")
                    .foregroundColor(Color.color("#3F7DE3"))
                    .fontWeight(.bold)
                    .font(.system(size: 20))
            }
           
            VStack(alignment:.leading){
                Text("Account Type")
                    .foregroundColor(Color.color("#CCCCCC"))
                    .font(.system(size: 11))
                Text("")
                    .foregroundColor(Color.color("#333333"))
                    .font(.system(size: 20))
                    .fontWeight(.bold)
            }
            .padding(.top)
            VStack(alignment:.leading){
                Text("Username/Email")
                    .foregroundColor(Color.color("#CCCCCC"))
                    .font(.system(size: 11))
                Text("")
                    .foregroundColor(Color.color("#333333"))
                    .font(.system(size: 20))
                    .fontWeight(.bold)
            }
            .padding(.top)
            VStack(alignment:.leading){
                Text("Password")
                    .foregroundColor(Color.color("#CCCCCC"))
                    .font(.system(size: 11))
                Text("")
                    .foregroundColor(Color.color("#333333"))
                    .font(.system(size: 20))
                    .fontWeight(.bold)
            }
            .padding(.top)
        }
        HStack{
            MyButton(title: "Edit")
            MyButton(title: "Delete",color: "#F04646")
        }
        .padding(.bottom)
    }
}
