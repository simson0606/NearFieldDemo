//
//  FriendRequestValidator.swift
//  NearFieldDemo
//
//  Created by simon heij on 11-02-19.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
class FriendRequestValidator {
    
    
    
    func validate(friendRequest: FriendRequestData) -> Bool{
        
        let elapsed = Date().timeIntervalSince(friendRequest.dateTime)
        return Int(elapsed) < Constants.QrValidSeconds
    }
}
