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
              email.contains("@"),
              !password.isEmpty,
              !confirmPassword.isEmpty,
              password == confirmPassword else {
            print("KAYAYU Register Data is not valid")
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
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let user = Users(user_id: userId,
                             username: username,
                             email: email,
                             password: password,
                             balance_total: 0,
                             balance_month: 0,
                             balance_needs: 0,
                             balance_wants: 0,
                             balance_savings: 0)
            do {
                try self.database.collection("users").document("\(userId)").setData(from: user)
            } catch let error {
                print("KAYAYU gabisa masuk ke firestore")
            }
        
            print("KAYAYU Registration Successful")
            
        })
    }
    
}
