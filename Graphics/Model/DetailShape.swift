//
//  DetailShape.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

import CoreGraphics

struct DetailZeroShape: Shape {
    
    struct Parameters {
        let h1: CGFloat
        let h2: CGFloat
        let h3: CGFloat
        let h4: CGFloat
        
        let w1: CGFloat
        let w2: CGFloat
        
        let r1: CGFloat
        let r2: CGFloat
        
        init(r1: CGFloat = 0,
             r2: CGFloat = 0,
             h1: CGFloat = 0,
             h2: CGFloat = 0,
             h3: CGFloat = 0,
             h4: CGFloat = 0,
             w1: CGFloat = 0,
             w2: CGFloat = 0) {
            
            self.r1 = r1
            self.r2 = r2
            
            self.h1 = h1
            self.h2 = h2
            self.h3 = h3
            self.h4 = h4
            
            self.w1 = w1
            self.w2 = w2
        }
    }
    
    let center: CGPoint
    let params: Parameters
    
    var path: Path {
        return Path(lines: lines)
    }
    
    var lines: [Line] {
        
        var resultPath = Path()
        
        let innerCircle = ArcShape(center: center, radius: params.r1)
        resultPath.add(path: innerCircle.path)
        
        var outterPath = Path()
        
        let topCircleCenter = center + CGPoint(x: 0, y: params.h1)
        let topCircle = ArcShape(center: topCircleCenter,
                                 radius: params.r1,
                                 start: .degrees(90),
                                 end: .degrees(0),
                                 clockwise: true)
        outterPath.set(path: topCircle.path)
        
        let outterRightCircleCenter = center + CGPoint(x: params.w1, y: -params.h3)
        let outterRightCircle = ArcShape(center: outterRightCircleCenter,
                                         radius: params.r2,
                                         start: .degrees(45),
                                         end: .degrees(-135),
                                         clockwise: true)
        outterPath.connect(path: outterRightCircle.path)
        
        let innerRightCircleCenter = center + CGPoint(x: params.w2, y: -params.h4)
        let innerRightCircle = ArcShape(center: innerRightCircleCenter,
                                        radius: params.r2,
                                        start: .degrees(45),
                                        end: .degrees(225),
                                        clockwise: false)
        outterPath.connect(path: innerRightCircle.path)
        
        let bottomPoint = center + CGPoint(x: 0, y: -params.h2)
        outterPath.addLine(to: bottomPoint)
        
        let mirroredOutterPath = outterPath.mirroredByAxisX
        
        resultPath.add(path: outterPath)
        resultPath.add(path: mirroredOutterPath)
        
        return resultPath.lines
    }
    
    

    
    
}
