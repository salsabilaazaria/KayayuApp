//
//  PopUpContent.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 30/12/21.
//

import Foundation
import AsyncDisplayKit

enum popUpType: String {
	case invalidData = "invalidData"
}

class PopUpContent: ASDisplayNode {
	private let title: ASTextNode = ASTextNode()
	private let subtitle: ASTextNode = ASTextNode()
	private var bigButton: BigButton = BigButton()
	private let type: popUpType
	
	init(type: popUpType) {
		self.type = type
		super.init()
		cornerRadius = 8.0
		clipsToBounds = true
		backgroundColor = .white
		automaticallyManagesSubnodes = true
		
		configureContent()
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let centerSubtitle = ASStackLayoutSpec(direction: .vertical,
											   spacing: 0,
											   justifyContent: .center,
											   alignItems: .center,
											   children: [subtitle])
		
		let textSpec = ASStackLayoutSpec(direction: .vertical,
											spacing: 8,
											justifyContent: .center,
											alignItems: .center,
											children: [title,centerSubtitle])
		
		let contentSpec = ASStackLayoutSpec(direction: .vertical,
											spacing: 16,
											justifyContent: .center,
											alignItems: .center,
											children: [textSpec, bigButton])
		
		contentSpec.style.maxWidth = ASDimension(unit: .points, value: constrainedSize.max.width)
		
		let mainInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 32, left: 16, bottom: 24, right: 16), child: contentSpec)
		
		
		
		return mainInset
	}
	
	private func configureContent() {
		switch type {
		case .invalidData:
			title.attributedText = NSAttributedString.semibold("Add Data Failed", 16, .black)
			subtitle.attributedText = NSAttributedString.normal("There is invalid data. Please try again.", 14, .black)
			bigButton = BigButton(buttonText: "OK", buttonColor: kayayuColor.yellow, borderColor: kayayuColor.yellow)
		default:
			break;
		}
		
	}
}
