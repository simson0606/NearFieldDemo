//
//  StringCryptor.swift
//  NearFieldDemo
//
//  Created by simon heij on 11-02-19.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
import CryptoSwift

class StringCryptor {
    
    private let key = "avanadeavanadeav"
    private let iv = "bmtybtsbmtybtsbm"
    
    func encrypt(string: String) -> String{
        let encrypted = try! AES(key: key, iv: iv, padding: .pkcs7).encrypt([UInt8](string.data(using: .utf8)!))
        return Data(encrypted).base64EncodedString()
    }
    
    func decrypt(string: String) -> String{
        guard let data = Data(base64Encoded: string) else { return "" }
        let decrypted = try! AES(key: key, iv: iv, padding: .pkcs7).decrypt([UInt8](data))
        return String(bytes: Data(decrypted).bytes, encoding: .utf8) ?? "Could not decrypt"
    }
    
}
