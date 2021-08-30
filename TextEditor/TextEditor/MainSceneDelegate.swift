//
//  MainSceneDelegate.swift
//  MainSceneDelegate
//
//  Created by Serega on 23.08.2021.
//
import UIKit
final class MainSceneDelegate: UIResponder, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if connectionOptions.shortcutItem != nil{
            Preferences.openNewFileEditingView = true
        }
    }
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        Preferences.openNewFileEditingView = true
    }
}
