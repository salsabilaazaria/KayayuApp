//
//  KayayuCoordinator.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 19/11/21.
//

import Foundation
import UIKit

public final class KayayuCoordinator {
	
	private var navigationController: UINavigationController
	var screen: KayayuScreen?
	private let window: UIWindow
	
	// MARK: - Init
	
	init(window: UIWindow) {
		self.navigationController = UINavigationController()
		self.window = window
		self.window.backgroundColor = .white
		
		print("window \(window)\n navigationcontroller \(navigationController)")
	}
	
	func makeKayayuScreen() {
		print("make kayayu screen")
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
		let screen = KayayuScreen(navigationController: self.navigationController)
		self.screen = screen
		self.configureScreen()
		
		DispatchQueue.main.async { [weak self] in
			print("push view controller")
			self?.navigationController.pushViewController(screen.make(), animated: true)
		}
	}
	
	private func configureScreen() {
		screen?.onNavigationEvent = { [weak self] (navigationEvent: KayayuScreen.NavigationEvent) in
			
			guard let self = self, let screen = self.screen else {
				return
			}
			
			switch navigationEvent {
			case .onOpenHomePage:
				DispatchQueue.main.async {
					let controller = screen.makeHomePageViewController()
					self.navigationController.pushViewController(controller, animated: true)
					
				}
			case .onOpenLandingPage:
				DispatchQueue.main.async {
					let controller = screen.makeLandingPageViewController()
					self.navigationController.pushViewController(controller, animated: true)
					
				}
			case .onOpenLoginPage:
				DispatchQueue.main.async {
					print("go to login")
					let controller = screen.makeLoginPageViewController()
					self.navigationController.pushViewController(controller, animated: true)
					
				}
			case .onOpenRegisterPage:
				DispatchQueue.main.async {
					print("go to register")
					let controller = screen.makeRegisterPageViewController()
					self.navigationController.pushViewController(controller, animated: true)
					
				}
				
			}
		}
	}
	
}
