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
    
    // getting add data from container
    func getAllData(){
        let request=NSFetchRequest<PasswordContainer>(entityName: "PasswordContainer")
        do{
           passwordManager=try container.viewContext.fetch(request)
        } catch let error{
            print("Error fetching data",error)
        }
    }
    
    
    //function to add data from view
    func addData(){
        let encryptedPassword=PasswordEncryption.shared.encrypt(password: password)
        print(accountName,email,encryptedPassword,"detail")
        let manager=PasswordContainer(context: container.viewContext)
        manager.account=accountName
        manager.email=email
        manager.password=encryptedPassword
        saveData()
    }
    
    
    // updating exiting data
    func updateData(entitly:PasswordContainer){
        entitly.account=accountName
        entitly.email=email
        entitly.password=password
        saveData()
    }
    
    // saving the user entered data
    func saveData(){
        do{
          try container.viewContext.save()
            clearData()
            getAllData()
        } catch let error{
            print("erro saving data", error)
        }
    }
    
    // clear textfied after saving to in Core Data
    func clearData(){
        accountName=""
        email=""
        password=""
    }
    
    // deleting a specific password, username
    func deleteData(item:PasswordContainer){
        container.viewContext.delete(item)
        saveData()
    }
    
    
    // function to toggle show password
    func showPassword(pass:String){
        print(pass, "encrypted password")
        if isVisible{
                let result=PasswordEncryption.shared.decrypt(pass: pass)
                print(result, "decryted string")
                self.password=result
        }
    
     
    }
    
    // here we are getting the existing data from container during updation phase
    func getDataFromDB(data:PasswordContainer){
        print(data.account ?? "","accound name")
        accountName=data.account ?? ""
        email=data.email ?? ""
        password=""
    }
}
