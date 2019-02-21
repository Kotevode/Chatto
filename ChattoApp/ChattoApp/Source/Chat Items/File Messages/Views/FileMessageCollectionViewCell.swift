//
//  FileMEssageCollectionViewCell.swift
//  ChattoApp
//
//  Created by Mark on 20/02/2019.
//  Copyright © 2019 Badoo. All rights reserved.
//

import UIKit
import ChattoAdditions

class FileMessageCollectionViewCell: BaseMessageCollectionViewCell<FileBubbleView> {
    static func sizingCell() -> FileMessageCollectionViewCell {
        let cell = FileMessageCollectionViewCell(frame: .zero)
        cell.viewContext = .sizing
        return cell
    }
    
    var viewModel: DemoFileMessageViewModel! {
        didSet {
            messageViewModel = viewModel
            bubbleView.viewModel = viewModel
        }
    }
    
    var style: BaseMessageCollectionViewCellDefaultStyle! {
        didSet {
            bubbleView.style = style
        }
    }
    
    override func createBubbleView() -> FileBubbleView! {
        return Bundle.main.loadNibNamed("FileBubbleView",
                                        owner: nil,
                                        options: nil)?.first as? FileBubbleView
    }
}
