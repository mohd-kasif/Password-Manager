//
//  PasswordViewModel.swift
//  Password Manager
//
//  Created by Mohd Kashif on 15/06/24.
//

import Foundation
import CoreData


class PasswordViewModel:ObservableObject{
    let container:NSPersistentContainer
    @Published var passwordManager:[PasswordContainer]=[]
    @Published var accountName:String=""
    @Published var email:String=""
    @Published var password:String=""
    @Published var isVisible:Bool=false
    init(){
        container=NSPersistentContainer(name: "PasswordContainer")
        container.loadPersistentStores { data, error  in
            if let error=error{
                print("error loading data", error)
            } else {
                print("successfullt load data")
            }
        }
        getAllData()
    }
    
    func getAllData(){
        let request=NSFetchRequest<PasswordContainer>(entityName: "PasswordContainer")
        do{
           passwordManager=try container.viewContext.fetch(request)
        } catch let error{
            print("Error fetching data",error)
        }
    }
    
    func addData(){
        let encryptedPassword=PasswordEncryption.shared.encrypt(password: password)
        print(accountName,email,encryptedPassword,"detail")
        let manager=PasswordContainer(context: container.viewContext)
        manager.account=accountName
        manager.email=email
        manager.password=encryptedPassword
        saveData()
    }
    func updateData(entitly:PasswordContainer){
        entitly.account=accountName
        entitly.email=email
        entitly.password=password
        saveData()
    }
    
    func saveData(){
        do{
          try container.viewContext.save()
            clearData()
            getAllData()
        } catch let error{
            print("erro saving data", error)
        }
    }
    func clearData(){
        accountName=""
        email=""
        password=""
    }
    
    func deleteData(item:PasswordContainer){
        container.viewContext.delete(item)
        saveData()
    }
    
    func showPassword(pass:String){
        print(pass, "encrypted password")
        if isVisible{
                let result=PasswordEncryption.shared.decrypt(pass: pass)
                print(result, "decryted string")
                self.password=result
          
//                print("error in decryption", error)
//            }
        }
    
     
    }
    
    func getDataFromDB(data:PasswordContainer){
        print(data.account ?? "","accound name")
        accountName=data.account ?? ""
        email=data.email ?? ""
        password=""
//        saveData()
    }
}
