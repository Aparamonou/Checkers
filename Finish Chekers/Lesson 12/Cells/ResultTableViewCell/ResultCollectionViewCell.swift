//
//  ResultCollectionViewCell.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 7.10.21.
//

import UIKit

class ResultCollectionViewCell: UITableViewCell {
     @IBOutlet weak var view: UIView!
     
     @IBOutlet weak var LabelWon: UILabel!
     @IBOutlet weak var labelColorChekerPlayerTwo: UILabel!
     @IBOutlet weak var labelColorChekerPlayerOne: UILabel!
     @IBOutlet weak var labelPlayerTwo: UILabel!
     @IBOutlet weak var labelPlayerOne: UILabel!
     @IBOutlet weak var labelGameTime: UILabel!
     @IBOutlet weak var labelDate: UILabel!
     
     
     let dateFormater = DateFormatter()
     var countSec = ""
     var countMin = ""
     override func awakeFromNib() {
        super.awakeFromNib()
    }
     
     func setForCell (array : Game_Model) {
         
     	dateFormater.dateFormat = "dd.MM.yy"
     	
          let time = array.game_time
          
          countMin = time > 60 ? String(time/60) : "0"
          countSec = time < 60 ? String(time) : "0"
		
          let players = array.players ?? []
          guard !players.isEmpty else {return}
          
          guard let date = array.game_date else {return}
          
          if SettingManager.shared.currentLanguage == "en" {
          self.labelDate.text = "Game date \(dateFormater.string(from: date))"
          self.labelGameTime.text = "Game time \(countMin) min"
          
          
          
          self.labelPlayerOne.text  = "Player 1 -\(players[0].name_player1 ?? "") "
          self.labelPlayerTwo.text = "Player 2 -\(players[0].name_player2 ?? "" ) "
          self.labelColorChekerPlayerOne.text = "Color cheker : \(players[0].color_cheker_player1 ?? "")"
          self.labelColorChekerPlayerTwo.text = "Color cheker : \(players[0].color_cheker_player2 ?? "")"
          self.LabelWon.text = "Won \(players[0].won ?? "")"
               
          } else {
               self.labelDate.text = "Дата игры \(dateFormater.string(from: date))"
               self.labelGameTime.text = "Время игры \(countMin) min"
               
               
               
               self.labelPlayerOne.text  = "Игрок -\(players[0].name_player1 ?? "") "
               self.labelPlayerTwo.text = "Игрок -\(players[0].name_player2 ?? "" ) "
               self.labelColorChekerPlayerOne.text = "Цвет шашек : \(players[0].color_cheker_player1 ?? "")"
               self.labelColorChekerPlayerTwo.text = "Цвет шашек : \(players[0].color_cheker_player2 ?? "")"
               self.LabelWon.text = "Победил \(players[0].won ?? "")"
               
          }
     }

}
