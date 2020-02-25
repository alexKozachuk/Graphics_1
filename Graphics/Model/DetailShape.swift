//
//  DetailShape.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

struct DetailShape: Shape {
    
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

struct ModifiyShape: Shape {
    
    var lines: [Line]
    
    var path: Path {
        return Path(lines: lines)
    }
    
}

struct GridShape: Shape {
    
    struct Parameters {
        
        var min: CGPoint
        var max: CGPoint
        var division: CGFloat

        
        init(min: CGPoint = CGPoint(x: 0, y: 0),
             max: CGPoint = CGPoint(x: 0, y: 0),
             division: CGFloat = 0) {
            
            self.min = min
            self.max = max
            self.division = division
        }
    }
    
    var path: Path {
        return Path(lines: lines)
    }
    
    var params: Parameters
    
    var lines: [Line] {
        var linesArr: [Line] = []
        
        for y in stride(from: 0, to: params.max.y, by: params.division) {
            linesArr.append(Line(start: CGPoint(x: params.min.x, y: y), end: CGPoint(x: params.max.x, y: y)))
        }
        
        for x in stride(from: 0, to: params.max.x, by: params.division) {
            linesArr.append(Line(start: CGPoint(x: x, y: params.min.y), end: CGPoint(x: x, y: params.max.y)))
        }
        
        var path = Path(lines: linesArr, startPoint: linesArr.first!.start, endPoint: linesArr.last!.end)
        
        let path1 = path.mirroredByAxisX
        path.add(path: path1)
        let path2 = path.mirroredByAxisY
        path.add(path: path2)
        
        
        return path.lines
    }
    
//    func affine(point0: CGPoint, pointx: CGPoint, pointy: CGPoint) -> [Line]{
//        var affineLines: [Line] = []
//
//        for item in path.lines {
//            affineLines.append(item.affine(point0: point0, pointx: pointx, pointy: pointy))
//        }
//
//        return affineLines
//    }
//
//    func affineW(point0: CGPoint, w0: CGFloat, pointx: CGPoint, wx: CGFloat, pointy: CGPoint, wy: CGFloat) -> [Line] {
//        var affineLines: [Line] = []
//
//        for item in path.lines {
//            affineLines.append(item.affineW(point0: point0, w0: w0, pointx: pointx, wx: wx, pointy: pointy, wy: wy))
//        }
//
//        return affineLines
//    }
//
//    func scale(by scale: CGFloat) -> [Line] {
//        var rotateLines: [Line] = []
//
//        for item in path.lines {
//            rotateLines.append(item.scale(by: scale))
//        }
//
//        return rotateLines
//    }
    
}

