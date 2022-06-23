//
//  ItemRealm.swift
//  GPLX
//
//  Created by MacOne-YJ4KBJ on 09/06/2022.
//

import Foundation
import RealmSwift

class ItemRealm: Object{
    @objc dynamic var lessions : Int = -1
    @objc dynamic var numberWrong = -1
    @objc dynamic var numberRight = -1
    @objc dynamic var passLession = Pass.none.rawValue
    
}

