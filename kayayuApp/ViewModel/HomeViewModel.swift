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
    var transaction: BehaviorRelay<[Transactions]?> = BehaviorRelay<[Transactions]?>(value: nil)
    
    var userBalanceTotal: Float = 0
    
    init() {
        self.getUserData()
        self.getTransactionCount()
//        self.getTransactions()
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
    
    func getTransactionCount () {
        database.collection("transactions").whereField("user_id", isEqualTo: getUserId()).getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("error getting doc")
            }
            else {
                var count = 0
                var docummentArray: [Transactions] = []
                for document in QuerySnapshot!.documents {
                    count += 1
                    
                    do {
                        guard let trans = try document.data(as: Transactions.self) else {
                            print("KAYAYU USER DATA IS NIL")
                            return
                        }
                        docummentArray.append(trans)
                        
                    } catch {
                        print(error)
                    }
     
                }
                self.transaction.accept(docummentArray)
                print(docummentArray)
                print("Count: \(count)")
            }
            
        }
    }
    
//    func getTransactions() {
//
//        database.collection("transactions").whereField("user_id", isEqualTo: getUserId()).addSnapshotListener{ documentSnapshot, error in
//            guard let documents = documentSnapshot?.documents else {
//                print("Error fetching documents")
//                return
//            }
//            print("KAYAYU TRANSACTION DOCUMENT\(documents)")
//            let transactionsData = documents.flatMap({
//                document -> Transactions in return try! document.data(as: Transactions.self)!
//            })
//            print("KAYAYU TRANSACTION\(transactionsData)")
//        }
//    }
}
