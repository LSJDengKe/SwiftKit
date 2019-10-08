//
//  SwiftImage.swift
//  Pods
//
//  Created by 李世举 on 2019/9/28.
//

import UIKit

@objcMembers
open class SwiftImage: UIImage {
    public private(set) var animatedImageType: SwiftImageType?
    public var animatedImageData: Data? {
        get {
            return self.decoder!.data
        }
    }
    public private(set) var animatedImageMemorySize: Int?
    public var preloadAllAnimatedImageFrames: Bool?
    
    private var decoder: SwiftImageCoder?
    private var preloadedFrames: Array<UIImage?>?
    private var preloadedLock: DispatchSemaphore?
    private var bytesPerFrame: Int?
    
}

extension SwiftImage {
    public class func image(name: String) -> SwiftImage? {
        if name.isEmpty {
            return nil
        }
        if name.hasSuffix("/") {
            return nil
        }
        var scale:CGFloat = 1
        if let pathS = URL.init(string: name) {
            var path: URL?
            let res = pathS.deletingPathExtension()
            let ext = pathS.pathExtension
            let array = ext.count > 0 ? [ext] : ["", "png", "jpeg", "jpg", "gif", "webp", "apng"]
            let scales = preferredScales
            for s in scales {
                scale = CGFloat(s)
                let scaledName = res.appendingName(scale: CGFloat(s))
                for e in array {
                    if let pathM = Bundle.main.path(forResource: scaledName.path, ofType: e) {
                        path = URL.init(string: pathM)
                        if path != nil {
                            break
                        }
                    }
                }
            }
            if path == nil {
                return nil
            }
            if let data = try? Data.init(contentsOf: path!) {
                if data.count == 0 {
                    return nil
                }
                return SwiftImage.init().initialize(data: data, scale: scale)
            }else {
                return nil
            }
        }
        return nil
    }
    public class func imageWithContentsOfFile(path: String) -> SwiftImage? {
        if let url = URL.init(string: path) {
            if let data = try? Data.init(contentsOf: url) {
                return SwiftImage.init().initialize(data: data, scale: 1)
            }
        }
        return nil
    }
    public class func imageWithData(data: Data) -> SwiftImage? {
        return SwiftImage.init().initialize(data: data, scale: 1)
    }
    public class func imageWithData(data: Data, scale: CGFloat) -> SwiftImage? {
        return SwiftImage.init().initialize(data: data, scale: scale)
    }
}

extension SwiftImage {
    func initialize(data: Data, scale: CGFloat) -> SwiftImage? {
        if data.isEmpty {
            return nil
        }
        let scaleS = scale <= 0 ? UIScreen.main.scale : scale
        
        var newImage: SwiftImage?
        self.preloadedLock = DispatchSemaphore.init(value: 1)
        autoreleasepool {
            let decoder = SwiftImageCoder.decoder(data: data, scale: scaleS)
            let frame = decoder?.frame(index: 0, decodeForDisplay: true)
            let image = frame?.image
            if image != nil && decoder != nil && image?.cgImage != nil {
                newImage = SwiftImage.init(cgImage: image!.cgImage!, scale: decoder!.scale!, orientation: image!.imageOrientation)
                if newImage != nil {
                    newImage!.animatedImageType = decoder?.type
                    if decoder!.frameCount! > 1 {
                        newImage!.decoder = decoder
                        newImage!.bytesPerFrame = image!.cgImage!.width * image!.cgImage!.height
                        newImage!.animatedImageMemorySize = newImage!.bytesPerFrame! * decoder!.frameCount!
                    }
                    newImage!.isDecodedForDisplay = true
                }
            }
        }
        return newImage
    }
}
extension SwiftImage {
    open override class var supportsSecureCoding: Bool {
        return true
    }
}

extension SwiftImage: SwiftAnimatedImageprotocol {
    public func animatedImageFrameCount() -> Int? {
        return self.decoder?.frameCount
    }
    public func animatedImageLoopCount() -> Int? {
        return self.decoder?.loopCount
    }
    public func animatedImageBytesPerFrame() -> Int? {
        return self.bytesPerFrame
    }
    public func animatedImageFrameAt(index: Int) -> UIImage? {
        if index >= self.decoder!.frameCount! {
            return nil
        }
//        DISPATCH_TIME_FOREVER' has been renamed to 'DispatchTime.distantFuture'
//        dispatch_semaphore_wait' has been replaced by instance method 'DispatchSemaphore.wait(timeout:)'
        self.preloadedLock = DispatchSemaphore(value: 1)
        _ = self.preloadedLock?.wait(timeout: DispatchTime.distantFuture)
        let image = self.preloadedFrames![index]
        self.preloadedLock?.signal()
        if image != nil {
            return image
        }
        return self.decoder?.frame(index: index, decodeForDisplay: true)?.image
        
    }
    public func animatedImageDurationAt(index: Int) -> TimeInterval? {
        let duration = self.decoder?.frameDuration(index: index)
        if duration == nil || duration! < 0.011 {
            return 0.1
        }
        return duration
    }
    public func animatedImageContentsRectAt(index: Int) -> CGRect? {
        return CGRect.zero
    }
}
