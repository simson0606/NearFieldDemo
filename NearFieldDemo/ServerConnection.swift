//
//  ServerConnection.swift
//  NearFieldDemo
//
//  Created by simon heij on 06/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation

class ServerConnection {
    
    func createCode(for name: String, completion: @escaping (_ result: String)->()){
        let address = "http://\(Constants.ServerIP):\(Constants.ServerPort)/api/users"
        let url = URL(string: address)!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "name": name
        ]
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request)  {
            (data, response, error) in
            guard let data = data,
                let _ = response as? HTTPURLResponse,
                error == nil else { // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
            }
            
         //   let html = String(data: data, encoding: .utf8)!
            
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            let res = try! decoder.decode(CodeResponse.self, from: data)
            
            completion(res.data!.code)
        }
        task.resume()
    }
    
    func validateCode(for code: String, completion: @escaping (_ result: Bool)->()){
        let url = URL(string: "http://\(Constants.ServerIP):\(Constants.ServerPort)/api/users/\(code)")!
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data else { return }
            
            let html = String(data: data, encoding: .utf8)!
            print(html)
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            let res = try! decoder.decode(CodeResponse.self, from: data)
            
            completion(res.data != nil)
        }
        task.resume()
    }
    
}
