//
//  UIImage+Swift.swift
//  Pods
//
//  Created by 李世举 on 2019/9/29.
//

import Foundation
import Accelerate

func swiftCGImageSourceGetGIFFrameDelayAt(source: CGImageSource, index: size_t) -> TimeInterval {
    var dalay: TimeInterval = 0
    if let dic = CGImageSourceCopyPropertiesAtIndex(source, index, nil) {
        if let dicGIF = CFDictionaryGetValue(dic, UnsafeRawPointer.init(bitPattern: kCGImagePropertyGIFDictionary.hashValue)) {
            var num = CFDictionaryGetValue(dicGIF.load(as: CFDictionary.self), UnsafeRawPointer.init(bitPattern: kCGImagePropertyGIFUnclampedDelayTime.hashValue))
            
            if (num?.load(as: Double.self)) != nil {
                if (num!.load(as: Double.self)) <= .ulpOfOne {
                    num = CFDictionaryGetValue(dicGIF.load(as: CFDictionary.self), UnsafeRawPointer.init(bitPattern: kCGImagePropertyGIFDelayTime.hashValue))
                }
            }
        }
    }
    if dalay < 0.02 {
        dalay = 0.1
    }
    return dalay
}


// MARK: - Create image
extension UIImage {
    public class func imageWithSmallGIF(data: Data, scale: CGFloat) -> UIImage? {
        if let source = CGImageSourceCreateWithData(data as CFData, nil) {
            let count = CGImageSourceGetCount(source)
            if count <= 1 {
                return self.init(data: data, scale: scale)
            }
            var frames: [Int] = Array(0..<count).map { $0 * 0 }
            var oneFrameTime = 1 / 50.0
            var totalTime: TimeInterval = 0
            var totalFrame: Int = 0
            var gcdFrame: Int = 0
            for i in 0..<count {
                let delay = swiftCGImageSourceGetGIFFrameDelayAt(source: source, index: i)
                totalTime += delay
                var frame = lrint(delay / oneFrameTime)
                frame = frame <= 1 ? 1 : frame
                frames[i] = frame
                totalFrame += frames[i]
                if i == 0 {
                    gcdFrame = frames[i]
                }else {
                    let f = frames[i]
                    var tmp: Int = 0
                    if f < gcdFrame {
//                        frames.swapAt(0, i)
                        tmp = frame
                        frame = gcdFrame
                        gcdFrame = tmp
                    }
                    while (true) {
                        tmp = frame % gcdFrame
                        if (tmp == 0) {
                            break
                        }
                        frame = gcdFrame
                        gcdFrame = tmp
                    }
                }
            }
        }
        
        
        return nil
    }
    
