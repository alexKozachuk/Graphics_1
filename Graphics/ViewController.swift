//
//  ViewController.swift
//  Graphics
//
//  Created by Sasha on 05/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drawView: CartesianCoordinateSystemView!
    
    @IBOutlet weak var H: UITextField!
    @IBOutlet weak var R1: UITextField!
    @IBOutlet weak var R2: UITextField!
    @IBOutlet weak var slider: UISlider!
    
    var shape: DetailZeroShape {
        let h: CGFloat = CGFloat(Int(H.text!) ?? 100)
        let r1: CGFloat = CGFloat(Int(R1.text!) ?? 25)
        let r2: CGFloat = CGFloat(Int(R2.text!) ?? 35)
        let param = DetailZeroShape.Parameters(r1: r1, r2: r2, h: h)
        return DetailZeroShape(center: .zero, params: param)
    }

    // MARK: Keyboard methods
    
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
        
        H.delegate = self
        R1.delegate = self
        R2.delegate = self
        
        let shape = DetailZeroShape(center: .zero, params: DetailZeroShape.Parameters(r1: 20, r2: 35, h: 100))
        drawView.configure(shape:  shape, shouldDrawMarkers: false)
    }
    
    @IBAction func drawShape(_ sender: Any) {
        drawView.configure(shape:  shape, shouldDrawMarkers: false)
    }
    
    @IBAction func angleShape(_ sender: Any) {
        let angle = Int(slider.value)
        drawView.configure(shape: shape, shouldDrawMarkers: false, by: .degrees(angle), to: .zero + CGPoint(x: 10, y: 10))
    }

}


extension  ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    
}


