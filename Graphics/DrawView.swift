//
//  DrawView.swift
//  Graphics
//
//  Created by Sasha on 05/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    private var len: CGFloat = 100
    private var firstRadius: CGFloat = 25
    private var secondRadius: CGFloat = 35
    private var isDraw = false
    private(set) var split: CGFloat = 20
    
    override func draw(_ rect: CGRect) {
        
        guard let currentContex = UIGraphicsGetCurrentContext() else {
            print("Could not get the context")
            return
        }
        
        
        
        drawСoordinateAxis(user: currentContex, split: split)
        
        if isDraw {
            
            let center = CGPoint(x: 0, y: 0)
            
            drawDetail(user: currentContex, length: len, firstRadius: firstRadius, secondRadius: secondRadius, center: center)
        }
        
        
        
    }
    
    private func drawDetail(user context: CGContext, length: CGFloat, firstRadius: CGFloat, secondRadius: CGFloat, center: CGPoint) {
        
        // description atributes
        let descriptionLength: CGFloat = 10
        let descriptionColor = UIColor.red
        let lineColor = UIColor.blue
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 36)!, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: descriptionColor]
        
        
        let x0 = bounds.size.width / 2
        let y0 = bounds.size.height / 2
        
        let centerPoint = CGPoint(x: x0 + center.x, y: y0 + center.y + 0)
        prepareCircle(user: context, center: centerPoint, radius: firstRadius, from: 0, to: 360)
        
        context.setLineWidth(3.0)
        context.setStrokeColor(lineColor.cgColor)
        context.strokePath()
        
        // Radius param R1
        
            context.move(to: centerPoint)
        
            let upCiclePoin = getPoint(point: centerPoint, length: firstRadius, angle: 225)
            let firstDescriptionR1 = getPoint(point: upCiclePoin, length: descriptionLength, angle: 225)
            let secondDescriptionR1 = getPoint(point: firstDescriptionR1, length: descriptionLength * 2, angle: 180)
        
            //context.addLine(to: firstDescriptionR1)
            //context.addLine(to: secondDescriptionR1)
            context.addLine(to: upCiclePoin)
            context.addLine(to: getPoint(point: upCiclePoin, length: 10, angle: 90))
            context.move(to: upCiclePoin)
            context.addLine(to: getPoint(point: upCiclePoin, length: 10, angle: 0))
            context.move(to: upCiclePoin)
        
            context.addLine(to: firstDescriptionR1)
            context.addLine(to: secondDescriptionR1)
        
            context.setLineWidth(2.0)
            context.setStrokeColor(descriptionColor.cgColor)
            context.strokePath()
        
        //
        
        context.move(to: centerPoint)
        let first = sqrt((firstRadius * firstRadius) * 2) // гіпотенуза першого круга
        let second = sqrt((secondRadius * secondRadius) * 2) // гіпотенуза другого круга
        
        let catet = sqrt(pow((length + first + second), 2) / 2) - firstRadius // головний катет мінус перший радіус
        
        let upCenter = CGPoint(x: x0, y: y0 - catet)
        prepareCircle(user: context, center: upCenter, radius: firstRadius, from: 180, to: 360)
        
        var upPoint = CGPoint(x: upCenter.x + firstRadius, y: upCenter.y)
        var rightPoint = getPoint(point: upPoint, length: length, angle: 45)
        
        context.setLineWidth(3.0)
        context.setStrokeColor(lineColor.cgColor)
        context.strokePath()
        
        // height param H
        
        let firstDescriptionH = getPoint(point: upPoint, length: descriptionLength, angle: 315)
        let secondDescriptionH = getPoint(point: rightPoint, length: descriptionLength, angle: 315)
        
        context.move(to: rightPoint)
        context.addLine(to: secondDescriptionH)
        
        context.move(to: upPoint)
        context.addLine(to: firstDescriptionH)
        
        context.addLine(to: getPoint(point: firstDescriptionH, length: length, angle: 45))
        
        context.setLineWidth(2.0)
        context.setStrokeColor(descriptionColor.cgColor)
        context.strokePath()
        

        //
        
        
        
        let rightCenter = CGPoint(x: rightPoint.x, y: rightPoint.y + secondRadius)
        
        // height param R2
        
        context.move(to: rightPoint)
        
        let firstDescriptionR2 = getPoint(point: rightPoint, length: descriptionLength, angle: 0)
        let secondDescriptionR2 = getPoint(point: rightCenter, length: descriptionLength, angle: 0)
        
        context.addLine(to: firstDescriptionR2)
        context.addLine(to: secondDescriptionR2)
        context.addLine(to: rightCenter)
        
        context.setLineWidth(2.0)
        context.setStrokeColor(descriptionColor.cgColor)
        context.strokePath()
        
        //
        
        context.move(to: upPoint)
        context.addLine(to: rightPoint)
        
        prepareCircle(user: context, center: rightCenter, radius: secondRadius, from: 90, to: 270)
        
        rightPoint = CGPoint(x: rightCenter.x, y: rightCenter.y + secondRadius)
        context.move(to: rightPoint)
        
        var bottomPoint = getPoint(point: rightPoint, length: length, angle: 135)
        context.addLine(to: bottomPoint)
        
        let bottomCenter = CGPoint(x: bottomPoint.x - firstRadius, y: bottomPoint.y)
        prepareCircle(user: context, center: bottomCenter, radius: firstRadius, from: 0, to: 180)
        
        bottomPoint = CGPoint(x: bottomCenter.x - firstRadius, y: bottomCenter.y)
        context.move(to: bottomPoint)
        
        var leftPoint = getPoint(point: bottomPoint, length: length, angle: 225)
        context.addLine(to: leftPoint)
        
        let leftCenter = CGPoint(x: leftPoint.x, y: leftPoint.y - secondRadius)
        prepareCircle(user: context, center: leftCenter, radius: secondRadius, from: 270, to: 450)
        
        leftPoint = CGPoint(x: leftCenter.x, y: leftCenter.y - secondRadius)
        context.move(to: leftPoint)
        
        upPoint = CGPoint(x: upCenter.x - firstRadius, y: upCenter.y)
        context.addLine(to: upPoint)
        
        
        context.setLineCap(.square)
        context.setLineWidth(3.0)
        context.setStrokeColor(lineColor.cgColor)
        context.strokePath()
        
        
        // draw letters
        
        let stringR1 = "R1"
        stringR1.draw(with: CGRect(x: secondDescriptionR1.x, y: secondDescriptionR1.y - 40, width: 0, height: 0), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        
        var letterPointR2 = getPoint(point: secondDescriptionR2, length:  secondRadius / 2 + 20, angle: 270)
        letterPointR2 = getPoint(point: letterPointR2, length: descriptionLength, angle: 0)
        let stringR2 = "R2"
        stringR2.draw(with: CGRect(x: letterPointR2.x, y: letterPointR2.y, width: 0, height: 0), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        
        
        var letterPoint = getPoint(point: firstDescriptionH, length: length / 2 - 30, angle: 45)
        letterPoint = getPoint(point: letterPoint, length: 30, angle: 315)
        let stringH = "H"
        stringH.draw(with: CGRect(x: letterPoint.x, y: letterPoint.y, width: 0, height: 0), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }
    
    private func getPoint(point: CGPoint, length: CGFloat, angle: Double) -> CGPoint {
        return CGPoint(
                    x: point.x + length * CGFloat(cos(Double.pi * angle / 180)),
                    y: point.y + length * CGFloat(sin(Double.pi * angle / 180))
                      )
    }
    
    private func prepareCircle(user context: CGContext, center: CGPoint, radius: CGFloat, from: Int, to: Int) {
        context.move(to: center)
        context.move(to: getPoint(point: center, length: radius, angle: Double(from)))
        for i in from...to {
            context.addLine(to: getPoint(point: center, length: radius, angle: Double(i)))
        }
        //context.move(to: center)
    }
    
    private func drawСoordinateAxis(user context: CGContext, split: CGFloat) {
        
        for i in stride(from: 0, to: bounds.size.width, by: split) {
            context.move(to: CGPoint(x: i, y: 0))
            context.addLine(to: CGPoint(x: i, y: bounds.size.height))
        }
        
        for i in stride(from: 0, to: bounds.size.height, by: split) {
            context.move(to: CGPoint(x: 0, y: i))
            context.addLine(to: CGPoint(x: bounds.size.height, y: i))
        }
        
        
        
        
        context.setLineCap(.square)
        context.setLineWidth(1.0)
        context.setStrokeColor(UIColor.black.cgColor)
        context.strokePath()
    }
    
    func drawDetail(length: CGFloat, firstRadius: CGFloat, secondRadius: CGFloat) {
        
        isDraw = true
        self.len = length
        self.firstRadius = firstRadius
        self.secondRadius = secondRadius
        
        setNeedsDisplay()
    }
    
    func setSplit(split: CGFloat) {
        self.split = split
        setNeedsDisplay()
    }

}
