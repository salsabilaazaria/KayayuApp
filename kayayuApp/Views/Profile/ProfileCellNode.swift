//
//  ProfileCellNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 02/12/21.
//

import Foundation
import AsyncDisplayKit

class ProfileCellNode: ASDisplayNode {
	let buttonNode: ASButtonNode = ASButtonNode()
	
	private let icon: ASImageNode = ASImageNode()
	private let title: ASTextNode = ASTextNode()
	let arrow: ASImageNode = ASImageNode()
	
	private let iconImageName: String
	private let titleString: String
	
	private let cornerRadiusFloat: CGFloat = 8
	
	init(icon: String = "", title: String = "") {
		self.iconImageName = icon
		self.titleString = title
		
		super.init()
	
		configureIcon()
		configureTitle()
		configureArrow()
		configureButton()
		cornerRadius = cornerRadiusFloat
		backgroundColor = .clear
		
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let backgroundNode = ASDisplayNode()
		backgroundNode.backgroundColor = .white
		backgroundNode.cornerRadius = cornerRadiusFloat

		var itemSpec = ASLayoutSpec()
		if iconImageName != "" {
			itemSpec = ASStackLayoutSpec(direction: .horizontal,
										 spacing: 8,
										 justifyContent: .center,
										 alignItems: .center,
										 children: [icon, title, arrow])
		} else {
			itemSpec = ASStackLayoutSpec(direction: .horizontal,
										 spacing: 8,
										 justifyContent: .center,
										 alignItems: .center,
										 children: [title, arrow])
		}
		
		itemSpec.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
		title.style.flexGrow = 1
		
		let itemInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16), child: itemSpec)
		
		let butttonOverlay = ASOverlayLayoutSpec(child: itemInset, overlay: buttonNode)
		let backgroundSpec = ASBackgroundLayoutSpec(child: butttonOverlay, background: backgroundNode)
		
		let mainInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), child: backgroundSpec)
		
		return mainInset
	}

	private func configureIcon() {
		icon.image = UIImage(named: iconImageName)
		icon.style.preferredSize = CGSize(width: 30, height: 30)
	}
	
	private func configureTitle() {
		title.attributedText = NSAttributedString.normal(titleString, 14, .black)
	}
	
	private func configureArrow() {
		arrow.image = UIImage(named: "arrow.png")
		arrow.style.preferredSize = CGSize(width: 10, height: 20)
	}
	
	private func configureButton() {
		buttonNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 40)
		buttonNode.backgroundColor = .clear
		buttonNode.borderWidth = 1
		buttonNode.borderColor = kayayuColor.softGrey.cgColor
		buttonNode.cornerRadius = cornerRadiusFloat
	}
	
}
