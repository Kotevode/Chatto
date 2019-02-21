//
//  DemoFileMessageModel.swift
//  ChattoApp
//
//  Created by Mark on 19/02/2019.
//  Copyright © 2019 Badoo. All rights reserved.
//

import Foundation
import ChattoAdditions

class DemoFileMessageModel: DecoratedMessageModelProtocol, DemoMessageModelProtocol {
    var messageModel: MessageModelProtocol
    public var status: MessageStatus = .sending
    public let url: URL
    public let name: String
    
    init(messageModel: MessageModelProtocol, url: URL, name: String) {
        self.messageModel = messageModel
        self.url = url
        self.name = name
    }
}
