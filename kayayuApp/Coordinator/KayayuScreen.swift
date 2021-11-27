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
		case onOpenLoginPage
		case onOpenRegisterPage
		case onOpenStatsPage
//		case onOpenProfilePage
//		case onOpenRecordIncomePage
//		case onOpenRecordExpensePage
		
	}
	
	public init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func make() -> UIViewController {
		let controller = makeStatsPageViewController()
		return controller
	}
	
	func makeLandingPageViewController() -> UIViewController {
		let controller = LandingViewController()
		controller.onOpenLoginPage = { [weak self] in
			guard let self = self else {
				return
			}
			print("screen on open login")
			self.onNavigationEvent?(.onOpenLoginPage)
		}
		controller.onOpenRegisterPage = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onOpenRegisterPage)
		}
		return controller
	}
	
	func makeLoginPageViewController() -> UIViewController {
		let controller = LoginViewController()
		controller.onOpenHomePage = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onOpenHomePage)
		}
		return controller
	}
	
	func makeRegisterPageViewController() -> UIViewController {
		let controller = RegisterViewController()
		controller.onOpenHomePage = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onOpenHomePage)
		}
		return controller
	}
	
	func makeHomePageViewController() -> UIViewController {
		let controller = HomeViewController()
		return controller
	}
	
	func makeStatsPageViewController() -> UIViewController {
		let controller = StatsViewController()
		return controller
	}


}

