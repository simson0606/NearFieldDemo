//
//  QrResultReicever.swift
//  NearFieldDemo
//
//  Created by simon heij on 11-02-19.
//  Copyright © 2019 simon heij. All rights reserved.
//

import Foundation
protocol FriendRequestReceiver {
    func setReceivedFriendRequest(friendRequest: FriendRequestData)
}
