//
//  AuthenticationViewModel.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 29/11/21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class AuthenticationViewModel {
	//AuthenticationViewModel variable
	var onOpenHomePage: (() -> Void)?
	var showAlert: (() -> Void)?
	var email: String = ""
	let database = Firestore.firestore()
	
	func validateLoginData(email: String, password: String) {
		//put logic to data validation, if data correct return true
		print("Auth Validate Login Data Username '\(email)' Password '\(password)'")
		guard !email.isEmpty,
			  !password.isEmpty else {
			return
		}
		
		FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
			guard let self = self else {
				return
			}
			guard error == nil else {
				self.showAlert?()
				print("KAYAYU Login Failed")
				return
			}
			
			self.onOpenHomePage?()
			print("KAYAYU Login Success")
			
			
		})
		
	}
	
	func validateRegisterData(username: String, email: String, password: String, confirmPassword: String) {
		print("Auth Validate Register Data \(username), \(email), \(password), \(confirmPassword)")
		guard !username.isEmpty,
			  !email.isEmpty,
			  email.contains("@"),
			  !password.isEmpty,
			  !confirmPassword.isEmpty,
			  password == confirmPassword else {
			print("KAYAYU Register Data is not valid")
			self.showAlert?()
			return
		}
		
		self.addRegisterData(username: username, email: email, password: password, confirmPassword: confirmPassword)
	}
	
	private func addRegisterData(username: String, email: String, password: String, confirmPassword: String) {
		
		print("Auth Add Register Data \(username), \(email), \(password), \(confirmPassword)")
		
		FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
			
			guard let self = self else {
				return
			}
			
			guard error == nil else {
				self.showAlert?()
				return
			}
		})
		
	}
	
	func logout() {
		do {
			try FirebaseAuth.Auth.auth().signOut()
		}
		catch { print("already logged out") }
		
		print("KAYAYU Logout Success")
	}
	
}
