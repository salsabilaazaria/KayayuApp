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
	let tabBarController: UITabBarController
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	
	
	enum NavigationEvent {
		case onCreateTabBar
		case onOpenHomePage
		case onOpenLandingPage
		case onOpenLoginPage
		case onOpenRegisterPage
		case onOpenStatsPage
		case onOpenAddRecordPage
		case onOpenProfilePage
		
	}
	
	public init(navigationController: UINavigationController, tabBarController:UITabBarController) {
		self.navigationController = navigationController
		self.tabBarController = tabBarController
	}
	
	func make() -> UIViewController {
		let controller = makeLandingPageViewController()
		return controller
	}
	
	func makeTabBarViewController() -> UITabBarController {
		tabBarController.edgesForExtendedLayout = []
		
		let home = makeHomePageViewController()
		home.tabBarItem.title = "Home"
		let stats = makeStatsPageViewController()
		let profile = makeProfileViewController()
	
		tabBarController.tabBar.tintColor = kayayuColor.yellow
		tabBarController.setViewControllers([home,stats,profile], animated: true)
		tabBarController.navigationItem.hidesBackButton = true
		tabBarController.navigationItem.backButtonDisplayMode = .minimal
		
		return tabBarController
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
			
			self.onNavigationEvent?(.onCreateTabBar)
		}
		return controller
	}
	
	func makeRegisterPageViewController() -> UIViewController {
		let controller = RegisterViewController()
		controller.onOpenHomePage = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onCreateTabBar)
		}
		return controller
	}
	
	func makeHomePageViewController() -> UIViewController {
		let controller = HomeViewController()
		
		controller.title = "Hello"
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
		controller.title = "Stats"
		return controller
	}
	
	func makeProfileViewController() -> UIViewController {
		let controller = ProfileViewController()
		controller.title = "Profile"
		return controller
	}
	
	func makeAddRecordPageViewController() -> UIViewController {
		let controller = AddRecordViewController()
		return controller
	}
	
	
}

