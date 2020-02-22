//
//  SystemCoordinateConverter.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import CoreGraphics

protocol SystemCoordinatesConverter {
    func convert(point: CGPoint) -> CGPoint
}

extension SystemCoordinatesConverter {
    
    func convert(line: Line) -> Line {
        let start = convert(point: line.start)
        let end = convert(point: line.end)
        
        return Line(start: start, end: end)
    }
    
    func convert(lines: [Line]) -> [Line] {
        return lines.map { convert(line: $0) }
    }
    
    func convert(path: Path) -> Path {
        let lines = convert(lines: path.lines)
        let startPoint = path.startPoint.map { convert(point: $0) }
        let endPoint = path.endPoint.map { convert(point: $0) }
        
        return Path(lines: lines, startPoint: startPoint, endPoint: endPoint)
    }
    
}
