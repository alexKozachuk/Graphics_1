//
//  ViewController.swift
//  Graphics
//
//  Created by Sasha on 05/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var firstRadiusTextField: UITextField!
    @IBOutlet weak var secondRadiusTextField: UITextField!
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    let basicSplit: CGFloat = 20
    

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        
        lengthTextField.delegate = self
        firstRadiusTextField.delegate = self
        secondRadiusTextField.delegate = self
        
        drawView.setSplit(split: basicSplit)
        splitLabel.text = "Ціна поділки: \(Int(drawView.split))"
    }
    
    @IBAction func drawShape(_ sender: Any) {
        let value = CGFloat(slider.value)
        
        let length: CGFloat = CGFloat(Int(lengthTextField.text!) ?? 100) + value
        let firstRadius: CGFloat = CGFloat(Int(firstRadiusTextField.text!) ?? 25) + value
        let secondRadius: CGFloat = CGFloat(Int(secondRadiusTextField.text!) ?? 35) + value
        drawView.drawDetail(length: length, firstRadius: firstRadius, secondRadius: secondRadius)
    }

}


extension  ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    
}


