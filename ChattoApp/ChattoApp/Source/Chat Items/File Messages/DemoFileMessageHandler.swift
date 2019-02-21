//
//  DemoFileMessageHandler.swift
//  ChattoApp
//
//  Created by Mark on 19/02/2019.
//  Copyright © 2019 Badoo. All rights reserved.
//

import Foundation
import ChattoAdditions

class DemoFileMessageHandler: BaseMessageInteractionHandlerProtocol {
    private let baseHandler: BaseMessageHandler
    init(baseHandler: BaseMessageHandler) {
        self.baseHandler = baseHandler
    }
    
    func userDidTapOnFailIcon(viewModel: DemoFileMessageViewModel, failIconView: UIView) {
        self.baseHandler.userDidTapOnFailIcon(viewModel: viewModel)
    }
    
    func userDidTapOnAvatar(viewModel: DemoFileMessageViewModel) {
        self.baseHandler.userDidTapOnAvatar(viewModel: viewModel)
    }
    
    func userDidTapOnBubble(viewModel: DemoFileMessageViewModel) {
        self.baseHandler.userDidTapOnBubble(viewModel: viewModel)
    }
    
    func userDidBeginLongPressOnBubble(viewModel: DemoFileMessageViewModel) {
        self.baseHandler.userDidBeginLongPressOnBubble(viewModel: viewModel)
    }
    
    func userDidEndLongPressOnBubble(viewModel: DemoFileMessageViewModel) {
        self.baseHandler.userDidEndLongPressOnBubble(viewModel: viewModel)
    }
    
    func userDidSelectMessage(viewModel: DemoFileMessageViewModel) {
        self.baseHandler.userDidSelectMessage(viewModel: viewModel)
    }
    
    func userDidDeselectMessage(viewModel: DemoFileMessageViewModel) {
        self.baseHandler.userDidDeselectMessage(viewModel: viewModel)
    }
}
