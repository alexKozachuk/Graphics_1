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
    var converter: CartesianToCoreGraphicsSystemCoordinatesConverter!
        
    var shape: Shape?
    var defaultShape: Shape?
    var newCenter: CGPoint = .zero
    var rotate: Angle?

    var shouldDrawMarkers = true
        
    override func draw(_ rect: CGRect) {
        
        converter = CartesianToCoreGraphicsSystemCoordinatesConverter(rect: rect)
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
        newCenter = .zero
        setNeedsDisplay()
        
        self.shouldDrawMarkers = shouldDrawMarkers
    }
    
    @IBAction func longPress(gesture: UILongPressGestureRecognizer) {
        guard let piece = gesture.view else { return }
        guard gesture.state == .began else { return }
        let centerView = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        let center = gesture.location(in: piece)
        self.newCenter = center - centerView
    }
    
    
    @IBAction func pinchRecongnized(gesture: UIPinchGestureRecognizer) {
        let tempScale = gesture.scale
        
        if gesture.state == .began {
            self.defaultShape = shape
        } else if gesture.state == .ended {
            scale = tempScale
        } else if gesture.state != .cancelled {
            if let shape = self.defaultShape {
               let modifyShape = ModifiyShape(lines: shape.scale(by: tempScale))
               self.shape = modifyShape
               setNeedsDisplay()
            }
        }
        
    }
    
    var initialCenter = CGPoint()  // The initial center point of the view.
    
    @IBAction func panPiece(_ gestureRecognizer : UIPanGestureRecognizer) {
        guard let piece =  gestureRecognizer.view else { return }
       
        let translation = gestureRecognizer.translation(in: piece.superview)
        let move = CGPoint(x: translation.x, y: -translation.y)
        if gestureRecognizer.state == .began {
            self.initialCenter = piece.center
            self.defaultShape = shape
        } else if gestureRecognizer.state == .ended {
            self.defaultShape = shape
            self.newCenter = self.newCenter + move
        } else if gestureRecognizer.state != .cancelled {
            
            if let shape = self.defaultShape {
                let modifyShape = ModifiyShape(lines: shape.moveTo(point: move))
                self.shape = modifyShape
                setNeedsDisplay()
            }
        } else {
            piece.center = .zero
        }
    }
    
    @IBAction func hanfleRotate(_ gesture: UIRotationGestureRecognizer) {
        
        if gesture.state == .began {
            self.defaultShape = shape
        } else if gesture.state == .ended {
        
        } else if gesture.state != .cancelled {
            rotate = .degrees(Int(gesture.rotation * 10))
            if let shape = self.defaultShape {
                let modifyShape = ModifiyShape(lines: shape.rotate(by: rotate!, in: newCenter))
               self.shape = modifyShape
               setNeedsDisplay()
            }
        }
        
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
        
        converter = CartesianToCoreGraphicsSystemCoordinatesConverter(rect: rect)
         
        let shapeBezierPath = converter.convert(path: shape.path).uiBezierPath
        
        UIColor.red.set()
        shapeBezierPath.lineWidth = 2
        
        shapeBezierPath.stroke()
    }

}
