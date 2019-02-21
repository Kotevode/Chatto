/*
 The MIT License (MIT)

 Copyright (c) 2015-present Badoo Trading Limited.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import UIKit
import Chatto
import ChattoAdditions

class DemoChatViewController: BaseChatViewController {
    var shouldUseAlternativePresenter: Bool = false

    var messageSender: DemoChatMessageSender!
    let messagesSelector = BaseMessagesSelector()

    var dataSource: DemoChatDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
            self.messageSender = self.dataSource.messageSender
        }
    }

    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Chat"
        self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1)
        self.messagesSelector.delegate = self
        self.chatItemsDecorator = DemoChatItemsDecorator(messagesSelector: self.messagesSelector)
    }

    var chatInputPresenter: AnyObject!
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Type a message", comment: "")
        if self.shouldUseAlternativePresenter {
            let chatInputPresenter = ExpandableChatInputBarPresenter(
                inputPositionController: self,
                chatInputBar: chatInputView,
                chatInputItems: self.createChatInputItems(),
                chatInputBarAppearance: appearance)
            self.chatInputPresenter = chatInputPresenter
            self.keyboardEventsHandler = chatInputPresenter
            self.scrollViewEventsHandler = chatInputPresenter
        } else {
            self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        }
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }

    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        let baseMessageStyle = BaseMessageCollectionViewCellDefaultStyle(
            colors: BaseMessageCollectionViewCellDefaultStyle.Colors(
                incoming: .white,
                outgoing: UIColor(red: 0, green: 0.68, blue: 0.79, alpha: 1)
            ),
            bubbleBorderImages: nil,
            avatarStyle: BaseMessageCollectionViewCellDefaultStyle.AvatarStyle(size: .zero, alignment: .top)
        )
        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: GenericMessageHandler(baseHandler: self.baseMessageHandler)
        )
        let bubbleImages = TextMessageCollectionViewCellDefaultStyle.BubbleImages(
            incomingTail: UIImage(named: "IncomingTail")!,
            incomingNoTail: UIImage(named: "IncomingNoTail")!,
            outgoingTail: UIImage(named: "OutgoingTail")!,
            outgoingNoTail: UIImage(named: "OutgoingNoTail")!
        )
        textMessagePresenter.baseMessageStyle = baseMessageStyle
        textMessagePresenter.textCellStyle = TextMessageCollectionViewCellDefaultStyle(
            bubbleImages: bubbleImages,
            baseStyle: baseMessageStyle
        )
        
        let photoMessagePresenter = PhotoMessagePresenterBuilder(
            viewModelBuilder: DemoPhotoMessageViewModelBuilder(),
            interactionHandler: GenericMessageHandler(baseHandler: self.baseMessageHandler)
        )
        photoMessagePresenter.baseCellStyle = baseMessageStyle
        photoMessagePresenter.photoCellStyle = PhotoMessageCollectionViewCellDefaultStyle(
            bubbleMasks: PhotoMessageCollectionViewCellDefaultStyle.BubbleMasks(
                incomingTail: UIImage(named: "IncomingTail")!,
                incomingNoTail: UIImage(named: "IncomingNoTail")!,
                outgoingTail: UIImage(named: "OutgoingTail")!,
                outgoingNoTail: UIImage(named: "OutgoingNoTail")!,
                tailWidth: 6
            ),
            baseStyle: baseMessageStyle
        )
        
        let fileMessagePresenterBuilder = DemoFileMessagePresenterBuilder(
            viewModelBuilder: DemoFileMessageViewModelBuilder(),
            interactionHandler: DemoFileMessageHandler(baseHandler: self.baseMessageHandler)
        )
        fileMessagePresenterBuilder.style = baseMessageStyle
        
        return [
            DemoTextMessageModel.chatItemType: [textMessagePresenter],
            DemoPhotoMessageModel.chatItemType: [photoMessagePresenter],
            DemoFileMessageModel.chatItemType: [fileMessagePresenterBuilder],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()]
        ]
    }

    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        items.append(self.createPhotoInputItem())
        if self.shouldUseAlternativePresenter {
            items.append(self.customInputItem())
        }
        return items
    }

    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }

    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
            self?.dataSource.addPhotoMessage(image)
        }
        return item
    }

    private func customInputItem() -> ContentAwareInputItem {
        let item = ContentAwareInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }
}

extension DemoChatViewController: MessagesSelectorDelegate {
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didSelectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }

    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
}
