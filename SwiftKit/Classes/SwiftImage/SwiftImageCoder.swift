//
//  SwiftImageCoder.swift
//  Pods
//
//  Created by 李世举 on 2019/9/28.
//

import Foundation

/**
Image file type.
*/
public enum SwiftImageType: Int {
    case SwiftImageTypeUnknown              = 0 ///< unknown
    case SwiftImageTypeJPEG                     ///< jpeg, jpg
    case SwiftImageTypeJPEG2000                 ///< jp2
    case SwiftImageTypeTIFF                     ///< tiff, tif
    case SwiftImageTypeBMP                      ///< bmp
    case SwiftImageTypeICO                      ///< ico
    case SwiftImageTypeICNS                     ///< icns
    case SwiftImageTypeGIF                      ///< gif
    case SwiftImageTypePNG                      ///< png
    case SwiftImageTypeWebP                     ///< webp
    case SwiftImageTypeOther                    ///< other image format
}
public enum SwiftImageDisposeMethod: Int {
    case SwiftImageDisposeNone             = 0 ///< unknown
    case SwiftImageDisposeBackground                     ///< jpeg, jpg
    case SwiftImageDisposePrevious                 ///< jp2
}
public enum SwiftImageBlendOperation: Int {
    case SwiftImageBlendNone             = 0 ///< unknown
    case SwiftImageBlendOver                     ///< jpeg, jpg
}

open class SwiftImageFrame: NSObject{
    var index: Int?
    var width: Int?
    var height: Int?
    var offsetX: Int?
    var offsetY: Int?
    var duration: TimeInterval?
    var dispose: SwiftImageDisposeMethod?
    var blend: SwiftImageBlendOperation?
    var image: UIImage?
    public class func frameWith(image: UIImage) -> SwiftImageFrame {
        let frame = SwiftImageFrame.init()
        frame.image = image
        return frame
    }
    
}

class SwiftImageCoder: NSObject {
    public private(set) var data: Data?
    public private(set) var type: SwiftImageType?
    public private(set) var scale: CGFloat?
    public private(set) var frameCount: Int?
    public private(set) var loopCount: Int?
    public private(set) var width: Int?
    public private(set) var height: Int?
    public private(set) var isFinalized: Bool?
    
}

extension SwiftImageCoder {
    convenience init(scale: CGFloat) {
        self.init()
    }
    public class func decoder(data: Data, scale: CGFloat) -> SwiftImageCoder? {
        return nil
    }
}
extension SwiftImageCoder {
    func updateData(data: Data, final: Bool) -> Bool? {
        return nil
        
    }
    func frame(index: Int, decodeForDisplay: Bool) -> SwiftImageFrame? {
        return nil
        
    }
    func frameDuration(index: Int) -> TimeInterval? {
        return nil
        
    }
    func frameProperties(index: Int) -> [String: Any]? {
        return nil
        
    }
    func imageProperties() -> [String: Any]? {
        return nil
    }
}
