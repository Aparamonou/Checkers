//
//  CoreDataManager.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 5.10.21.
//

import UIKit
import CoreData

class CoreDataManeger {
     static let shared = CoreDataManeger()
     
     lazy var persistentContainer: NSPersistentContainer = {
          
         let container = NSPersistentContainer(name: "ChekersCoreData")
         container.loadPersistentStores(completionHandler: { (storeDescription, error) in
             if let error = error as NSError? {
          
                 fatalError("Unresolved error \(error), \(error.userInfo)")
             }
         })
         return container
     }()
     
     func saveContext () {
         let context = persistentContainer.viewContext
         if context.hasChanges {
             do {
                 try context.save()
             } catch {

                 let nserror = error as NSError
                 fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
             }
         }
     }
     
     func getGame() -> [Game_Model] {
          var arrGame: [Game_Model] = []
          
          do {
               let games = try  persistentContainer.viewContext.fetch(Game.fetchRequest())
               games.forEach { game in
                    arrGame.append(Game_Model(game: game))
               }
          } catch {
          	}
          return arrGame
}
     
	func saveGame(by game: Game_Model)  {
          
		let gameCD = Game(context: persistentContainer.viewContext)
		gameCD.game_date = game.game_date
		gameCD.game_time = game.game_time
		game.players?.forEach({ players in
			let playersCD = Players(context: persistentContainer.viewContext)
     		playersCD.convertPlayers(by: players)
     		gameCD.addToPlayers(playersCD)
		})
         persistentContainer.viewContext.insert(gameCD)
         saveContext()
	}
     
     func deleteAllCoreData () {
          do {
               let games = try  persistentContainer.viewContext.fetch(Game.fetchRequest())
               games.forEach { game in
                         persistentContainer.viewContext.delete(game)
                         saveContext()
               }
          } catch  {
          }
     }

}
