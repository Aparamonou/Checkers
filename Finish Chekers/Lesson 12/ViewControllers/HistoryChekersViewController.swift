//
//  HistoryChekersViewController.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 31.07.21.
//

import UIKit

class HistoryChekersViewController: UIViewController {
     @IBOutlet weak var labelHistoryChekers: UILabel!
     @IBOutlet weak var labelHistoryOne: UILabel!
     @IBOutlet weak var labelHistoryTwo: UILabel!
     
     override func viewDidLoad() {
        super.viewDidLoad()
    }
    
     override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.navigationController?.navigationBar.isHidden = false
          localized () 
     }


     
     func localized () {
          labelHistoryChekers.text = "label_history_cheker".localized
          labelHistoryOne.text = "label_text_one".localized
          labelHistoryTwo.text = "label_text_two".localized
     }
}
