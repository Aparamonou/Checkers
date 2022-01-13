//
//  CollectionViewCell.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 18.08.21.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
     func switchSet (_ sender: UISwitch)
}

class CollectionViewCell: UICollectionViewCell{
     @IBOutlet weak var imageStyleChekers: UIImageView!
     @IBOutlet weak var switchStyleChekers: UISwitch!
     @IBOutlet weak var viewContent: UIView!
     
     weak var delegate: CollectionViewCellDelegate?
    
     override func awakeFromNib() {
        super.awakeFromNib()
          viewContent.layer.shadowOffset = CGSize(width: 5, height: 5)
          viewContent.layer.shadowRadius = 2
          viewContent.layer.shadowColor = UIColor(displayP3Red: 26/255, green: 26/255, blue: 26/255, alpha: 1).cgColor
          
          
          
     }
     
     
     
     func setImageChekers (value: StyleCheker) {
          imageStyleChekers.image = UIImage(named: value.styleCheker ?? "2")
          switchStyleChekers.isOn = value.position
          
     }
     
     override func prepareForReuse() {
          imageStyleChekers.image = nil 
     }
  
     
     
     @IBAction func setSwitch(_ sender: UISwitch){
          delegate?.switchSet(switchStyleChekers)
     
     }
     
}
