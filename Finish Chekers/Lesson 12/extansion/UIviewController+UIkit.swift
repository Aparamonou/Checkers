//
//  Extantion+UIkit.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 31.07.21.
//

import UIKit

extension UIViewController {
     
     func getViewController( _ idStoryBoard: String, nameViewController: String) -> UIViewController {
          
          let storyBoard = UIStoryboard(name: idStoryBoard, bundle: nil)
          let currentStory = storyBoard.instantiateViewController(withIdentifier: nameViewController)
          currentStory.modalTransitionStyle = .crossDissolve
          currentStory.modalPresentationStyle = .fullScreen
          return currentStory
     }
     
@discardableResult
     func pushAlert(with title: String?, message: String?, prefferedStyle: UIAlertController.Style = .alert, action: UIAlertAction...) -> UIAlertController {
          let alert = UIAlertController(title: title, message: message, preferredStyle: prefferedStyle)
          action.forEach { alert.addAction($0) }
          present(alert, animated: true, completion: nil)
          return alert
	}
}
