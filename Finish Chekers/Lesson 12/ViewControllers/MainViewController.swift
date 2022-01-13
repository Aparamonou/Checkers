//
//  MainViewController.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 19.07.21.
//

import UIKit

class MainViewController: UIViewController {
     
     @IBOutlet weak var playButton: CustomButton!
     @IBOutlet weak var resultButton: CustomButton!
     @IBOutlet weak var settingsButton: CustomButton!
     
     let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
     let fileManager = FileManager.default
    
     

     override func viewDidLoad() {
        super.viewDidLoad()
		
          playButton.delegeta = self 
          resultButton.delegeta = self
          settingsButton.delegeta = self
          
          localized ()
          
          let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longGesture(_ :)))
          longGesture.minimumPressDuration = 0.3
          longGesture.delegate = self
          playButton.addGestureRecognizer(longGesture)
          
     }
     
     override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(true)
          localized ()
          
     }
     
     
     func localized () {
          
          playButton.text = "custom_button_play".localized
          resultButton.text = "custom_button_settings".localized
          settingsButton.text = "custom_button_result".localized
     }
     
     @objc func longGesture(_ sender: UILongPressGestureRecognizer) {
          switch sender.state {
          case .began:
                    UIView.animate(withDuration: 0.3) {
                         sender.view?.transform = (sender.view?.transform.scaledBy(x: 0.9, y: 0.9))!
                         self.playButton.layer.borderWidth = 4

                    }
                         
           case .ended:

                    UIView.animate(withDuration: 0.3) {
                         sender.view?.transform = .identity
                    }
               self.playButton.layer.borderWidth = 0
               if !fileManager.fileExists(atPath: documentDirectory.appendingPathComponent(Keys.cellAndChekers.rawValue).path){
                    self.navigationController?.pushViewController(self.getViewController("ViewControllerPlayerOne", nameViewController: "ViewControllerPlayerOne"), animated: true)
                    
               } else {
                    pushAlert(with: nil, message: "continue_the_game".localized,
                              prefferedStyle: .alert,
                              action: UIAlertAction(title: "button_new_game".localized,
                                                       style: .default,
                                                       handler: { _ in
                                                                 
                                                         try? self.fileManager.removeItem(at: self.documentDirectory.appendingPathComponent(Keys.cellAndChekers.rawValue))
                                                         
                                                         self.navigationController?.pushViewController(self.getViewController("ViewControllerPlayerOne", nameViewController: "ViewControllerPlayerOne"), animated: true)}),
                                 
                              UIAlertAction(title: "button_resume_game".localized,
                                                       style: .default,
                                                       handler: { _ in
                                                        self.navigationController?.pushViewController(self.getViewController("Main", nameViewController: "PlayViewController"), animated: true)}))
               }
             
               default:
                    break
               
          }
     }
     
     
     
     
    
     @IBAction func goViewPlay (_ sender: UIButton) {
          
     }
     
     @IBAction func goViewSetting (_ sender: UIButton) {
          self.navigationController?.pushViewController(getViewController("Main", nameViewController: "SettingViewController"), animated: true)
     }
     
     @IBAction func goViewResult (_ sender: UIButton) {
          self.navigationController?.pushViewController(getViewController("Main", nameViewController: "ResultViewController"), animated: true)
     }
}


extension MainViewController: CustomButtonDelegate {
     func actionButton(_ sender: CustomButton) {
          if sender.tag == 0 {
          if !fileManager.fileExists(atPath: documentDirectory.appendingPathComponent(Keys.cellAndChekers.rawValue).path){
               self.navigationController?.pushViewController(self.getViewController("ViewControllerPlayerOne", nameViewController: "ViewControllerPlayerOne"), animated: true)
               
          } else {
                    pushAlert(with: nil, message: "continue_the_game".localized, prefferedStyle: .alert,
                              action: UIAlertAction(title: "button_new_game".localized,
                                                  style: .default,
                                                  handler: { _ in
                                                            
                                                    try? self.fileManager.removeItem(at: self.documentDirectory.appendingPathComponent(Keys.cellAndChekers.rawValue))
                                                    
                                                    self.navigationController?.pushViewController(self.getViewController("ViewControllerPlayerOne", nameViewController: "ViewControllerPlayerOne"), animated: true)}),
                            
                                      UIAlertAction(title: "button_resume_game".localized,
                                                  style: .default,
                                                  handler: { _ in
                                                    self.navigationController?.pushViewController(self.getViewController("Main", nameViewController: "PlayViewController"), animated: true)}))
     	}
          
     	} else {
          	if sender.tag == 1 {
               self.navigationController?.pushViewController(getViewController("Main", nameViewController: "ResultViewController"), animated: true)
              } else {
               self.navigationController?.pushViewController(getViewController("Main", nameViewController: "SettingViewController"), animated: true)
              	}
          }
	}
}

extension MainViewController: UIGestureRecognizerDelegate {
     
          func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
          
          return true
          }
}

