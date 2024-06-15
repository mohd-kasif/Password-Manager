//
//  PasswordEncryption.swift
//  Password Manager
//
//  Created by Mohd Kashif on 15/06/24.
//

import Foundation
import CryptoKit

// Passwrod encrytion and decryption class
/// we are using CryptoKit class for Apple
class PasswordEncryption{
    static let shared=PasswordEncryption()
    private init(){}
    
    
    // encryting a password
    func encrypt(password:String)->String{
        let (password, key)=getData(password: password)
        //        var resultData:String=""
        do{
            let result=try encruptData(data: password, key: key)
            print(result,"encryped string")
            return result
            //            return result
        } catch let error{
            print("error in encryptin",error)
        }
        return ""
    }
    
    func getData(password:String)->(Data, SymmetricKey){
        let input=Data(password.utf8)
        let key=SymmetricKey(size: .bits256)
        return (input, key)
    }
    
    func encruptData(data:Data, key: SymmetricKey)throws->String{
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined?.base64EncodedString() ?? ""
    }
    
    
    // decrypting password during eye toggle
    /// currently facing some issue during decrytion
    func decrypt(pass:String)->String{
        print(pass, "encryted string in decrypt function")
        let key=SymmetricKey(size: .bits256)
        guard let data=Data(base64Encoded:pass) else {print("errro converting to data");return ""}
        print(data, "data in bytes")
        do{
            let sealedBox=try AES.GCM.SealedBox(combined: data)
            let ss=try AES.GCM.open(sealedBox, using: key)
            if let str=String(data: ss, encoding: .utf8){
                return str
            } else {
                print("caanot convert to string decoeding")
            }
        } catch let error{
            print(error, "")
            return "Request Not Fulfilled"
        }
        return ""
        
    }
    
}
