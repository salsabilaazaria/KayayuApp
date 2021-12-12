//
//  SubscriptionCellNode.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 12/6/21.
//

import Foundation
import AsyncDisplayKit

class SubscriptionCellNode: ASCellNode {
	private let subscriptionName: ASTextNode = ASTextNode()
	private let amountSubs: ASTextNode = ASTextNode()
	private let dateSubs: ASTextNode = ASTextNode()
	private let typeSubs: ASTextNode = ASTextNode()
	private let endDateSubs: ASTextNode = ASTextNode()
	private let dueDate: ASTextNode = ASTextNode()
    
    private let subsData: RecurringTransactions
    
    init(data: RecurringTransactions){
        self.subsData = data
        super.init()
        
        configureInformation()
        
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

		let mainSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 0,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [createInfoSpec(), createDueDate()])
		
		let insetMainSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16), child: mainSpec)
		
		return insetMainSpec
	}
	
	private func createInfoSpec() -> ASLayoutSpec {
		configureInformation()
		let backgroundNode: ASDisplayNode = ASDisplayNode()
		backgroundNode.backgroundColor = .clear
		backgroundNode.borderColor = kayayuColor.softGrey.cgColor
		backgroundNode.borderWidth = 1
		
		let textSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 4,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [subscriptionName,amountSubs,dateSubs,typeSubs,endDateSubs])
		let insetTextSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16), child: textSpec)
		
		backgroundNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height/6)
		
		let infoSpec = ASOverlayLayoutSpec(child: backgroundNode, overlay: insetTextSpec)
		
		return infoSpec
	}
	
	private func createDueDate() -> ASLayoutSpec {
		let backgroundNode: ASDisplayNode = ASDisplayNode()
		backgroundNode.backgroundColor = .clear
		backgroundNode.borderColor = kayayuColor.softGrey.cgColor
		backgroundNode.borderWidth = 1
		
		let textSpec = ASStackLayoutSpec(direction: .vertical,
										 spacing: 4,
										 justifyContent: .start,
										 alignItems: .start,
										 children: [dueDate])
		let insetTextSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16), child: textSpec)
		
		backgroundNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width , height: 40)
		
		let infoSpec = ASOverlayLayoutSpec(child: backgroundNode, overlay: insetTextSpec)
		
		return infoSpec
	}
	
	private func configureInformation() {
		subscriptionName.attributedText = NSAttributedString.bold("Subscription", 14, .black)
		amountSubs.attributedText = NSAttributedString.normal("Rp\(subsData.total_amount)", 14, .black)
		dateSubs.attributedText = NSAttributedString.normal("Billing Date: \(subsData.start_billing_date)", 14, .black)
		typeSubs.attributedText = NSAttributedString.normal("Billed: \(subsData.billing_type)", 14, .black)
		
		//need to prepare data
		endDateSubs.attributedText = NSAttributedString.normal("End of Subscription Date: ", 14, .black)
		dueDate.attributedText = NSAttributedString.normal("Due in", 14, .black)
	}
	
}
