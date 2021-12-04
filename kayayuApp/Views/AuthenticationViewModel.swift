//
//  AuthenticationViewModel.swift
//  kayayuApp
//
//  Created by Salsabila Azaria on 29/11/21.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthenticationViewModel {
	//AuthenticationViewModel variable
    var onOpenHomePage: (() -> Void)?
	var email: String = ""
	
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
                print("KAYAYU Login Failed")
                return
            }
            
            self.onOpenHomePage?()
            print("KAYAYU Login Success")
         
       
        })
   
	}
	
	func validateRegisterData(username: String, email: String, password: String, confirmPassword: String) -> Bool{
        print("Auth Validate Register Data \(username), \(email), \(password), \(confirmPassword)")
        guard !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty,
              password == confirmPassword else {
            return false
        }
        
        
		return true
		
	}
	
	func addRegisterData(username: String, email: String, password: String, confirmPassword: String) {
	
		print("Auth Add Register Data \(username), \(email), \(password), \(confirmPassword)")
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let self = self else {
                return
            }
            
            guard error == nil else {
                print("KAYAYU Registration Failed")
                return
            }
            
            print("KAYAYU Registration Successful")
            
        })
	}
	
    
//    FirebaseAuth.Auth.auth()
}
