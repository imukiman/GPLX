//
//  Item.swift
//  GPLX
//
//  Created by MacOne-YJ4KBJ on 09/06/2022.
//

import Foundation

// MARK: - WelcomeElement
struct Items: Codable {
    let lessions: Int
    let questions: [Question]
}

// MARK: - Question
struct Question: Codable {
    let id: Int
    let titleQ: String
    let arrayAnswersQ: [String]
    let numberCorrectQ: Int
    let imageQ: String?

    enum CodingKeys: String, CodingKey {
        case id
        case titleQ = "title_q"
        case arrayAnswersQ = "arrayAnswers_q"
        case numberCorrectQ = "numberCorrect_q"
        case imageQ = "image_q"
    }
}

typealias Item = [Items]
