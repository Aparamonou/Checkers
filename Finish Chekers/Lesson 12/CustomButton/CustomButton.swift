//
//  CustomButton.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 24.08.21.
//

import UIKit

protocol CustomButtonDelegate: AnyObject {
     func actionButton(_ sender: CustomButton)
}

@IBDesignable
class CustomButton: UIView {

     @IBOutlet var contentView: UIView!
     @IBOutlet weak var customLabel: UILabel!
     
     @IBInspectable  var text: String {
          set { self.customLabel.text = newValue }
          get { return self.customLabel.text ?? "Button" }
     }
    
     @IBInspectable  var textColor: UIColor {
          set { self.customLabel.textColor = newValue }
          get { return self.customLabel.textColor }
     }
     @IBInspectable  var textShodow: UIColor {
          set { self.customLabel.shadowColor = newValue }
          get { return self.customLabel.shadowColor ?? .white }
     }
     
     @IBInspectable  var cornerRadius: CGFloat {
          set { self.layer.cornerRadius = newValue }
          get { return self.cornerRadius}
     }
     
     @IBInspectable  var shadowRadius: CGFloat {
          set { self.layer.shadowRadius = newValue }
          get { return  self.layer.shadowRadius}
     }
     
     @IBInspectable  var shadowOpacity: Float {
          set { self.layer.shadowOpacity = newValue }
          get { return  self.layer.shadowOpacity}
     }
     
     @IBInspectable  var shadowOffset: CGSize {
          set { self.layer.shadowOffset = newValue }
          get { return  self.layer.shadowOffset}
     }
    
     @IBInspectable  var shadowColor: UIColor {
          set { self.layer.shadowColor = newValue.cgColor }
          get { if let  cgColor =  self.layer.shadowColor {
               return UIColor(cgColor: cgColor)
               }
          	return .clear
          }
     }
     
     
     @IBInspectable  var borderWith: CGFloat {
          set { self.layer.borderWidth = newValue }
          get { return self.layer.borderWidth}
     }
     
     @IBInspectable  var borderColor: UIColor {
          set { self.layer.borderColor = newValue.cgColor}
          get { if let  cgColor = self.layer.borderColor {
               return UIColor(cgColor: cgColor)
        	  }
          	return .clear
               }
     }
     
     
   
    
     weak var delegeta: CustomButtonDelegate?     
     override init(frame: CGRect) {
          super.init(frame: frame)
          setup()
     }
     
     required init?(coder: NSCoder) {
          super.init(coder: coder)
          setup()
     }
     
     
     
     private func setup() {
          Bundle(for: CustomButton.self).loadNibNamed("CustomButton", owner: self, options: nil)
          
          contentView.frame = self.bounds
          self.addSubview(contentView)
     }

     @IBAction func tapButton(_ sender: UIButton) {
          
          delegeta?.actionButton(self)
     }
}

