//
//  Localized .swift
//  Lesson 12
//
//  Created by Alex Paramonov on 3.10.21.
//

import UIKit



extension String {
     var localized: String {
          guard let languagePath = Bundle.main.path(forResource: SettingManager.shared.currentLanguage, ofType: "lproj"), let lenguageBundle = Bundle(path: languagePath) else {return self }
          
          return NSLocalizedString(self, bundle: lenguageBundle, value: "", comment: "")
     }
  
}
