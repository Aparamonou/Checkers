//
//  PlayersName .swift
//  Lesson 12
//
//  Created by Alex Paramonov on 1.09.21.
//

import UIKit

class PlayersName:  NSObject, NSCoding, NSSecureCoding {
     static var supportsSecureCoding: Bool = true
     
     var namePlayerOne: String?
//     var namePlayerTwo: String?
     
     init(namePlayerOne: String?) {
          self.namePlayerOne = namePlayerOne
     }
     
     
     func encode(with coder: NSCoder) {
          coder.encode(namePlayerOne, forKey: Keys.namePlayerOne.rawValue)
//          coder.encode(namePlayerTwo, forKey: Keys.namePlayerTwo.rawValue)
         
     }
     
     required init?(coder: NSCoder) {
          self.namePlayerOne = coder.decodeObject(forKey: Keys.namePlayerOne.rawValue) as? String
//          self.namePlayerTwo = coder.decodeObject(forKey: Keys.namePlayerTwo.rawValue) as? String
     }
}
