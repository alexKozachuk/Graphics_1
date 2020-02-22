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
        
        let r1: CGFloat
        let r2: CGFloat
        let h: CGFloat
        
        init(r1: CGFloat = 0,
             r2: CGFloat = 0,
             h: CGFloat = 0) {
            
            self.r1 = r1
            self.r2 = r2
            self.h = h
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
        
        let first = sqrt((params.r1 * params.r1) * 2) // гіпотенуза першого круга
        let second = sqrt((params.r2 * params.r2) * 2) // гіпотенуза другого круга

        let catet = sqrt(pow((params.h + first + second), 2) / 2) - params.r1 // головний катет мінус перший радіус
        
        let topCircleCenter = center + CGPoint(x: 0, y: catet)
        let topCircle = ArcShape(center: topCircleCenter,
                                 radius: params.r1,
                                 start: .degrees(90),
                                 end: .degrees(0),
                                 clockwise: true)
        outterPath.set(path: topCircle.path)
        
        let outterRightCircleCenter = center + CGPoint(x: catet, y: 0)
        
        let outterRightCircle = ArcShape(center: outterRightCircleCenter,
                                         radius: params.r2,
                                         start: .degrees(90),
                                         end: .degrees(180),
                                         clockwise: false)
        
        outterPath.connect(path: outterRightCircle.path)

        let mirroredOutterPath1 = outterPath.mirroredByAxisX
        outterPath.add(path: mirroredOutterPath1)
        let mirroredOutterPath2 = outterPath.mirroredByAxisY
        
        resultPath.add(path: outterPath)
        resultPath.add(path: mirroredOutterPath1)
        resultPath.add(path: mirroredOutterPath2)
        
        return resultPath.lines
    }
    
    

    
    
}
