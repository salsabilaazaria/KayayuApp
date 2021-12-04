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

class HomeViewModel {
    let database = Firestore.firestore()
    
    var userBalanceTotal: String = ""
    
    func getUserId() -> String{
        guard let userId = Auth.auth().currentUser?.uid else { return "" }
        print("KAYAYU USER ID \(userId)")
        return userId
    }
    
    func getUserBalance() -> String {
//        let docRef = database.collection("users").document(getUserId())
        
//        docRef.getDocument(completion: <#T##FIRDocumentSnapshotBlock##FIRDocumentSnapshotBlock##(DocumentSnapshot?, Error?) -> Void#>)
        
        database.collection("users").document(getUserId()).addSnapshotListener({ documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("KAYAYU GET DATA FAILED")
                return
            }
            guard let data = document.data() else {
                print("KAYAYU GET DATA NOT FOUND")
                return
            }
            
    
            print("Current Data: \(data)")
            
            
        })
        return userBalanceTotal
    }
}
