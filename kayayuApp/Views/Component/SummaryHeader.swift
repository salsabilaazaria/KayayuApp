//
//  SummaryHeader.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/9/21.
//

import Foundation
import AsyncDisplayKit


enum summary: String {
	case balance = "balance"
	case income = "income"
	case expense = "expense"
	case needs = "needs"
	case wants = "wants"
	case savings = "savings"
}

class SummaryHeader: ASCellNode {
	private let icon: ASImageNode = ASImageNode()
	private let title: ASTextNode = ASTextNode()
	private let subtitle: ASTextNode = ASTextNode()

	private var subtitleText: String
	private var summary: summary
	
	private let nodeSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 80)
	
	init(summary: summary = .balance, subtitleText: String = "") {
		self.summary = summary
		self.subtitleText = subtitleText
		
		super.init()
		configureNodeBorder()
		configureTitle()
		configureSubtitle()
		configureIcon()
		
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		var elementArray: [ASLayoutElement] = [title]
		
		let elementSpec = ASStackLayoutSpec(direction: .vertical,
											spacing: 6,
											justifyContent: .center,
											alignItems: .start,
											children: elementArray)
		
		
		let elementSpecCenter = ASCenterLayoutSpec(centeringOptions: .Y,
												  sizingOptions: .minimumXY,
												  child: elementSpec)
		
		let horizontalSpec = ASStackLayoutSpec(direction: .horizontal,
											   spacing: 8,
											   justifyContent: .start,
											   alignItems: .center,
											   children: [icon, elementSpecCenter])
		
		let horizontalSpecInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), child: horizontalSpec)
		
		
		return horizontalSpecInset
	}
	
	private func configureNodeBorder() {
		backgroundColor = .white
		borderWidth = 0.5
		borderColor = UIColor.gray.cgColor
		cornerRadius = 12.0
		style.preferredSize = nodeSize
	}
	
	private func configureIcon() {
		icon.image = UIImage(named: "\(summary.rawValue)Icon.png")
		icon.style.preferredSize = CGSize(width: 40, height: 40)
	}
	
	private func configureTitle() {
		title.attributedText = NSAttributedString.bold(summary.rawValue.uppercased(), 16, .black)
	}
	
	private func configureSubtitle() {
		subtitle.attributedText = NSAttributedString.normal(subtitleText, 14, .black)
	}
	
}
