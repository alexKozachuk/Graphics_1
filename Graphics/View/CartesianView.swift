//
//  CartesianView.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
class CartesianCoordinateSystemView: UIView {

    @IBInspectable var originalDivisionSize: CGFloat = 10 {
        didSet {
           divisionSize = min(max(originalDivisionSize * scale, 15), 400)
        }
    }
    
    @IBOutlet weak var divisionValueLabel: UILabel!
        
    private var scale: CGFloat = 1
    private var divisionSize: CGFloat = 10
        
    var shape: Shape?
    var defaultShape: Shape?


    var shouldDrawMarkers = true
        
    override func draw(_ rect: CGRect) {
        
        drawGrid(in: rect, division: divisionSize)
        drawAxes(in: rect)
        drawShapeIfNeeded(in: rect)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
        updateDivisionLabelText()
        //setupPinchGesture()
    }
    
    func configure(shape: Shape, shouldDrawMarkers: Bool, by angle: Angle = .degrees(0),  to point: CGPoint = .zero) {
        self.shape = shape
        
        guard let shape = self.shape else { return }
        var modifyShape = ModifiyShape(lines: shape.rotate(by: angle))
        modifyShape = ModifiyShape(lines: modifyShape.moveTo(point: point))
        
        self.shape = modifyShape
        setNeedsDisplay()
        
        self.shouldDrawMarkers = shouldDrawMarkers
    }
    
//    func rotate(by angle: Angle) {
//
//        modifyShape = ModifiyShape(lines: defaultShape.rotate(by: angle))
//        self.shape = modifyShape
//        setNeedsDisplay()
//    }
//    
//    func moveTo(point: CGPoint) {
//        guard let modifyShape = modifyShapedefaultShape else { return }
//    }
//    
    func setupPinchGesture() {
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchRecongnized(pinch:)))
        addGestureRecognizer(pinchRecognizer)
    }
    
    @IBAction func pinchRecongnized(pinch: UIPinchGestureRecognizer) {
        guard pinch.state != .began else {
            return
        }

        scale += pinch.velocity / 10
        scale = max(min(scale, 20), 0.2)
        
        let wrappedSize = min(max(originalDivisionSize * scale, 15), 400)
        
        divisionSize = wrappedSize
        
        updateDivisionLabelText()
        setNeedsDisplay()
    }
    
    private func updateDivisionLabelText() {
        
        divisionValueLabel.text = String(format: "Ціна поділки %.1f pt", divisionSize)
    }
    
    private func drawAxes(in rect: CGRect) {
        let centerPoint = rect.center
        
        let xAxisPath = UIBezierPath()
        xAxisPath.moveTo(x: centerPoint.x, y: rect.minY)
        xAxisPath.lineTo(x: centerPoint.x, y: rect.maxY)
        
        let yAxisPath = UIBezierPath()
        yAxisPath.moveTo(x: rect.minX, y: centerPoint.y)
        yAxisPath.lineTo(x: rect.maxX, y: centerPoint.y)
        
        UIColor.black.set()
        
        xAxisPath.lineWidth = 1
        xAxisPath.stroke()
        
        yAxisPath.lineWidth = 1
        yAxisPath.stroke()
    }
    
    private func drawGrid(in rect: CGRect, division: CGFloat) {
        
        let gridPath = UIBezierPath()
        
        let centerPoint = rect.center
        
        let firstHorizontalGridLine = centerPoint.y.truncatingRemainder(dividingBy: division)
        
        for y in stride(from: firstHorizontalGridLine, to: rect.maxY, by: division) {
            gridPath.moveTo(x: rect.minX, y: y)
            gridPath.lineTo(x: rect.maxY, y: y)
        }
        
        let firstVerticalGridLine = centerPoint.x.truncatingRemainder(dividingBy: division)
        
        for x in stride(from: firstVerticalGridLine, to: rect.maxY, by: division) {
            gridPath.moveTo(x: x, y: rect.minY)
            gridPath.lineTo(x: x, y: rect.maxY)
        }
        
        UIColor.gray.set()
        gridPath.lineWidth = 1
        gridPath.stroke()
    }
    
    private func drawShapeIfNeeded(in rect: CGRect) {
        guard let shape = shape else {
            return
        }
        
        let converter = CartesianToCoreGraphicsSystemCoordinatesConverter(rect: rect)
         
        let shapeBezierPath = converter.convert(path: shape.path).uiBezierPath
        
        UIColor.red.set()
        shapeBezierPath.lineWidth = 2
        
        shapeBezierPath.stroke()
    }

}
