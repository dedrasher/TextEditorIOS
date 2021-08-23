//
//  MainSceneDelegate.swift
//  MainSceneDelegate
//
//  Created by Serega on 23.08.2021.
//
import SwiftUI
import UIKit

final class MainSceneDelegate: UIResponder, UIWindowSceneDelegate {
  @Environment(\.openURL) private var openURL: OpenURLAction
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionptions: UIScene.ConnectionOptions
  ) {
      if connectionptions.shortcutItem != nil {
      Preferences.setCreateNewFile(value: true)
      }
  }
  
  
}
