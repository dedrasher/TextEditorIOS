//
//  TextEditorApp.swift
//  TextEditor
//
//  Created by Serega on 09.07.2021.
//

import SwiftUI
import UIKit
@main
struct TextEditorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
