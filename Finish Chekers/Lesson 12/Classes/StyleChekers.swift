//
//  StyleChekers.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 22.08.21.
//

import UIKit

class StyleCheker: NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
     
     var styleCheker: String?
     var position: Bool
     
     init(styleCheker: String?, position: Bool) {
          self.styleCheker = styleCheker
          self.position = position
     }
     
     func encode(with coder: NSCoder) {
          coder.encode(styleCheker, forKey: Keys.imageStyleChekers.rawValue)
          coder.encode(position, forKey: Keys.switchStyleChekers.rawValue)
     }
     
     required init?(coder: NSCoder) {
          self.styleCheker = coder.decodeObject(forKey: Keys.imageStyleChekers.rawValue) as? String
          self.position = coder.decodeBool(forKey: Keys.switchStyleChekers.rawValue)
     }
    
}
