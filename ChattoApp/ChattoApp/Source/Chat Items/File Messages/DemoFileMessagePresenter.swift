//
//  DemoFileMessagePresenter.swift
//  ChattoApp
//
//  Created by Mark on 19/02/2019.
//  Copyright © 2019 Badoo. All rights reserved.
//

import Foundation
import ChattoAdditions
import Chatto

class DemoFileMessagePresenterBuilder: ChatItemPresenterBuilderProtocol {
    let viewModelBuilder: DemoFileMessageViewModelBuilder
    let interactionHandler: DemoFileMessageHandler
    
    lazy var style = BaseMessageCollectionViewCellDefaultStyle()
    
    init(viewModelBuilder: DemoFileMessageViewModelBuilder,
         interactionHandler: DemoFileMessageHandler) {
        self.viewModelBuilder = viewModelBuilder
        self.interactionHandler = interactionHandler
    }
    
    func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem is DemoFileMessageModel
    }
    
    func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        assert(self.canHandleChatItem(chatItem))
        return DemoFileMessagePresenter(messageModel: chatItem as! DemoFileMessageModel,
                                        viewModelBuilder: viewModelBuilder,
                                        interactionHandler: interactionHandler,
                                        sizingCell: FileMessageCollectionViewCell.sizingCell(),
                                        cellStyle: style)
    }
    
    var presenterType: ChatItemPresenterProtocol.Type {
        return DemoFileMessagePresenter.self
    }
}

class DemoFileMessagePresenter
: BaseMessagePresenter<FileBubbleView, DemoFileMessageViewModelBuilder, DemoFileMessageHandler> {
    let style: BaseMessageCollectionViewCellDefaultStyle
    
    init(messageModel: DemoFileMessageModel,
         viewModelBuilder: DemoFileMessageViewModelBuilder,
         interactionHandler: DemoFileMessageHandler?,
         sizingCell: BaseMessageCollectionViewCell<FileBubbleView>,
         cellStyle: BaseMessageCollectionViewCellDefaultStyle) {
        self.style = cellStyle
        super.init(messageModel: messageModel,
                   viewModelBuilder: viewModelBuilder,
                   interactionHandler: interactionHandler,
                   sizingCell: sizingCell,
                   cellStyle: cellStyle)
    }
    
    override class func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(FileMessageCollectionViewCell.self, forCellWithReuseIdentifier: "file-message-incoming")
        collectionView.register(FileMessageCollectionViewCell.self, forCellWithReuseIdentifier: "file-message-outcoming")
    }
    
    override func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(
            withReuseIdentifier: "file-message-\(messageViewModel.isIncoming ? "incoming" : "outcoming")",
            for: indexPath
        )
    }
    
    override func configureCell(_ cell: BaseMessageCollectionViewCell<FileBubbleView>, decorationAttributes: ChatItemDecorationAttributes, animated: Bool, additionalConfiguration: (() -> Void)?) {
        guard let cell = cell as? FileMessageCollectionViewCell else {
            assert(false, "Invalid cell received")
            return
        }
        
        super.configureCell(cell, decorationAttributes: decorationAttributes, animated: animated) { () -> Void in
            cell.viewModel = self.messageViewModel
            cell.style = self.style
            additionalConfiguration?()
        }
    }
}