    public class func isAnimatedGIF(data: Data) -> Bool? {
        return nil
    }
    public class func isAnimatedGIFFile(path: String) -> Bool? {
        return nil
    }
    public class func imageWithPDF(dataOrPath: Any) -> UIImage? {
        return nil
    }
    public class func imageWithPDF(dataOrPath: Any, size: CGSize) -> UIImage? {
        return nil
    }
    public class func imageWithEmoji(emoji: String, size: CGSize) -> UIImage? {
        return nil
    }
    public class func image(color: UIColor) -> UIImage? {
        return nil
    }
    public class func image(color: UIColor, size: CGSize) -> UIImage? {
        return nil
    }
    public class func image(size: UIColor, drawBlock: (CGContext) -> ()) -> UIImage? {
        return nil
    }
}
// MARK: - Image Info
extension UIImage {
    public func hasAlphaChannel() -> Bool {
        if self.cgImage == nil {
            return false
        }//kCGBitmapAlphaInfoMask
        if let alpha = self.cgImage?.alphaInfo {
            if let a = CGImageAlphaInfo.init(rawValue: alpha.rawValue & CGBitmapInfo.alphaInfoMask.rawValue) {
                return a == .first || a == .last || a == .premultipliedFirst || a == .premultipliedLast
            }
        }
        return false
    }
}
// MARK: - Modify Image
extension UIImage {
    public func draw(rect: CGRect, with contentMode: UIView.ContentMode, clipsToBounds: Bool) -> Void {
        let drawRect = swiftCGRectFitWith(contentMode: contentMode, rect: rect, size: self.size)
        if drawRect == nil {
            return
        }
        if drawRect?.size.width == 0 || drawRect?.size.height == 0 {
            return
        }
        if clipsToBounds {
            let context = UIGraphicsGetCurrentContext()
            if context != nil {
                context?.saveGState()
                context?.addRect(rect)
                context?.clip()
                self.draw(in: drawRect!)
                context?.restoreGState()
            }
        }else {
            self.draw(in: drawRect!)
        }
    }
    public func imageByResizeTo(size: CGSize) -> UIImage? {
        if size.width <= 0 || size.height <= 0 {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    public func imageByResizeTo(size: CGSize, contentMode: UIView.ContentMode) -> UIImage? {
        if size.width <= 0 || size.height <= 0 {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(rect: CGRect.init(x: 0, y: 0, width: size.width, height: size.height), with: contentMode, clipsToBounds: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    public func imageByCropTo(rect: CGRect) -> UIImage? {
        var rectM = rect
        rectM.origin.x *= self.scale
        rectM.origin.y *= self.scale
        rectM.size.width *= self.scale
        rectM.size.height *= self.scale
        if rectM.size.width <= 0 || rectM.size.height <= 0 {
            return nil
        }
        if self.cgImage == nil {
            return nil
        }
        if let cgImage = self.cgImage?.cropping(to: rectM) {
            let image = UIImage.init(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
            return image
        }
        return nil
    }
    public func imageBy(insetEdge: UIEdgeInsets, with color: UIColor) -> UIImage? {
        var size = self.size
        size.width -= insetEdge.left + insetEdge.right
        size.height -= insetEdge.top + insetEdge.bottom
        if size.width <= 0 || size.height <= 0 {
            return nil
        }
        let rect = CGRect.init(x: -insetEdge.left, y: -insetEdge.top, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        let path = CGMutablePath()
        path.addRect(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        path.addRect(rect)
        context?.addPath(path)
        context?.fillPath()
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    public func imageByRoundCorner(radius: CGFloat) -> UIImage? {
        return self.imageByRoundCorner(radius: radius, borderWidth: 0, borderColor: nil)
    }
    public func imageByRoundCorner(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor?) -> UIImage? {
        return self.imageByRoundCorner(radius: radius, corners: UIRectCorner.allCorners, borderWidth: borderWidth, borderColor: borderColor, borderLineJoin: CGLineJoin.miter)
    }
    public func imageByRoundCorner(radius: CGFloat, corners: UIRectCorner, borderWidth: CGFloat, borderColor: UIColor?, borderLineJoin: CGLineJoin) -> UIImage? {
        var cornersM = corners
        
        if cornersM != UIRectCorner.allCorners {
            var tmp: UIRectCorner = UIRectCorner.init(rawValue: 0)
            if cornersM.rawValue & UIRectCorner.topLeft.rawValue > 0 {
                tmp = [tmp, .bottomLeft]
            }
            if cornersM.rawValue & UIRectCorner.topRight.rawValue > 0 {
                tmp = [tmp, .bottomLeft]
            }
            if cornersM.rawValue & UIRectCorner.bottomLeft.rawValue > 0 {
                tmp = [tmp, .topLeft]
            }
            if cornersM.rawValue & UIRectCorner.bottomRight.rawValue > 0 {
                tmp = [tmp, .topRight]
            }
            cornersM = tmp
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.scaleBy(x: 1, y: -1)
        let minSize = min(self.size.width, self.size.height)
        if borderWidth < minSize / 2 {
            let path = UIBezierPath.init(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth), byRoundingCorners: cornersM, cornerRadii: CGSize.init(width: radius, height: borderWidth))
            path.close()
            context?.saveGState()
            path.addClip()
            context?.draw(self.cgImage!, in: rect)
            context?.restoreGState()
        }
        if borderColor != nil && borderWidth < minSize / 2 && borderWidth > 0 {
            let strokeInset = floor(borderWidth * self.scale) / self.scale
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0
            let path = UIBezierPath.init(roundedRect: strokeRect, byRoundingCorners: cornersM, cornerRadii: CGSize.init(width: strokeRadius, height: borderWidth))
            path.close()
            path.lineWidth = borderWidth
            path.lineJoinStyle = borderLineJoin
            borderColor?.setStroke()
            path.stroke()
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    public func imageBy(rotate: CGFloat, fitSize: Bool) -> UIImage? {
        if self.cgImage == nil {
            return nil
        }
        let with = self.cgImage?.width
        let height = self.cgImage?.height
        let newRect = CGRect.init(x: 0, y: 0, width: CGFloat(with!), height: CGFloat(height!)).applying(CGAffineTransform(rotationAngle: rotate))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext.init(data: nil, width: with!, height: height!, bitsPerComponent: 8, bytesPerRow: Int(newRect.size.height * 4.0), space: colorSpace, bitmapInfo: UInt32(CGColorRenderingIntent.defaultIntent.rawValue) | CGImageAlphaInfo.premultipliedFirst.rawValue)
        if context == nil {
            return nil
        }
        context?.setShouldAntialias(true)
        context?.setAllowsAntialiasing(true)
        context?.interpolationQuality = CGInterpolationQuality.high
        context?.translateBy(x: +(newRect.size.width * 0.5), y: +(newRect.size.height * 0.5))
        context?.rotate(by: rotate)
        context?.draw(self.cgImage!, in: CGRect.init(x: -CGFloat(with!) * 0.5, y: -CGFloat(height!) * 0.5, width: CGFloat(with!), height: CGFloat(height!)))
        let cgImage = context?.makeImage()
        let image = UIImage.init(cgImage: cgImage!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    public func imageByRotateLeft90() -> UIImage? {
        return self.imageBy(rotate: swiftDegreesTo(radians: 90), fitSize: true)
    }
    public func imageByRotateRight90() -> UIImage? {
        return self.imageBy(rotate: swiftDegreesTo(radians: -90), fitSize: true)
    }
    public func imageByRotate180() -> UIImage? {
        return self.swiftFlip(horizontal: true, vertical: true)
    }
    public func imageByFlipVertical() -> UIImage? {
        return self.swiftFlip(horizontal: false, vertical: true)
    }
    public func imageByFlipHorizontal() -> UIImage? {
        return self.swiftFlip(horizontal: true, vertical: false)
    }
}
// MARK: - Image Effect
extension UIImage {
    public func imageByTint(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        color.set()
        UIRectFill(rect)
        self.draw(at: CGPoint.init(x: 0, y: 0), blendMode: .destinationIn, alpha: 1)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    public func imageByGrayscale() -> UIImage? {
        return self.imageByBlurRadius(blurRadius: 0, tintColor: nil, tintBlendMode: .normal, saturation: 0, maskImage: nil)
    }
    public func imageByBlurSoft() -> UIImage? {
        return self.imageByBlurRadius(blurRadius: 60, tintColor: UIColor.init(white: 0.84, alpha: 0.36), tintBlendMode: .normal, saturation: 1.8, maskImage: nil)
    }
    public func imageByBlurLight() -> UIImage? {
        return self.imageByBlurRadius(blurRadius: 60, tintColor: UIColor.init(white: 1, alpha: 0.3), tintBlendMode: .normal, saturation: 1.8, maskImage: nil)
    }
    public func imageByBlurExtraLight() -> UIImage? {
        return self.imageByBlurRadius(blurRadius: 40, tintColor: UIColor.init(white: 0.97, alpha: 0.82), tintBlendMode: .normal, saturation: 1.8, maskImage: nil)
    }
    public func imageByBlurDark() -> UIImage? {
        return self.imageByBlurRadius(blurRadius: 60, tintColor: UIColor.init(white: 0.11, alpha: 0.73), tintBlendMode: .normal, saturation: 1.8, maskImage: nil)
    }
    public func imageByBlurWith(tintColor: UIColor) -> UIImage? {
        let effectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        let componentCount = tintColor.cgColor.numberOfComponents
        if componentCount == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor.init(white: b, alpha: effectColorAlpha)
            }
            
        }else {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            
            if tintColor.getRed(&r, green: &g, blue: &b, alpha: nil) {
                effectColor = UIColor.init(red: r, green: g, blue: b, alpha: CGFloat(effectColorAlpha))
            }
        }
        return self.imageByBlurRadius(blurRadius: 20, tintColor: effectColor, tintBlendMode: .normal, saturation: -1.0, maskImage: nil)
    }
    ///还没有完成
    public func imageByBlurRadius(blurRadius: CGFloat, tintColor: UIColor?, tintBlendMode: CGBlendMode, saturation: CGFloat, maskImage: UIImage?) -> UIImage? {
        if self.size.width < 1 || self.size.height < 1 {
            debugPrint(String.init(format: "UIImage+Swift error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self))
            return nil
        }
        if self.cgImage == nil {
            debugPrint(String.init(format: "UIImage+Swift error: inputImage must be backed by a CGImage: %@", self))
            return nil
        }
        if maskImage != nil && maskImage?.cgImage == nil {
            debugPrint(String.init(format: "UIImage+Swift error: inputImage must be backed by a CGImage: %@", self))
            return nil
        }
//        let hasNewFunc = vImageBuffer_InitWithCGImage != 0 && vImageCreateCGImageFromBuffer != 0
            
        return nil
    }
}

extension UIImage {
    private func changed(array: inout [Int], one: Int, two: Int) {
        
    }
    private func swiftFlip(horizontal: Bool, vertical: Bool) -> UIImage? {
        if self.cgImage == nil {
            return nil
        }
        let width = self.cgImage?.width
        let height = self.cgImage?.height
        let bytesPreRow = width! * 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext.init(data: nil, width: width!, height: height!, bitsPerComponent: 8, bytesPerRow: bytesPreRow, space: colorSpace, bitmapInfo: UInt32(CGColorRenderingIntent.defaultIntent.rawValue) | CGImageAlphaInfo.premultipliedFirst.rawValue)
        if context == nil {
            return nil
        }
        context?.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: CGFloat(width!), height: CGFloat(height!)))
        let data = context?.data
        if data == nil {
            return nil
        }
        
        var src = vImage_Buffer.init(data: data, height: vImagePixelCount(height!), width: vImagePixelCount(width!), rowBytes: bytesPreRow)
        var dest = vImage_Buffer.init(data: data, height: vImagePixelCount(height!), width: vImagePixelCount(width!), rowBytes: bytesPreRow)
        if vertical {
            vImageVerticalReflect_ARGB8888(&src, &dest, vImage_Flags(kvImageBackgroundColorFill))
        }
        if horizontal {
            vImageHorizontalReflect_ARGB8888(&src, &dest, vImage_Flags(kvImageBackgroundColorFill))
        }
        let cgImage = context?.makeImage()
        if cgImage == nil {
            return nil
        }
        let image = UIImage.init(cgImage: cgImage!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}
