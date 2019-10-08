//
//  SwiftAnimatedImageView.swift
//  Pods
//
//  Created by 李世举 on 2019/9/28.
//

import UIKit

public protocol SwiftAnimatedImageprotocol: NSObject {
    func animatedImageFrameCount() -> Int?
    func animatedImageLoopCount() -> Int?
    func animatedImageBytesPerFrame() -> Int?
    func animatedImageFrameAt(index: Int) -> UIImage?
    func animatedImageDurationAt(index: Int) -> TimeInterval?
    func animatedImageContentsRectAt(index: Int) -> CGRect?
}

extension SwiftAnimatedImageprotocol {
    func animatedImageContentsRectAt(index: Int) -> CGRect? {
        return CGRect.zero
    }
}

class SwiftAnimatedImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
