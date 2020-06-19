//
//  SceneDelegate.swift
//  Diagrams
//
//  Created by Ihor Pedan on 24.12.2019.
//  Copyright © 2019 Ihor Pedan. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    // Use a UIHostingController as window root view controller.
    if let windowScene = scene as? UIWindowScene {
      let coordinator = OverlayCoordinator.shared
      let viewModel = MainViewModel(repositoriesService: RepositoriesService(),
                                    articlesService: ArticlesService())
      let contentView = MainView().environmentObject(viewModel)
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(rootView: contentView)
      coordinator.mainWindow = window
      window.makeKeyAndVisible()
      
      let summaryView = SummaryView().environmentObject(viewModel)
      let summaryWindow = UIWindow(windowScene: windowScene)
      let overlayVC = UIHostingController(rootView: summaryView)
      summaryWindow.rootViewController = overlayVC
      overlayVC.view.backgroundColor = .clear
      summaryWindow.windowLevel = .alert + 1
      coordinator.overlayWindow = summaryWindow
    }
  }
}

