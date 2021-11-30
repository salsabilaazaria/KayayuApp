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
		case onOpenAddRecordPage
//		case onOpenProfilePage
		
	}
	
	public init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func make() -> UIViewController {
		let controller = makeHomePageViewController()
		return controller
	}
	
	func makeLandingPageViewController() -> UIViewController {
		let controller = LandingViewController()
		controller.onOpenLoginPage = { [weak self] in
			guard let self = self else {
				return
			}
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
		controller.onOpenAddRecordPage = { [weak self] in
			guard let self = self else {
				return
			}
			self.onNavigationEvent?(.onOpenAddRecordPage)
		}
		return controller
	}
	
	func makeStatsPageViewController() -> UIViewController {
		let controller = StatsViewController()
		return controller
	}
	
	func makeAddRecordPageViewController() -> UIViewController {
		let controller = AddRecordViewController()
		return controller
	}


}

