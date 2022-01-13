//
//  Players_Model.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 6.10.21.
//

import UIKit

class Players_Model{
	var name_player1: String?
	var name_player2: String?
	var won: String?
	var color_cheker_player2: String?
	var color_cheker_player1: String?
	var game: Game?
     
     init(name_player1: String?, name_player2: String?, won: String?, color_cheker_player2: String?,color_cheker_player1: String?  ) {
          
          self.name_player1 = name_player1
          self.name_player2 = name_player2
          self.won = won
          self.color_cheker_player1 = color_cheker_player1
          self.color_cheker_player2 = color_cheker_player2
     }
}
