//
//  Chekers.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 17.08.21.
//

import UIKit

class Checker: NSObject, NSCoding, NSSecureCoding {
     static var supportsSecureCoding: Bool = true
     
     var tagCell: Int
     var tagCheker: Int
     var queen: Bool
     
     init(tagCell: Int, tagCheker: Int, queen: Bool) {
          self.tagCell = tagCell
          self.tagCheker = tagCheker
          self.queen = queen
     }
     
     func encode(with coder: NSCoder) {
          coder.encode(tagCell, forKey: Keys.tagCell.rawValue)
          coder.encode(tagCheker, forKey: Keys.tagCheker.rawValue)
          coder.encode(queen, forKey: Keys.queen.rawValue)
     }
     
     required init?(coder: NSCoder) {
          self.tagCell = coder.decodeInteger(forKey: Keys.tagCell.rawValue)
          self.tagCheker = coder.decodeInteger(forKey: Keys.tagCheker.rawValue)
          self.queen = coder.decodeBool(forKey: Keys.queen.rawValue)
     
}

}
