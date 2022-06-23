//
//  ManagerRealm.swift
//  GPLX
//
//  Created by MacOne-YJ4KBJ on 09/06/2022.
//

import Foundation
import RealmSwift

class ManagerRealm{
    private var db : Realm
    static let shareInstance = ManagerRealm()
    private init(){
        db = try! Realm()
    }
    
    func addData(_ object: ItemRealm){
        try! db.write({
            db.add(object)
        })
    }
    
    func readData() -> Results<ItemRealm>{
        let result : Results<ItemRealm> = db.objects(ItemRealm.self)
        return result
    }
    
    func deleteAnyObject(code: Int){
        do {
            let realm = try Realm()
            let object = realm.objects(ItemRealm.self).filter("lessions == %@", code)
            try! realm.write {
              
                    realm.delete(object)
                    print("xoa")
            
            }
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }

    }
    
    func deleteAllObject(){
        do {
            let realm = try Realm()
            try! realm.write {
                realm.deleteAll()
                print("xoa het")
            }
        } catch let error as NSError {
            print("error - \(error.localizedDescription)")
        }
    }
    
    func updateObject(code: Int, numberRight: Int, numberWrong: Int, passLession: Pass){
        do {
            let realm = try Realm()
            let object = realm.objects(ItemRealm.self).filter("lessions == %@", code).first
            if let datafilder = object{
                try! realm.write {
                    datafilder.numberWrong = numberWrong
                    datafilder.numberRight = numberRight
                    datafilder.passLession = passLession.rawValue
                }
            }
            
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
    }
    
}
