//
//  SwiftCGUtilities.swift
//  Pods
//
//  Created by 李世举 on 2019/9/30.
//

import Foundation

func swiftCGRectFitWith(contentMode: UIView.ContentMode, rect: CGRect, size: CGSize) -> CGRect? {
    var rectM = rect.standardized
    let widh = size.width < 0 ? -size.width : size.width
    let height = size.height < 0 ? -size.height : size.height
    var sizeM = CGSize.init(width: widh, height: height)
    let center = CGPoint.init(x: rectM.midX, y: rectM.midY)
    
    switch contentMode {
    case .scaleAspectFit, .scaleAspectFill:
        if rectM.size.width < 0.01 || rectM.size.height < 0.01 || sizeM.width < 0.01 || size.height < 0.01 {
            rectM.origin = center
            rectM.size = .zero
        }else {
            var scale: CGFloat = 0
            if contentMode == .scaleAspectFit {
                if sizeM.width / size.height < rectM.size.width / rectM.size.height {
                    scale = rectM.size.height / size.height
                }else {
                    scale = rectM.size.width / size.width
                }
            }else {
                if sizeM.width / size.height < rectM.size.width / rectM.size.height {
                    scale = rectM.size.width / size.width
                }else {
                    scale = rectM.size.height / size.height
                }
            }
            sizeM.width *= scale
            sizeM.height *= scale
            rectM.size = sizeM
            rectM.origin = CGPoint.init(x: center.x - sizeM.width * 0.5, y: center.y - sizeM.height * 0.5)
        }
    case .center:
        rectM.size = sizeM
        rectM.origin = CGPoint.init(x: center.x - sizeM.width * 0.5, y: center.y - sizeM.height * 0.5)
    case .top:
        rectM.origin.x = center.x - sizeM.width * 0.5
        rectM.size = sizeM
    case .bottom:
        rectM.origin.x = center.x + sizeM.width * 0.5
        rectM.origin.y += rectM.size.height - sizeM.height
        rectM.size = sizeM
    case .left:
        rectM.origin.y = center.y - sizeM.height * 0.5
        rectM.size = sizeM
    case .right:
        rectM.origin.y = center.y - sizeM.height * 0.5
        rectM.origin.x += rectM.size.width - sizeM.width
        rectM.size = sizeM
    case .topLeft:
        rectM.size = size
    case .topRight:
        rectM.origin.x += rect.size.width - sizeM.width
        rectM.size = size
    case .bottomLeft:
        rectM.origin.x += rectM.size.height - sizeM.height
        rectM.size = sizeM
    case .bottomRight:
        rectM.origin.x += rectM.size.width - sizeM.width
        rectM.origin.y += rectM.size.height - sizeM.height
        rectM.size = size
    case .scaleToFill, .redraw:
        debugPrint("")
    default:
        debugPrint("")
    }
    
    return rectM
}

func swiftDegreesTo(radians: CGFloat) -> CGFloat {
    return radians * .pi / 180
}
