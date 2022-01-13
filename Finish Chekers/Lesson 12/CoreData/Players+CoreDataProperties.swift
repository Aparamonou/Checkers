//
//  Players+CoreDataProperties.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 6.10.21.
//
//

import Foundation
import CoreData


extension Players {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Players> {
        return NSFetchRequest<Players>(entityName: "Players")
    }

    @NSManaged public var name_player1: String?
    @NSManaged public var name_player2: String?
    @NSManaged public var won: String?
    @NSManaged public var color_cheker_player2: String?
    @NSManaged public var color_cheker_player1: String?
    @NSManaged public var game: Game?
     
     func convertPlayers( by players: Players_Model) {
     
          self.name_player1 = players.name_player1
          self.name_player2 = players.name_player2
          self.color_cheker_player1 = players.color_cheker_player1
          self.color_cheker_player2 = players.color_cheker_player2
          self.won = players.won
     }

}

extension Players : Identifiable {

}
