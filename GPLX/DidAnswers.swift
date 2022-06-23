//
//  DidAnswers.swift
//  GPLX
//
//  Created by MacOne-YJ4KBJ on 09/06/2022.
//

import Foundation
enum Pass: String{
    case none = "none"
    case right = "right"
    case wrong = "wrong"
}
struct DidAnswers{
    var lession : Int
    var answer : [Answer]
}
struct Answer{
    var numberQ : Int
    var passQ : Pass = .none
    var yourAnswer = -1
    var numberRight = -1
}
