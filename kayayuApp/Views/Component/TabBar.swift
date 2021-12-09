//
//  NavigationBar.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 11/14/21.
//

import Foundation
import AsyncDisplayKit

class TabBar: ASDisplayNode {
	
	private let homeButton: ASButtonNode = ASButtonNode()
	private let homeIcon: ASImageNode = ASImageNode()
	private let homeText: ASTextNode = ASTextNode()
	
	private let statsButton: ASButtonNode = ASButtonNode()
	private let statsIcon: ASImageNode = ASImageNode()
	private let statsText: ASTextNode = ASTextNode()
	
	private let profileButton: ASButtonNode = ASButtonNode()
	private let profileIcon: ASImageNode = ASImageNode()
	private let profileText: ASTextNode = ASTextNode()
	
	private let iconSize: CGSize = CGSize(width: 30, height: 30)
	private let itemSize: CGSize = CGSize(width: UIScreen.main.bounds.width/3, height: 80)
	private let titleSpacing: CGFloat = 6
	
	
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
										  spacing: 8,
										  justifyContent: .center,
										  alignItems: .center,
										  children: [home,stats,profile])
		
		return mainSpec
	}
	

	private func configureHomeNavbar() -> ASLayoutSpec {
		homeIcon.style.preferredSize = iconSize
		homeIcon.backgroundColor = .red
//		homeIcon.image = UIImage(named: "")
		
		homeText.attributedText = NSAttributedString.normal("Home", 10, .darkGray)
		homeButton.backgroundColor = .clear
		
		let homeDisplay = ASStackLayoutSpec(direction: .vertical,
											spacing: titleSpacing,
											justifyContent: .center,
											alignItems: .center,
											children: [homeIcon, homeText])
		homeDisplay.style.preferredSize = itemSize
		let homeButtonOverlay = ASOverlayLayoutSpec(child: homeDisplay, overlay: homeButton)
		
		return homeButtonOverlay
	}
	
	private func configureStatsNavbar() -> ASLayoutSpec {
		statsIcon.style.preferredSize = iconSize
		statsIcon.backgroundColor = .red
//		statsIcon.image = UIImage(named: "")
		
		statsText.attributedText = NSAttributedString.normal("Stats", 10, .darkGray)
		statsButton.backgroundColor = .clear
		let statsDisplay = ASStackLayoutSpec(direction: .vertical,
											spacing: titleSpacing,
											justifyContent: .center,
											alignItems: .center,
											children: [statsIcon, statsText])
		statsDisplay.style.preferredSize = itemSize
		
		let statsButtonOverlay = ASOverlayLayoutSpec(child: statsDisplay, overlay: statsButton)
		
		return statsButtonOverlay
	}
	
	private func configureProfileNavbar() -> ASLayoutSpec {
		profileIcon.style.preferredSize = iconSize
		profileIcon.backgroundColor = .red
//		profileIcon.image = UIImage(named: "")
		
		profileText.attributedText = NSAttributedString.normal("Profile", 10, .darkGray)
		profileButton.backgroundColor = .clear
		let profileDisplay = ASStackLayoutSpec(direction: .vertical,
											spacing: titleSpacing,
											justifyContent: .center,
											alignItems: .center,
											children: [profileIcon, profileText])
		profileDisplay.style.preferredSize = itemSize
		
		let profileButtonOverlay = ASOverlayLayoutSpec(child: profileDisplay, overlay: profileButton)
	
		return profileButtonOverlay
	}
	
}
