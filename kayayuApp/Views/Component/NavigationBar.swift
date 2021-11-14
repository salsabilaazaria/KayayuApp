//
//  NavigationBar.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/14/21.
//

import Foundation
import AsyncDisplayKit

class NavigationBar: ASDisplayNode {
	
	private let homeButton: ASButtonNode = ASButtonNode()
	private let homeIcon: ASImageNode = ASImageNode()
	private let homeText: ASTextNode = ASTextNode()
	
	private let statsButton: ASButtonNode = ASButtonNode()
	private let statsIcon: ASImageNode = ASImageNode()
	private let statsText: ASTextNode = ASTextNode()
	
	private let profileButton: ASButtonNode = ASButtonNode()
	private let profileIcon: ASImageNode = ASImageNode()
	private let profileText: ASTextNode = ASTextNode()
	
	
	override init() {
		super.init()

		style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
		backgroundColor = kayayuColor.softGrey
		automaticallyManagesSubnodes = true
	}
	
	
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		
		let home = configureHomeNavbar()
		let stats = configureStatsNavbar()
		let profile = configureProfileNavbar()
		
		let mainSpec = ASStackLayoutSpec(direction: .horizontal,
										  spacing: <#T##CGFloat#>,
										  justifyContent: .center,
										  alignItems: .center,
										  children: [home,stats,profile])
		return mainSpec
	}
	

	private func configureHomeNavbar() -> ASLayoutSpec {
		homeIcon.style.preferredSize = CGSize(width: 40, height: 40)
		homeIcon.image = UIImage(named: "")
		
		homeText.attributedText = NSAttributedString.normal("", 10, .darkGray)
		
		let homeDisplay = ASStackLayoutSpec(direction: .vertical,
											spacing: 0,
											justifyContent: .center,
											alignItems: .center,
											children: [homeIcon, homeText])
		
		let homeButtonOverlay = ASOverlayLayoutSpec(child: homeDisplay, overlay: homeButton)
		
		return homeButtonOverlay
	}
	
	private func configureStatsNavbar() -> ASLayoutSpec {
		statsIcon.style.preferredSize = CGSize(width: 40, height: 40)
		statsIcon.image = UIImage(named: "")
		
		statsText.attributedText = NSAttributedString.normal("", 10, .darkGray)
		
		let statsDisplay = ASStackLayoutSpec(direction: .vertical,
											spacing: 0,
											justifyContent: .center,
											alignItems: .center,
											children: [statsIcon, statsText])
		
		let statsButtonOverlay = ASOverlayLayoutSpec(child: statsDisplay, overlay: statsButton)
		
		return statsButtonOverlay
	}
	
	private func configureProfileNavbar() -> ASLayoutSpec {
		profileIcon.style.preferredSize = CGSize(width: 40, height: 40)
		profileIcon.image = UIImage(named: "")
		
		profileText.attributedText = NSAttributedString.normal("", 10, .darkGray)
		
		let profileDisplay = ASStackLayoutSpec(direction: .vertical,
											spacing: 0,
											justifyContent: .center,
											alignItems: .center,
											children: [profileIcon, profileText])
		
		let profileButtonOverlay = ASOverlayLayoutSpec(child: profileDisplay, overlay: profileButton)
		
		return profileButtonOverlay
	}
	
}
