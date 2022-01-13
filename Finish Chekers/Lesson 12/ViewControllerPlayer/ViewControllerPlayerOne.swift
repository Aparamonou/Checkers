//
//  ViewControllerPlayerOne.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 31.08.21.
//

import UIKit

class ViewControllerPlayerOne: UIViewController, UITextFieldDelegate {
     @IBOutlet weak var  viewContent: UIView!
     @IBOutlet weak var  labelNameAlert: UILabel!
     @IBOutlet weak var  textFieldPlayerOne: UITextField!
     @IBOutlet weak var  textFieldPlayerTwo: UITextField!
     @IBOutlet weak var buttonEnterAlert: UIButton!
     @IBOutlet weak var buttonCancelAlert: UIButton!
     
     let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
     let fileManager = FileManager.default
     
     var names : [SaveName] = [SaveName(nameOne: "", nameTwo: "")]

     
    override func viewDidLoad() {
        super.viewDidLoad()
     
     localized () 
     textFieldPlayerOne.delegate = self
     textFieldPlayerTwo.delegate = self
     
     setShodow ()
     
     
     
     
    }
     
     func setShodow () {
          
          viewContent.layer.shadowOpacity = 1
          viewContent.layer.shadowOffset.height = 10
          viewContent.layer.shadowOffset.width = 10
          viewContent.layer.shadowRadius = 10
          viewContent.layer.shadowColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
     }
     
     func localized () {
          labelNameAlert.text = "label_name_alert".localized
          textFieldPlayerOne.placeholder = "textFieldPlayerOne_placeholder".localized
          textFieldPlayerTwo.placeholder = "textFieldPlayerTwo_placeholder".localized
          buttonEnterAlert.setTitle("button_Enter_Alert".localized, for: .normal)
          buttonCancelAlert.setTitle("button_Cancel_Alert".localized, for: .normal)
     }
	
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          guard !string.isEmpty else {return true}
          switch string {
          case "A"..."Z", "a"..."z", "А"..."Я", "а"..."я":
               return true
          default:
               return false
          }
     }
     
     func saveNames () {
          let data = try? NSKeyedArchiver.archivedData(withRootObject: names, requiringSecureCoding: true)
          let fileURL = documentDirectory.appendingPathComponent(Keys.namePlayers.rawValue)
          try? data?.write(to: fileURL)
     }
     
     @IBAction func buttonEnter(_ sender: UIButton) {
          guard let stringOne = textFieldPlayerOne.text,
                let stringTwo = textFieldPlayerTwo.text,
                stringOne != "" && stringTwo != "" else {
                     labelNameAlert.text = "label_name_alert_Error".localized
               labelNameAlert.textColor = .red
               return
               }
          
               labelNameAlert.text = "\(stringOne)  \(stringTwo)"
          
          names = [SaveName(nameOne: stringOne, nameTwo: stringTwo)]
          	saveNames ()
          
          self.navigationController?.pushViewController(getViewController("Main", nameViewController: "PlayViewController"), animated: true)
          
     }
     
     @IBAction func buttonCancel(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
     }
}
