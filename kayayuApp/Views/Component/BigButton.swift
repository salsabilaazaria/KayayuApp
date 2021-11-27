//
//  bigButton.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/9/21.
//

import Foundation
import AsyncDisplayKit

class BigButton: ASButtonNode {
	var buttonText: String = ""
	var background: UIColor = UIColor()
	var border: UIColor = UIColor()
	
	public init(buttonText: String = "", buttonColor: UIColor = .white, borderColor: UIColor = .white) {
		self.buttonText = buttonText
		self.background = buttonColor
		self.border = borderColor
		super.init()
		configureBigButton()
	}
	
	
	private func configureBigButton(){
		setAttributedTitle(NSAttributedString.semibold(buttonText, 14, .black), for: .normal)
		
		style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 32, height: kayayuSize.kayayuBarHeight)
		backgroundColor = background
		borderColor = border.cgColor
		borderWidth = 1.0
		cornerRadius = 8.0
		
	}
	
}
