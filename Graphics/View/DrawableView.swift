//
//  DrawableView.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class Math {
    
    static func vector(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: p2.x - p1.x, y: p2.y - p1.y)
    }
    
    static func radians(in degrees: CGFloat) -> CGFloat {
        return .pi * degrees / 180
    }
    
}




extension CGFloat {
    
    var degrees: CGFloat {
        return self * 180 / .pi
    }
    
}


extension CGFloat {
    
    func isLess(than value: CGFloat, accuracy: CGFloat = 1e-7) -> Bool {
        let distanceToValue = distance(to: value)
        return abs(distanceToValue) < accuracy || distanceToValue > 0
    }
    
}

class SimpleDrawableView: UIView {

    
    enum Vertical {
        case above
        case below
        
        var value: CGFloat {
            switch self {
            case .above:
                return 1
            case .below:
                return -1
            }
        }
    }
    
    /**
     Круг который проходит через две точки, с углом  **/
    func circle(p1: CGPoint, p2: CGPoint, beta: CGFloat, vertical: Vertical) -> (center: CGPoint, radius: CGFloat) {
        
        let alpha: CGFloat = Math.radians(in: (180 - beta) / 2)
        
        let b = p2.length(to: p1)

        let a = b / (2 * cos(alpha)) // radius
        
        let vector = Math.vector(p1: p1, p2: p2)

        let absoluteAlpha = atan2(vector.y, vector.x) + (vertical.value * alpha)
        
        let x = p1.x + a * cos(absoluteAlpha)
        let y = p1.y + a * sin(absoluteAlpha)
        
        let center = CGPoint(x: x, y: y)
        
        return (center: center, radius: a)
    }
    
    struct ShapeLayout {
        
        var centerCircleRadius: CGFloat = 25
        
        var topCircleRadius: CGFloat = 30
        var topCircleCenterVerticalOffset: CGFloat = 45
        
        var sideOutterCirclesRadius: CGFloat = 25
        var sideOutterCirclesCenterHorizontalOffset: CGFloat = 80
        var sideOutterCirclesCenterVerticalOffset: CGFloat = 80
        
        var sideInnerCirclesRadius: CGFloat = 20
        var sideInnerCirclesCenterVerticalOffset: CGFloat = 35
        var sideInnerCirclesCenterHorizontalOffset: CGFloat = 40
        
        var bottomItemVerticalOffset: CGFloat = 100
    }
    
    private let centerCircleRadius: CGFloat = 20
    
