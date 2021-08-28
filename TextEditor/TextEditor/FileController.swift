//
//  FileManager.swift
//  TextEditor
//
//  Created by Serega on 10.07.2021.
//

import Foundation
import  SwiftUI
extension String {
    func isEmpty() -> Bool {
        
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}
class FileController {
    public static func save(text: String,
                      withFileName fileName: String) {
        let directory = NSTemporaryDirectory() + fileName + ".txt"
        do {
            try text.write(toFile: directory, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    return
                }
    }
    public static func delete(name: String) {
        do {
            try FileManager.default.removeItem(atPath: NSTemporaryDirectory() + name + ".txt")
        } catch  {
        
        }
    }
    public static func ExistsInRecents(fileName: String) -> Bool {
        var names: [String] = []
        for  recent in Preferences.recents {
            names.append(recent.name)
        }
        return names.contains(fileName) || fileName.isEmpty()
    }
    public static func Exists(fileName: String) -> Bool {
        let directory = NSTemporaryDirectory() + fileName + ".txt"
        return FileManager.default.fileExists(atPath: directory)
    }
    public static func read(fromDocumentsWithFileName fileName: String) -> String {
        let directory = NSTemporaryDirectory() + fileName + ".txt"
        do {
            let savedString = try String(contentsOfFile: directory)
            return savedString
        } catch {
            return ""
        }
    }
    public static func rename(oldName: String, newName: String, fileText: String) {
             delete(name: oldName)
                save(text: fileText, withFileName: newName)
    }
}
