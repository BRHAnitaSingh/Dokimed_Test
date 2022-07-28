//
//  QuestionModel.swift
//  Lex
//
//  Created by Ritesh Sinha on 15/03/22.
//

import Foundation

struct QuestionsList_Struct: Codable {
    var order: Int = 0
    var id: String = ""
    var question: String = ""
    var question_type: String = ""
    var answer: String = ""
    
}

//struct testList_Struct: Codable {
//    var order: Int = 0
//    var id: String = ""
//    var description: String = ""
//    var answer: String = ""
//
//}
struct testList_Struct: Codable {
    var order: Int = 0
    var id: String = ""
    var description: String = ""
    var answer: String = ""
    var at_what_age: Int = 0
    var how_often_year_label: String = ""
    var how_often_year: String = ""
    var link:String = ""
    var calendar_date: [String] = []
    var is_check = false
    var gender: String = ""
    var age_year: String = ""
    var age_month: String = ""
    var timer_day: String = ""
    var timer_month: String = ""
    var timer_year: String = ""
    var label_day: String = ""
    var lng: String = ""
    var numberOfDays: Int = 0
}