    override func draw(_ rect: CGRect) {
        
        let layout = ShapeLayout()
        let center = rect.center
        let resultPath = UIBezierPath()
        
        UIColor.red.set()
        
        // center circle
        resultPath.append(circlePath(center: center,
                                     radius: layout.centerCircleRadius))
        
        // top circle
        let topCircleCenterY = center.y - layout.topCircleCenterVerticalOffset
        let topCircleCenter = CGPoint(x: center.x, y: topCircleCenterY)
        
        let topCircleStartPoint = circlePoint(center: topCircleCenter, radius: layout.topCircleRadius, angle: 180)
        let topCircleEndPoint = circlePoint(center: topCircleCenter, radius: layout.topCircleRadius, angle: 0)
        
        resultPath.append(circlePath(center: topCircleCenter,
                                     radius: layout.topCircleRadius,
                                     startAngle: 180,
                                     endAngle: 0,
                                     clockwise: true))

        // outer right side circle
        let rightSideOutterCircleCenter = CGPoint(x: center.x + layout.sideOutterCirclesCenterHorizontalOffset,
                                                  y: center.y + layout.sideOutterCirclesCenterVerticalOffset)
        let rightSideOutterCircleStartPoint = circlePoint(center: rightSideOutterCircleCenter,
                                                          radius: layout.sideOutterCirclesRadius,
                                                          angle: 45)
        let rightSideOutterCircleEndPoint = circlePoint(center: rightSideOutterCircleCenter,
                                                          radius: layout.sideOutterCirclesRadius,
                                                          angle: 225)
        
        resultPath.append(circlePath(center: rightSideOutterCircleCenter,
                                     radius: layout.sideOutterCirclesRadius,
                                     startAngle: 45,
                                     endAngle: 225,
                                     clockwise: true))
        
        // connection line (top circle - outer right side circle)
        resultPath.move(to: topCircleEndPoint)
        resultPath.addLine(to: rightSideOutterCircleStartPoint)
        
        // inner right side circle
        let rightSideInnerCircleCenter = CGPoint(x: center.x + layout.sideInnerCirclesCenterHorizontalOffset,
                                                 y: center.y + layout.sideInnerCirclesCenterVerticalOffset)
        let rightSideInnerCircleStartPoint = circlePoint(center: rightSideInnerCircleCenter,
                                                         radius: layout.sideInnerCirclesRadius,
                                                         angle: 45)
        let rightSideInnerCircleEndPoint = circlePoint(center: rightSideInnerCircleCenter,
                                                       radius: layout.sideInnerCirclesRadius,
                                                       angle: 225)
        
        resultPath.append(circlePath(center: rightSideInnerCircleCenter,
                                     radius: layout.sideInnerCirclesRadius,
                                     startAngle: 45,
                                     endAngle: 225,
                                     clockwise: false))
        
        // connection line (right outter circle - right inner circle)
        resultPath.move(to: rightSideOutterCircleEndPoint)
        resultPath.addLine(to: rightSideInnerCircleStartPoint)
        
        // inner left side circle
        let leftSideInnerCircleCenter = CGPoint(x: center.x - layout.sideInnerCirclesCenterHorizontalOffset,
                                                y: center.y + layout.sideInnerCirclesCenterVerticalOffset)
        let leftSideInnerCircleStartPoint = circlePoint(center: leftSideInnerCircleCenter,
                                                        radius: layout.sideInnerCirclesRadius,
                                                        angle: 315)
        let leftSideInnerCircleEndPoint = circlePoint(center: leftSideInnerCircleCenter,
                                                      radius: layout.sideInnerCirclesRadius,
                                                      angle: 135)
        
        resultPath.append(circlePath(center: leftSideInnerCircleCenter,
                                     radius: layout.sideInnerCirclesRadius,
                                     startAngle: 315,
                                     endAngle: 135,
                                     clockwise: false))
        
        // bottom item
        let bottomItemPoint = CGPoint(x: center.x,
                                      y: center.y + layout.bottomItemVerticalOffset)
        
        resultPath.move(to: rightSideInnerCircleEndPoint)
        resultPath.addLine(to: bottomItemPoint)
        
        resultPath.move(to: bottomItemPoint)
        resultPath.addLine(to: leftSideInnerCircleStartPoint)

        // outter left side circle
        let leftSideOutterCircleCenter = CGPoint(x: center.x - layout.sideOutterCirclesCenterHorizontalOffset,
                                                 y: center.y + layout.sideOutterCirclesCenterVerticalOffset)
        let leftSideOutterCircleStartPoint = circlePoint(center: leftSideOutterCircleCenter,
                                                          radius: layout.sideOutterCirclesRadius,
                                                          angle: 315)
        let leftSideOutterCircleEndPoint = circlePoint(center: leftSideOutterCircleCenter,
                                                          radius: layout.sideOutterCirclesRadius,
                                                          angle: 135)
        
        resultPath.append(circlePath(center: leftSideOutterCircleCenter,
                                     radius: layout.sideOutterCirclesRadius,
                                     startAngle: 315,
                                     endAngle: 135,
                                     clockwise: true))
        
        // connection line (inner left side circle - outter left side circle)
        resultPath.move(to: leftSideInnerCircleEndPoint)
        resultPath.addLine(to: leftSideOutterCircleStartPoint)
        
        // connection lune (left outter circle - top circle)
        resultPath.move(to: leftSideOutterCircleEndPoint)
        resultPath.addLine(to: topCircleStartPoint)

        resultPath.lineWidth = 3
        resultPath.stroke()
    }
    
    func circlePath(center: CGPoint,
                    radius: CGFloat,
                    startAngle dirtyStartAngle: CGFloat = 0,
                    endAngle dirtyEndAngle: CGFloat = 360,
//                    step dirtyStep: CGFloat = 0.1,
                    clockwise: Bool = false) -> UIBezierPath {
        
        var startAngle, endAngle: CGFloat
        
        if abs(dirtyEndAngle - dirtyStartAngle) >= 360 {
            startAngle = 0
            endAngle = 360
        } else {
            
            if clockwise {
                startAngle = dirtyEndAngle
                endAngle = dirtyStartAngle
            } else {
                startAngle = dirtyStartAngle
                endAngle = dirtyEndAngle
            }
            
            if endAngle < startAngle {
                endAngle += 360
            }
        }
        
        let step: CGFloat = 0.5
            
        let result = UIBezierPath()
        
        var angle = startAngle
        result.move(to: circlePoint(center: center, radius: radius, angle: angle))
        
        angle += step
        
        while angle.isLess(than: endAngle, accuracy: 1e-7)  {
            let nextPoint = circlePoint(center: center, radius: radius, angle: angle)
            result.addLine(to: nextPoint)
            result.move(to: nextPoint)
            
            angle += step
        }
                
        return result
    }
    
    func circlePoint(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        return circlePoint(center: center, a: radius, b: radius, t: Math.radians(in: angle))
    }
    
    func circlePoint(center: CGPoint, a: CGFloat, b: CGFloat, t: CGFloat) -> CGPoint {
        
        let x = a * cos(t)
        let y = b * sin(t)
        
        // ios inversed Oy
        return CGPoint(x: center.x + x, y: center.y - y)
    }
    

}
