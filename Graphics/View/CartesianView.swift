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
    var grid: Shape?
    var defaultShape: Shape?
    var defaultGrid: Shape?
    var newCenter: CGPoint = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    var rotate: Angle?
    
    var gama0 = CGPoint.zero {
        didSet {
            setNeedsDisplay()
        }
    }
    var gamax = CGPoint.zero + CGPoint(x: 50, y: 0){
        didSet {
            setNeedsDisplay()
        }
    }
    var gamay = CGPoint.zero + CGPoint(x: 10, y: 50) {
        didSet {
            setNeedsDisplay()
        }
    }

    var pointer: Int = 0 {
        didSet {
            if self.pointer > 2 || self.pointer < 0 {
                self.pointer = 0
            }
        }
    }
    
    var shouldDrawMarkers = true
        
    override func draw(_ rect: CGRect) {
        
        converter = CartesianToCoreGraphicsSystemCoordinatesConverter(rect: rect)
        //drawGrid(in: rect, division: divisionSize)
        //drawAxes(in: rect)
        drawGridIfNeeded(in: rect)
        drawShapeIfNeeded(in: rect)
        drawCenter(in: rect, point: newCenter)
        
        drawGama0(in: rect, point: gama0)
        drawGamaX(in: rect, point: gamax)
        drawGamaY(in: rect, point: gamay)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
        updateDivisionLabelText()
    }
    
    func configure(shape: Shape, grid: GridShape) {
        self.shape = shape
        self.grid = grid
        newCenter = .zero
        gama0 = CGPoint.zero
        gamax = CGPoint.zero
        gamay = CGPoint.zero
        
        setNeedsDisplay()
        
        self.shouldDrawMarkers = false
    }
    
    func affine() {
        let dot0 = CGPoint(x: gama0.x, y: gama0.y)
        let dotx = CGPoint(x: gamax.x, y: gamax.y)
        let doty = CGPoint(x: gamay.x, y: gamay.y)
        
        if let shape = self.shape {
            self.shape = ModifiyShape(lines: shape.affine(point0: dot0, pointx: dotx, pointy: doty))
        }
        if let grid = self.grid {
            self.grid = ModifiyShape(lines: grid.affine(point0: dot0, pointx: dotx, pointy: doty))
        }
        setNeedsDisplay()
    }
    
    func affineW(w0: CGFloat = 1000, wx: CGFloat = 1, wy: CGFloat = 1) {
        let dot0 = CGPoint(x: gama0.x, y: gama0.y)
        let dotx = CGPoint(x: gamax.x, y: gamax.y)
        let doty = CGPoint(x: gamay.x, y: gamay.y)
        
        if let shape = self.shape {
            self.shape = ModifiyShape(lines: shape.affineW(point0: dot0, w0: w0, pointx: dotx, wx: wx, pointy: doty, wy: wy))
        }
        if let grid = self.grid {
            self.grid = ModifiyShape(lines: grid.affineW(point0: dot0, w0: w0, pointx: dotx, wx: wx, pointy: doty, wy: wy))
        }
        setNeedsDisplay()
    }
    
    @IBAction func longPress(gesture: UILongPressGestureRecognizer) {
        guard let piece = gesture.view else { return }
        guard gesture.state == .began else { return }
        let centerView = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        let center = gesture.location(in: piece)
        self.newCenter = CGPoint(x: center.x - centerView.x, y: -(center.y - centerView.y))
        setNeedsDisplay()
    }
    
    
    @IBAction func pinchRecongnized(gesture: UIPinchGestureRecognizer) {
        let tempScale = gesture.scale
        
        if gesture.state == .began {
            self.defaultShape = shape
            self.defaultGrid = grid
        } else if gesture.state == .ended {
            scale = tempScale
        } else if gesture.state != .cancelled {
            if let shape = self.defaultShape, let grid = self.defaultGrid{
               let modifyShape = ModifiyShape(lines: shape.scale(by: tempScale))
               let modifyShape1 = ModifiyShape(lines: grid.scale(by: tempScale))
               self.shape = modifyShape
               self.grid = modifyShape1
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
    
    @IBAction func tapRecognizer(_ gesture: UITapGestureRecognizer) {
        guard let piece = gesture.view else { return }
        guard gesture.state != .cancelled else { return }
        gesture.numberOfTapsRequired = 2
        
        
        let centerView = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        let center = gesture.location(in: piece)
            
        switch pointer {
        case 0:
            self.gama0 = CGPoint(x: center.x - centerView.x, y: -(center.y - centerView.y))
        case 1:
            self.gamax = CGPoint(x: center.x - centerView.x, y: -(center.y - centerView.y))
        default:
            self.gamay = CGPoint(x: center.x - centerView.x, y: -(center.y - centerView.y))
        }
            
        pointer += 1
        
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
        
        var lines: [Line] = []
        
        let gridPath = UIBezierPath()
        let centerPoint = rect.center
        
        let firstHorizontalGridLine = centerPoint.y.truncatingRemainder(dividingBy: division)
        
        for y in stride(from: firstHorizontalGridLine, to: rect.maxY, by: division) {
            lines.append(Line(start: CGPoint(x: rect.minX, y: y), end: CGPoint(x: rect.maxY, y: y)))
            
        }
        
        let firstVerticalGridLine = centerPoint.x.truncatingRemainder(dividingBy: division)
        
        for x in stride(from: firstVerticalGridLine, to: rect.maxY, by: division) {
            lines.append(Line(start: CGPoint(x: x, y: rect.minY), end: CGPoint(x: x, y: rect.maxY)))
        }
        
        for line in lines {
            gridPath.move(to: line.start)
            gridPath.addLine(to: line.end)
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
    
    private func drawGridIfNeeded(in rect: CGRect) {
           guard let grid = grid else {
               return
           }
        
           converter = CartesianToCoreGraphicsSystemCoordinatesConverter(rect: rect)
        
           let shapeBezierPath = converter.convert(path: grid.path).uiBezierPath
        
           UIColor.gray.set()
           shapeBezierPath.lineWidth = 1
           
           shapeBezierPath.stroke()
    }
    
    private func drawCenter(in rect: CGRect, point: CGPoint) {
       
        let centerPoint = rect.center
        
        let newPoint = CGPoint(x: centerPoint.x + point.x - 2.5 , y:  centerPoint.y - point.y - 2.5)
        
        let dot = CGRect(origin: newPoint , size: CGSize(width: 5, height: 5))
        let dotePath = UIBezierPath(ovalIn: dot)
       
        
        UIColor.blue.set()
        dotePath.fill()
        dotePath.stroke()
    }
    
    private func drawGama0(in rect: CGRect, point: CGPoint){
        
        let centerPoint = rect.center
        let newPoint = CGPoint(x: centerPoint.x + point.x - 2.5 , y:  centerPoint.y - point.y - 2.5)
         
        let dot = CGRect(origin: newPoint , size: CGSize(width: 5, height: 5))
        let dotePath = UIBezierPath(ovalIn: dot)
        
         
        UIColor.green.set()
        dotePath.fill()
        dotePath.stroke()
    }
    
    private func drawGamaX(in rect: CGRect, point: CGPoint){
        
        let centerPoint = rect.center
        let newPoint = CGPoint(x: centerPoint.x + point.x - 2.5 , y:  centerPoint.y - point.y - 2.5)
         
        let dot = CGRect(origin: newPoint , size: CGSize(width: 5, height: 5))
        let dotePath = UIBezierPath(ovalIn: dot)
        
         
        UIColor.green.set()
        dotePath.fill()
        dotePath.stroke()
    }

    private func drawGamaY(in rect: CGRect, point: CGPoint){
        
        let centerPoint = rect.center
        let newPoint = CGPoint(x: centerPoint.x + point.x - 2.5 , y:  centerPoint.y - point.y - 2.5)
         
        let dot = CGRect(origin: newPoint , size: CGSize(width: 5, height: 5))
        let dotePath = UIBezierPath(ovalIn: dot)
        
         
        UIColor.green.set()
        dotePath.fill()
        dotePath.stroke()
    }

}
