//
//  Game_Model.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 6.10.21.
//

import UIKit

class Game_Model {
	
	var game_time: Int64
 	var game_date: Date?
	var players: [Players_Model]? 
     
     init(game_time: Int64, game_date: Date? , players: [Players_Model]) {
          self.game_time = game_time
          self.game_date = game_date
          self.players = players
     }
     
     init(game: Game) {
          self.game_time = game.game_time
          self.game_date = game.game_date
          self.players = game.players?.allObjects.compactMap({ value -> Players_Model in
               let value = value as! Players
               return Players_Model(name_player1: value.name_player1,
                                    name_player2: value.name_player2,
                                    won: value.won,
                                    color_cheker_player2: value.color_cheker_player2,
                                    color_cheker_player1: value.color_cheker_player1)
          })
     }
}
