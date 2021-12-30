//
//  PopUpBackground.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 31/12/21.
//

import Foundation
import AsyncDisplayKit

class PopUpBackground: ASDisplayNode {
	
	private let content = PopUpContent()
	
	override init() {
		super.init()
		backgroundColor = .init(white: 0, alpha: 0.5)
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		content.style.minSize = CGSize(width: 270 * UIScreen.main.bounds.width / 375, height: 0)
		content.style.maxSize = CGSize(width: 270 * UIScreen.main.bounds.width / 375, height: UIScreen.main.bounds.height - 48)
		return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: [], child: content)
	}
	
}
