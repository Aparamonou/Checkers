//
//  SettingViewController.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 13.09.21.
//

import UIKit


enum Language: Int {
     case english = 0
     case russian = 1
}
class SettingViewController: UIViewController {
     
     @IBOutlet weak var buttunAboutHistory: UIButton!
     @IBOutlet weak var chooseTheme: UIButton!
     @IBOutlet weak var collectionView: UICollectionView!
     @IBOutlet weak var themeView: UIView!
     @IBOutlet weak var lableLanguage: UILabel!
     @IBOutlet weak var labelStyleChekers: UILabel!
     @IBOutlet weak var buttonUploadBackground: UILabel!

     @IBOutlet weak var languageSegment: UISegmentedControl!
     
     let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
     let fileManager = FileManager.default
     let picker = UIImagePickerController()
     var styleChekers: [StyleCheker] = [ StyleCheker(styleCheker: "3", position: false),
                                          StyleCheker(styleCheker: "4", position: false),
                                          StyleCheker(styleCheker: "5", position: false)]
   
     
     let languageSet: [String] = ["en", "ru"]
     
     var currentLanguage: Language = .english {
          didSet {
               switch self.currentLanguage {
               case .english:
                    SettingManager.shared.currentLanguage = "en"
                    title = "Settings"
               case .russian:
                    SettingManager.shared.currentLanguage = "ru"
                    title = "Настройки"
               }
               localized ()
          }
     }
  
     
     
     override func viewDidLoad() {
        super.viewDidLoad()
          
          chooseTheme.setTitle("", for: .normal)
          
          if let indexCode = languageSet.firstIndex(of: SettingManager.shared.currentLanguage) {
               languageSegment.selectedSegmentIndex = indexCode
               currentLanguage = Language(rawValue: indexCode) ?? .english
          }
               
          picker.delegate = self
          setGesture ()
          setCollectionView()
          getDataSave ()
    }
     
     override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.navigationController?.navigationBar.isHidden = false
     }
     
     override func viewWillDisappear(_ animated: Bool) {
          super.viewDidDisappear(animated)
          saveData ()
          self.navigationController?.navigationBar.isHidden = true
     }
     
     private func setCollectionView () {
          collectionView.dataSource = self
          collectionView.delegate = self
          collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
          
          title = "Settings"
          buttunAboutHistory.layer.cornerRadius = buttunAboutHistory.frame.size.width / 12
          
          
     }

     
     func saveData () {
          let data = try? NSKeyedArchiver.archivedData(withRootObject: styleChekers, requiringSecureCoding: true)
          let fileURL = documentDirectory.appendingPathComponent(Keys.styleChekers.rawValue)
          try? data?.write(to: fileURL)
     }
     
     func getDataSave () {
          let fileURL = documentDirectory.appendingPathComponent(Keys.styleChekers.rawValue)
          guard let data  = FileManager.default.contents(atPath: fileURL.absoluteString.replacingOccurrences(of: "file://", with: "")) else {return}
          
          guard let newObject = try?  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [StyleCheker] else {return}
          self.styleChekers = newObject
          
     }
     func setGesture () {
          let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longGesture(_ :)))
          longGesture.minimumPressDuration = 0.3
          longGesture.delegate = self
          themeView.addGestureRecognizer(longGesture)
     }
     
     func localized () {
          buttunAboutHistory.setTitle("button_Cheker_History".localized, for: .normal)
          lableLanguage.text = "lable_Language".localized
          labelStyleChekers.text = 	"label_Style_Chekers".localized
          buttonUploadBackground.text = "button_Upload_Background".localized
     }
     
     @objc func longGesture(_ sender: UILongPressGestureRecognizer) {
          switch sender.state {
          case .began:
                    UIView.animate(withDuration: 0.3) {
                         sender.view?.transform = (sender.view?.transform.scaledBy(x: 0.9, y: 0.9))!
                         self.themeView.layer.borderWidth = 4
                         self.themeView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
                    }
          
           case .ended:
               UIView.animate(withDuration: 0.3) {
                    sender.view?.transform = .identity
               }
          self.themeView.layer.borderWidth = 0
          picker.sourceType = .photoLibrary
          present(picker, animated: true, completion: nil)
     
          default:
               break
          
     }
}
     
     @IBAction func activitybuttunAboutHistory (_ sender: UIButton) {
          self.navigationController?.pushViewController(getViewController("Main", nameViewController: "HistoryChekersViewController"), animated: true)
     }
     @IBAction func chooseTheme (_ sender: UIButton) {
          present(picker, animated: true, completion: nil)
     }

     @IBAction func didChangeSegmentControl(_ sender: UISegmentedControl) {
          guard let selectedLanguage = Language(rawValue: sender.selectedSegmentIndex), selectedLanguage != currentLanguage  else {return }
          currentLanguage = selectedLanguage
     }
}

extension SettingViewController: UICollectionViewDataSource {
     
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return styleChekers.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
                     return UICollectionViewCell()
          }
          cell.switchStyleChekers.tag = indexPath.item
          cell.setImageChekers(value: styleChekers[indexPath.item])
          cell.delegate = self
          return cell
     }
}


extension SettingViewController: UICollectionViewDelegateFlowLayout  {
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
             return CGSize(width: 150, height: 100)
     }
}

extension SettingViewController: CollectionViewCellDelegate {
     func switchSet(_ sender: UISwitch) {
          for value in 0..<styleChekers.count{
               styleChekers[value].position = value == sender.tag
          }
          collectionView.reloadData()
          
     }
     
     
}
extension SettingViewController: UIGestureRecognizerDelegate {
     
          func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
          
          return true
          }
}

extension SettingViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          guard let image = info[.originalImage] as? UIImage else {return}
          
          let data = image.pngData()
          let fileURL = documentDirectory.appendingPathComponent(Keys.styleBackground.rawValue)
          try? data?.write(to: fileURL)
          dismiss(animated: true, completion: nil)
     }
     
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
          picker.dismiss(animated: true, completion: nil)
     }
}

