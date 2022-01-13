//
//  Game+CoreDataProperties.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 6.10.21.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var game_time: Int64
    @NSManaged public var game_date: Date?
    @NSManaged public var players: NSSet?

}

// MARK: Generated accessors for players
extension Game {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Players)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Players)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}

extension Game : Identifiable {

}
