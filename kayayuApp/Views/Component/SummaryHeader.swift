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
	private let progressBarText: ASTextNode = ASTextNode()
	private let progressBarNode: ASDisplayNode = ASDisplayNode()
	private var subtitleText: String
	private var summary: summary
	
	private let createProgressBar: Bool
	private let progressBarHeight: CGFloat = 20
	private let progressBarWidth: CGFloat = UIScreen.main.bounds.width - 110
	private let nodeSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 80)
	
	init(summary: summary = .balance, subtitleText: String = "") {
		self.summary = summary
		self.subtitleText = subtitleText
		self.createProgressBar = false
		
		super.init()
		configureNodeBorder()
		configureTitle()
		configureSubtitle()
		configureIcon()
		
		automaticallyManagesSubnodes = true
	}
	
	init(summary: summary, ratio: Float, progressColor: UIColor, baseColor: UIColor, progressBarText: String) {
		
		self.summary = summary
		self.subtitleText = ""
		self.createProgressBar = true
		super.init()
		
		configureNodeBorder()
		configureIcon()
		configureTitle()
		configureProgressBarText(text: progressBarText)
		configureProgressBar(ratio: ratio, progressColor: progressColor, baseColor: baseColor)
		
		automaticallyManagesSubnodes = true
	}
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		var elementArray: [ASLayoutElement] = [title]
		
		if !createProgressBar {
			elementArray.append(subtitle)
			
		} else {
			let text = ASCenterLayoutSpec(centeringOptions: .X, sizingOptions: .minimumXY, child: progressBarText)
			let progressBarOverlayText = ASOverlayLayoutSpec(child: progressBarNode, overlay: text)
			elementArray.append(progressBarOverlayText)
			
		}
		
		
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
		icon.image = UIImage(named: "\(summary.rawValue).png")
		icon.style.preferredSize = CGSize(width: 40, height: 40)
	}
	
	private func configureTitle() {
		title.attributedText = NSAttributedString.bold(summary.rawValue.uppercased(), 16, .black)
	}
	
	private func configureSubtitle() {
		print("configure subtitle with \(subtitleText)")
		subtitle.attributedText = NSAttributedString.normal(subtitleText, 12, .black)
	}
	
	private func configureProgressBarText(text: String) {
		progressBarText.attributedText = NSAttributedString.normal(text, 9, .black)
	}
	
	private func configureProgressBar(ratio: Float, progressColor: UIColor, baseColor: UIColor) {
		let progressBar: UIProgressView = UIProgressView()
		progressBar.frame = CGRect(x: 0, y: 3, width:progressBarWidth, height: progressBarHeight)
		progressBar.layer.cornerRadius = 20.0
		progressBar.progressTintColor = progressColor
		progressBar.trackTintColor = baseColor
		progressBar.progress = ratio
		progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3)
		
		progressBarNode.view.addSubview(progressBar)
		progressBarNode.style.preferredSize = CGSize(width: progressBarWidth, height: progressBarHeight)
	}
	
}
