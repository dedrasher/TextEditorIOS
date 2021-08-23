//
//  Preferences.swift
//  TextEditor
//
//  Created by Serega on 09.07.2021.
//

import Foundation
class Preferences {
    public static var recents : [TextFile] = []
    static var createNewFileKey = "CREATE_NEW_FILE_VALUE"
    static var recentsKey = "RECENTS_VALUE"
    public static func loadRecents() {
        var recents: [TextFile] = []
        let recentsSource = UserDefaults.standard.array(forKey: recentsKey) ?? []
        if recentsSource.count > 0 {
        for i in 0..<recentsSource.count {
            let file = try! JSONDecoder().decode(TextFile.self, from: recentsSource[i] as! Data)
            if(FileController.Exists(fileName: file.name)) {
                recents.append(file)
        }
        }
    }
        self.recents = recents
    }
    public static func setCreateNewFile(value: Bool) {
        UserDefaults.standard.set(value, forKey: createNewFileKey)
    }
    public static func getCreateNewFile() -> Bool {
       return UserDefaults.standard.bool(forKey: createNewFileKey)
    }
    public static func saveRecents() {
        var recentsSource: [Data] = []
        for recent in recents {
            recentsSource.append(try! JSONEncoder().encode(recent))
               }
        UserDefaults.standard.set(recentsSource, forKey: recentsKey)
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
        return sortedDates.compactMap { isoFormatter.string(from: $0)}.removingDuplicates()
    }
}
