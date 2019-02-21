//
//  FileBubbleView.swift
//  ChattoApp
//
//  Created by Mark on 19/02/2019.
//  Copyright © 2019 Badoo. All rights reserved.
//

import UIKit
import ChattoAdditions

class FileBubbleView: UIView, BackgroundSizingQueryable, MaximumLayoutWidthSpecificable {
    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentViewLeadingConstraing: NSLayoutConstraint!
    @IBOutlet weak var contentViewTrailingConstraint: NSLayoutConstraint!
    
    var padding: CGFloat = 7
    var tailLength: CGFloat = 9
    var preferredMaxLayoutWidth: CGFloat = 0
    var canCalculateSizeInBackground: Bool { return false }
    
    var leadingPadding: CGFloat {
        return viewModel.isIncoming ? tailLength + padding : padding
    }
    
    var trailingPadding: CGFloat {
        return viewModel.isIncoming ? padding : tailLength + padding
    }
    
    public var style: BaseMessageCollectionViewCellDefaultStyle! {
        didSet {
            updateStyles()
        }
    }
    
    public var viewModel: DemoFileMessageViewModel! {
        didSet {
            updateContent()
        }
    }
    
    private func updateView() {
        updateStyles()
        updateContent()
    }
    
    private func updateStyles() {
        bubbleImageView.image = UIImage(named: viewModel.isIncoming ? "IncomingTail" : "OutgoingTail")!
            .withRenderingMode(.alwaysTemplate)
        bubbleImageView.tintColor = viewModel.isIncoming ? style.baseColorIncoming : style.baseColorOutgoing
        nameLabel.textColor = viewModel.isIncoming ? .darkText : .white
    }
    
    private func updateContent() {
        nameLabel.text = viewModel.name
        contentViewLeadingConstraing.constant = leadingPadding
        contentViewTrailingConstraint.constant = trailingPadding
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let buttonWidth = openButton.frame.size.width
        let maxLabelWidth = size.width
            - 2 * padding
            - tailLength
            - buttonWidth
        let labelSize = nameLabel.sizeThatFits(CGSize(width: maxLabelWidth, height: buttonWidth))
        return CGSize(width: labelSize.width + 2 * padding + tailLength + buttonWidth , height: buttonWidth + 2 * padding)
    }
}
