//
//  HomeViewModel.swift
//  kayayuApp
//
//  Created by angie on 04/12/21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import RxCocoa
import RxSwift


class HomeViewModel {
    let database = Firestore.firestore()
    var user: BehaviorRelay<Users?> = BehaviorRelay<Users?>(value: nil)
    
    var userBalanceTotal: Float = 0
    
    init() {
        self.getUserData()
    }
    
    func getUserId() -> String{
        guard let userId = Auth.auth().currentUser?.uid else { return "" }
        print("KAYAYU USER ID \(userId)")
        return userId
    }
    
    func getUserData() {
        
        database.collection("users").document(getUserId()).addSnapshotListener({ documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("KAYAYU get data failed")
                return
            }
            
            do {
                guard let userData = try document.data(as: Users.self) else {
                    print("KAYAYU USER DATA IS NIL")
                    return
                }
                self.user.accept(userData)
                
            } catch {
                print(error)
            }
        })
    }
}
