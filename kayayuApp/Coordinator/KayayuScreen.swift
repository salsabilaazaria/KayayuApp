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
		case onOpenLandingPage
		case onOpenHomePage(authenticationViewModel: AuthenticationViewModel)
		case onOpenLoginPage(authenticationViewModel: AuthenticationViewModel)
		case onOpenRegisterPage(authenticationViewModel: AuthenticationViewModel)
		case onOpenStatsPage
//		case onOpenProfilePage
//		case onOpenRecordIncomePage
//		case onOpenRecordExpensePage
		
	}
	
	public init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func make() -> UIViewController {
		let controller = makeLandingPageViewController()
		return controller
	}
	
	func makeLandingPageViewController() -> UIViewController {
		let controller = LandingViewController()
		let viewModel = AuthenticationViewModel()
		controller.onOpenLoginPage = { [weak self] in
			guard let self = self else {
				return
			}
			print("screen on open login")
			self.onNavigationEvent?(.onOpenLoginPage(authenticationViewModel: viewModel))
		}
		controller.onOpenRegisterPage = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onOpenRegisterPage(authenticationViewModel: viewModel))
		}
		return controller
	}
	
	func makeLoginPageViewController(authenticationViewModel: AuthenticationViewModel) -> UIViewController {
		let controller = LoginViewController(authenticationViewModel: authenticationViewModel)
		controller.onOpenHomePage = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onOpenHomePage(authenticationViewModel: authenticationViewModel))
		}
		return controller
	}
	
	func makeRegisterPageViewController(authenticationViewModel: AuthenticationViewModel) -> UIViewController {
		let controller = RegisterViewController(authenticationViewModel: authenticationViewModel)
		controller.onOpenHomePage = { [weak self] in
			guard let self = self else {
				return
			}
			
			self.onNavigationEvent?(.onOpenHomePage(authenticationViewModel: authenticationViewModel))
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

