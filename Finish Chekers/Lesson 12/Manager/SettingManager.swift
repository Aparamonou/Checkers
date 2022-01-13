//
//  SettingManager.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 3.10.21.
//

import UIKit

class SettingManager {
    static let shared = SettingManager()
     
     var currentLanguage: String {
          set {
               UserDefaults.standard.setValue(newValue, forKey: "currentLanguage")
          }
          get {
               UserDefaults.standard.string(forKey: "currentLanguage") ?? "en"
          }
     }
}
