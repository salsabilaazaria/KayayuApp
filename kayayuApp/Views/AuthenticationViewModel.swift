//
//  AuthenticationViewModel.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 29/11/21.
//

import Foundation
import FirebaseAuth

class AuthenticationViewModel {
	//AuthenticationViewModel variable
	var email: String = ""
	
	func validateLoginData(email: String, password: String) -> Bool{
		//put logic to data validation, if data correct return true
		print("Auth Validate Login Data Username '\(email)' Password '\(password)'")
		//@angie when debugging filter word "auth to see result
        guard email.isEmpty else {
            return false
        }
        
        
		//putting username to variable so it can be accessed by other page
		self.email = email
		return true
		
	}
	
	func validateRegisterData(username: String, email: String, password: String, confirmPassword: String) -> Bool{
		//put logic to data validation, if data correct return true
		print("Auth Validate Register Data \(username), \(email), \(password), \(confirmPassword)")
		//@angie when debugging filter word "auth to see result
		return true
		
	}
	
	func addRegisterData(username: String, email: String, password: String, confirmPassword: String) {
		//put logic to add data to database
		print("Auth Add Register Data \(username), \(email), \(password), \(confirmPassword)")
		//@angie when debugging filter word "auth to see result
		
	}
	
    
//    FirebaseAuth.Auth.auth()
}
