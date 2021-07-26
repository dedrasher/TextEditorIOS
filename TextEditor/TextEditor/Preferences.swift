//
//  Preferences.swift
//  TextEditor
//
//  Created by Serega on 09.07.2021.
//

import Foundation
class Preferences {
    public static var recents : [TextFile] = []
    static var recentsDateKey = "recentsDate"
    static var recentsNamesKey = "recentsNames"
    public static func LoadRecents() {
        var recents: [TextFile] = []
        let standards = UserDefaults.standard
        let names = standards.stringArray(forKey: recentsNamesKey) ?? []
        let dates = standards.stringArray(forKey: recentsDateKey) ?? []
        if dates.count > 0 {
        for i in 0..<dates.count {
            let name = names[i]
            if(FileController.Exists(fileName: name)) {
                recents.append(TextFile(name: name, date: dates[i]))
            }
        }
            self.recents = recents
        }
        
    }
    public static func SaveRecents() {
        var names = [String]()
               var dates = [String]()
        for recent in recents {
            names.append(recent.name)
            dates.append(recent.date)
               }
               let defaults = UserDefaults.standard
               defaults.set(names, forKey: recentsNamesKey)
               defaults.set(dates, forKey: recentsDateKey)
    }
    public static func getDates() -> [String] {
        var uploadTimes: [String] = []
        for  i in 0..<recents.count {
            uploadTimes.append(recents[i].date)
        }
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "dd.MM.yyyy"
        let dates = uploadTimes.compactMap { isoFormatter.date(from: $0) }
        let sortedDates = dates.sorted { $0 > $1 }
        return sortedDates.compactMap { isoFormatter.string(from: $0)}
    }
}
