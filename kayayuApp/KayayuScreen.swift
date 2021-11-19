//
//  KayayuScreen.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 19/11/21.
//

import Foundation
import UIKit

final class KayayuScreen {
	private var navigationController: UINavigationController?
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	
	enum NavigationEvent {
		case onOpenHomePage
		case onOpenLandingPage
//		case onOpenStatsPage
//		case onOpenProfilePage
//		case onOpenRecordIncomePage
//		case onOpenRecordExpensePage
		
	}
	
	public init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func make() -> UIViewController {
		var viewController: UIViewController
		viewController = makeLandingPageViewController()
		return viewController
	}
	
	func makeLandingPageViewController() -> UIViewController {
		let controller = LandingViewController()
		return controller
	}
	
	func makeHomePageViewController() -> UIViewController {
		let controller = HomeViewController()
		return controller
	}
	


}

