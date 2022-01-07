//
//  PopUpContent.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 30/12/21.
//

import Foundation
import AsyncDisplayKit

class PopUpContent: ASDisplayNode {
	private let title: ASTextNode = ASTextNode()
	private let subtitle: ASTextNode = ASTextNode()
	private var bigButton: BigButton = BigButton()
	
	override init() {
		super.init()
		cornerRadius = 8.0
		clipsToBounds = true
		backgroundColor = .white
		automaticallyManagesSubnodes = true
		
		configureContent()
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let textSpec = ASStackLayoutSpec(direction: .vertical,
											spacing: 8,
											justifyContent: .center,
											alignItems: .center,
											children: [title,subtitle])
		
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
		title.attributedText = NSAttributedString.semibold("title", 14, .black)
		subtitle.attributedText = NSAttributedString.normal("qwedwfadckewfnksdnckenkfqwefqe", 14, .black)
		bigButton = BigButton(buttonText: "Understand", buttonColor: kayayuColor.yellow, borderColor: kayayuColor.yellow)
	}
}
