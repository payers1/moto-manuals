//
//  AppDelegate.swift
//  MotoManuals
//
//  Created by Phillip Ayers on 8/21/18.
//  Copyright © 2018 Phillip Ayers. All rights reserved.
//

import UIKit
let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    return true
  }
}

