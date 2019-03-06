//
//  CodeCreatedResponse.swift
//  NearFieldDemo
//
//  Created by simon heij on 06/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
struct CodeResponse  : Codable{
    var message: String
    var data: CodeData?
}

struct CodeData : Codable {
    var _id: String
    var create_date: Date
    var name: String
    var code: String
}


