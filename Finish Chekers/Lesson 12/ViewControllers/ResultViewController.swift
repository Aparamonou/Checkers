//
//  ResultViewController.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 19.07.21.
//

import UIKit

class ResultViewController: UIViewController {
     @IBOutlet weak var tableViewResult: UITableView!
     @IBOutlet weak var backButton: UIButton!
     @IBOutlet weak var deleteButton: UIButton!     
     var games: [Game_Model] = []
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
     	getGame()
     	setTable () 
		localized ()
    }
     
     func localized ()  {
          backButton.setTitle("alert_button_back_memnu".localized, for: .normal)
          deleteButton.setTitle("label_delete_button".localized, for: .normal)
     }
     
     func setTable () {
          tableViewResult.dataSource = self
          tableViewResult.delegate = self
          tableViewResult.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil), forCellReuseIdentifier: "ResultCollectionViewCell")
     }
     
     func getGame() {
          let game = CoreDataManeger.shared.getGame()
          games = game
     }
     
     @IBAction func backMenu(_ sender: UIButton){
          navigationController?.popViewController( animated: true)
     }
     
     @IBAction func deleteResult(_ sender: UIButton){
          games = []
          CoreDataManeger.shared.deleteAllCoreData()
          tableViewResult.reloadData()
          
     }
}

extension ResultViewController: UITableViewDataSource {
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return games.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = tableViewResult.dequeueReusableCell(withIdentifier: "ResultCollectionViewCell") as? ResultCollectionViewCell else {return UITableViewCell()}
          cell.setForCell(array: games[indexPath.row])
          return cell 
     }
     
     
}

extension ResultViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 200
     }
}
