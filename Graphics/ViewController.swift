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
    
    var shape: DetailShape {
        let h: CGFloat = CGFloat(Int(H.text!) ?? 100)
        let r1: CGFloat = CGFloat(Int(R1.text!) ?? 25)
        let r2: CGFloat = CGFloat(Int(R2.text!) ?? 35)
        let param = DetailShape.Parameters(r1: r1, r2: r2, h: h)
        return DetailShape(center: .zero, params: param)
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
        
        let shape = DetailShape(center: .zero, params: DetailShape.Parameters(r1: 20, r2: 35, h: 100))
        let rect = drawView.layer.visibleRect
        let min = CGPoint(x: rect.minX, y: rect.minY)
        let max = CGPoint(x: rect.maxY, y: rect.maxY)
        let grid = GridShape(params: GridShape.Parameters(min: min, max: max, division: 10))
        drawView.configure(shape: shape, grid: grid)
    }
    
    @IBAction func drawShape(_ sender: Any) {
        let rect = drawView.layer.visibleRect
        let min = CGPoint(x: rect.minX, y: rect.minY)
        let max = CGPoint(x: rect.maxY, y: rect.maxY)
        let grid = GridShape(params: GridShape.Parameters(min: min, max: max, division: 10))
        drawView.configure(shape: shape, grid: grid)
    }
    
    @IBAction func angleShape(_ sender: Any) {
        /*let angle = Int(slider.value)
        drawView.configure(shape: shape, shouldDrawMarkers: false, by: .degrees(angle), to: .zero + CGPoint(x: 10, y: 10))*/
    }
    
    @IBAction func affineTapped(_ sender: Any) {
        drawView.affine()
    }
    
    @IBAction func proectTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Proect", message: "введіть вагу точок", preferredStyle: .alert)

      
        alert.addTextField { (textField) in
            textField.placeholder = "w0"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "wx"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "wy"
        }

       
        alert.addAction(UIAlertAction(title: "Draw", style: .default, handler: { [weak alert] (_) in
            guard let textFieldW0 = alert?.textFields?[0] else { return }
            guard let textFieldWX = alert?.textFields?[1] else { return }
            guard let textFieldWY = alert?.textFields?[2] else { return }
            guard let w0text = textFieldW0.text else { return }
            guard let wxtext = textFieldWX.text else { return }
            guard let wytext = textFieldWY.text else { return }
            guard let w0 = Float(w0text) else { return }
            guard let wx = Float(wxtext) else { return }
            guard let wy = Float(wytext) else { return }
            
            self.drawView.affineW(w0: CGFloat(w0), wx: CGFloat(wx), wy: CGFloat(wy))
        }))

        self.present(alert, animated: true, completion: nil)
    }

}


extension  ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    
}


