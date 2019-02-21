//
//  DemoFileMessageViewModel.swift
//  ChattoApp
//
//  Created by Mark on 19/02/2019.
//  Copyright © 2019 Badoo. All rights reserved.
//

import Foundation
import ChattoAdditions

class DemoFileMessageViewModel: DecoratedMessageViewModelProtocol, DemoMessageViewModelProtocol {
    let fileMessageModel: DemoFileMessageModel
    let messageViewModel: MessageViewModelProtocol
    var messageModel: DemoMessageModelProtocol {
        return fileMessageModel
    }
    
    var name: String { return fileMessageModel.name }
    
    init(_ model: DemoFileMessageModel, messageViewModel: MessageViewModelProtocol) {
        self.fileMessageModel = model
        self.messageViewModel = messageViewModel
    }
}


class DemoFileMessageViewModelBuilder: ViewModelBuilderProtocol {
    let messageViewModelBuilder = MessageViewModelDefaultBuilder()
    
    func canCreateViewModel(fromModel model: Any) -> Bool {
        return model is DemoFileMessageViewModel
    }
    
    func createViewModel(_ model: DemoFileMessageModel) -> DemoFileMessageViewModel {
        return DemoFileMessageViewModel(
            model,
            messageViewModel: messageViewModelBuilder.createMessageViewModel(model)
        )
    }
}
