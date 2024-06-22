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
    let key=SymmetricKey(size: .bits256)
    
    // encryting a password
    func encrypt(password:String)->String{
        let (password, key)=getData(password: password)
        //        var resultData:String=""
        do{
            let result=try encruptData(data: password, key: key)
            return result
            //            return result
        } catch let error{
            print(error)
        }
        return ""
    }
    
    func getData(password:String)->(Data, SymmetricKey){
        let input=Data(password.utf8)
        return (input, key)
    }
    
    func encruptData(data:Data, key: SymmetricKey)throws->String{
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined?.base64EncodedString() ?? ""
    }
    
    
    // decrypting password during eye toggle
    func decrypt(pass:String)->String{
        guard let data=Data(base64Encoded:pass) else {return ""}
        do{
            let sealedBox=try AES.GCM.SealedBox(combined: data)
            let ss=try AES.GCM.open(sealedBox, using: key)
            if let str=String(data: ss, encoding: .utf8){
                return str
            } else {
                print("caanot convert to string decoeding")
            }
        } catch let error{
            return "Request Not Fulfilled"
        }
        return ""
        
    }
    
}
