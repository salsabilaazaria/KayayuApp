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
	var onCreateTabBar: (() -> Void)?
	var enableButton: (() -> Void)?
	var showAlert: ((String) -> Void)?
	var email: String = ""
	let database = Firestore.firestore()
	
	func getUserData() -> User? {
		guard let userData = FirebaseAuth.Auth.auth().currentUser else {
			return nil
		}
		return userData
	}
	
	func validateLoginData(emailInputted: String, passwordInputted: String) {
		//put logic to data validation, if data correct return true
		print("Kayayu Auth Validate Login Data Username '\(emailInputted)' Password '\(passwordInputted)'")
		guard !emailInputted.isEmpty,
			  !passwordInputted.isEmpty else {
			self.showAlert?("Invalid data, please try again.")
			self.enableButton?()
			return
		}
		
		FirebaseAuth.Auth.auth().signIn(withEmail: emailInputted, password: passwordInputted, completion: { [weak self] result, error in
			guard let self = self else {
				return
			}
			guard error == nil else {
				self.enableButton?()
				self.showAlert?(error?.localizedDescription ?? "Login failed, please try again later")
				print("Kayayu Login Failed")
				return
			}
			print("Kayayu Login Success")
			self.onCreateTabBar?()
			
		})
		
	}
	
	func validateRegisterData(username: String, email: String, password: String, confirmPassword: String) {
		print("Kayayu Auth Validate Register Data \(username), \(email), \(password), \(confirmPassword)")
		guard !username.isEmpty,
			  !email.isEmpty,
			  email.contains("@"),
			  !password.isEmpty,
			  !confirmPassword.isEmpty,
			  password == confirmPassword else {
			print("Kayayu Register Data is not valid")
			self.showAlert?("There is invalid data, please try again.")
			self.enableButton?()
			return
		}
		
		self.addRegisterData(username: username, email: email, password: password, confirmPassword: confirmPassword)
	}
	
	private func addRegisterData(username: String, email: String, password: String, confirmPassword: String) {
		
		print("Kayayu Auth Processing Add Register Data \(username), \(email), \(password), \(confirmPassword)")
		
		FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
			
			guard let self = self else {
				return
			}
			
			let changeRequest = result?.user.createProfileChangeRequest()
			changeRequest?.displayName = username
			changeRequest?.commitChanges { error in
				print("Kayayu Change username in firebase authentication failed \(error?.localizedDescription ?? "unknown")")
				self.showAlert?(error?.localizedDescription ?? "Register failed, please try again later.")
				self.enableButton?()
				return
			}
			
			guard error == nil else {
				print("Kayayu Failed to register \(error?.localizedDescription ?? "unknown")")
				self.showAlert?(error?.localizedDescription ?? "Register failed, please try again later.")
				self.enableButton?()
				return
			}
			
			
			if let result = result {
				
				let data = Users(user_id: result.user.uid,
								 username: username,
								 email: email,
								 password: password,
								 balance_total: 0,
								 balance_needs: 0,
								 balance_wants: 0,
								 balance_savings: 0)
				
				do {
					try
						self.database.collection("users").document(result.user.uid).setData(from: data)
					self.onCreateTabBar?()
				} catch {
					print("Kayayu Error setting data to data firestore \(error)")
				}
				
			}
			
		})
		
	}
	
	func logout() {
		do {
			try FirebaseAuth.Auth.auth().signOut()
		}
		catch { print("already logged out") }
		
		print("Kayayu Logout Success")
	}
	
}
