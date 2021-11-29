//
//  AuthenticationViewModel.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 29/11/21.
//

import Foundation

class AuthenticationViewModel {
	//AuthenticationViewModel variable
	var username: String = ""
	
	func validateLoginData(username: String, password: String) -> Bool{
		//put logic to data validation, if data correct return true
		print("Auth Validate Login Data Username '\(username)' Password '\(password)'")
		//@angie when debugging filter word "auth to see result
		
		//putting username to variable so it can be accessed by other page
		self.username = username
		return true
		
	}
	
	func validateRegisterData(username: String, email: String, password: String, confirmPassword: String) -> Bool{
		//put logic to data validation, if data correct return true
		print("Auth Validate Register Data \(username), \(email), \(password), \(confirmPassword)")
		//@angie when debugging filter word "auth to see result
		self.username = username
		return true
		
	}
	
	func addRegisterData(username: String, email: String, password: String, confirmPassword: String) {
		//put logic to add data to database
		print("Auth Add Register Data \(username), \(email), \(password), \(confirmPassword)")
		//@angie when debugging filter word "auth to see result
		
	}
	
}
