//
//  DataSaveModel.swift
//  Lex
//
//  Created by Chawtech on 23/05/22.
//

import Foundation


struct DataSave_Struct:Codable{
    var data = [AllData_Struct]()
}

struct AllData_Struct:Codable{
    var id: String = ""
    var description: String = ""
    var answer: String = ""
    var calendar_date: [String] = []
}
