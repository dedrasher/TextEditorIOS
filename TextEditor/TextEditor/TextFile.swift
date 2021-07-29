//
//  TextFile.swift
//  TextEditor
//
//  Created by Serega on 09.07.2021.
//

import Foundation
struct TextFile: Hashable {
    static func == (lhs: TextFile, rhs: TextFile) -> Bool {
        return lhs.name == rhs.name && lhs.date == rhs.date
    }
    public static let simpleFile = TextFile(name: "", date: "01.01.1000")
    public var name : String
    public var date : String
    init( name: String, date: String) {
        self.name = name
        self.date = date
    }
    
}
