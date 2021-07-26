//
//  DateHelper.swift
//  TextEditor
//
//  Created by Serega on 09.07.2021.
//

import Foundation
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
class DateHelper {
    private static let formatter = DateFormatter()
    public static func date() -> String {
      return formatDate(date: Date())
    }
     public static func compareDates(_ first: String, _ second: String) -> Bool {
           formatter.dateFormat = "dd/MM/yyyy"
           return formatter.date(from: first)! < formatter.date(from: second)!
      }
    public static func formatDate(date: Date = Date()) -> String {
          formatter.dateFormat = "dd.MM.YYYY"
           return formatter.string(from: date as Date)
      }

}
