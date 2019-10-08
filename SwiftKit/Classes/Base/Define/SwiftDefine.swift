//
//  SwiftDefine.swift
//  Pods
//
//  Created by 李世举 on 2019/9/29.
//

import Foundation


//MARK: - frame 相关
/************************  屏幕尺寸  ***************************/
public enum App {
    
    public static let ScreenBounds = UIScreen.main.bounds
    
    // 屏幕宽度
    public static let ScreenWidth = ScreenBounds.size.width
    
    // 屏幕高度
    public static let ScreenHeight = ScreenBounds.size.height
    
    // iPhone4
    public static let iPhone4 = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 960).equalTo((UIScreen.main.currentMode?.size)!) : false)
    // iPhone 5
    public static let iPhone5 = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 1136).equalTo((UIScreen.main.currentMode?.size)!) : false)
    // iPhone 6、7、8
    public static let iPhone6 =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 750, height: 1334).equalTo((UIScreen.main.currentMode?.size)!) : false)
    // iPhone 6p、7p、8p
    public static let iPhone6P =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo((UIScreen.main.currentMode?.size)!) : false)
    // iPhone 6p、7p、8p 放大模式
    public static let iPhone6P_scape =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2001).equalTo((UIScreen.main.currentMode?.size)!) : false)
    // iPhone X、XS、11p
    public static let iPhoneX =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) : false)
    // iPhone XR、11
    public static let iPhoneXR =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 828, height: 1792).equalTo((UIScreen.main.currentMode?.size)!) : false)
    // iPhone XMax、11pMax
    public static let iPhoneXMax =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2688).equalTo((UIScreen.main.currentMode?.size)!) : false)
    
    // navigationBarHeight
    public static let kNavigationBarHeight : CGFloat = iPhoneX ? 88 : 64
    
    // tabBarHeight
    public static let kTabBarHeight : CGFloat = iPhoneX ? 49 + 34 : 49
    
    /** 如果是iPhoneX按照Plus 尺寸计算比例 */
    public static let Scale_Height = iPhoneX ? 736.0/667.0 : ScreenHeight / 667
    public static let Scale_Width = ScreenWidth / 375
    
}
//MARK: - 设置颜色
/************************  AppColor 相关  ***************************/

public enum AppColor {
    
    static public let clear = UIColor.clear
    
    //APP主题色
    static public let themeRed = RGB0X(hexValue: 0xfd2e2e)
    //APP红色
    static public let red = RGB0X(hexValue: 0xff2323)
    //APP蓝色
    static public let blue = RGB0X(hexValue: 0x488ff0)
    //APP黑色
    static public let black = RGB0X(hexValue: 0x333333)
    //APP深灰色
    static public let darkgGray = RGB0X(hexValue: 0x666666)
    //APP灰色
    static public let gray = RGB0X(hexValue: 0xf9f9f9)
    //APP轻灰色
    static public let lightGray = RGB0X(hexValue: 0xf5f5f5)
}

/// RGBA的颜色设置
public func RGB(_ r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}

public func RGBA(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

public func HEXA(hexValue: Int, a: CGFloat) -> (UIColor) {
    return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(hexValue & 0xFF)) / 255.0,
                   alpha: a)
}

public func RGB0X(hexValue: Int) -> (UIColor) {
    return HEXA(hexValue: hexValue, a: 1.0)
}
public func colorWithHexString(hexStr : String) -> UIColor {
    return colorWithHexString(hexStr: hexStr, a: 1.0)
}
public func colorWithHexString(hexStr : String, a: CGFloat) -> UIColor {
    var Color = UIColor.red
    var CStr : String = hexStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    
    if CStr.hasPrefix("#") {
        let index = CStr.index(after: CStr.startIndex)
        CStr = String(CStr[index...])
    }
    if CStr.count != 6 {
        return UIColor.white
    }
    let rRange = CStr.startIndex ..< CStr.index(CStr.startIndex, offsetBy: 2)
    let rStr = String(CStr[rRange])
    
    let gRange = CStr.index(CStr.startIndex, offsetBy: 2) ..< CStr.index(CStr.startIndex, offsetBy: 4)
    let gStr = String(CStr[gRange])
    
    let bIndex = CStr.index(CStr.endIndex, offsetBy: -2)
    let bStr = String(CStr[bIndex...])
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rStr).scanHexInt32(&r)
    Scanner(string: gStr).scanHexInt32(&g)
    Scanner(string: bStr).scanHexInt32(&b)
    
    Color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    return Color
}
//MARK: - 字体 相关
/************************  字体 相关  ***************************/
public func FONT(font: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: font)
}

//MARK: - 语言 相关
/************************  语言 相关 ***************************/
/// 系统语言
public func getCurrentLanguage() -> String {
    if let appLanguages = Locale.preferredLanguages.first, appLanguages.contains("zh-Hans") {
        return "zh-Hans"
    }
    return "en"
}
/// 判断系统语言是否是简体中文
public func isChineseLanguage() -> Bool {
    let appLanguages = getCurrentLanguage()
    if appLanguages.contains("zh-Hans") {
        return true
    }
    return false
}


// MARK: ============================================================================
// MARK: Dictory Array Strig Object 闭包方式
///过滤null对象
public let kFilterNullOfObj:((Any)->Any?) = {(obj: Any) -> Any? in
    if obj is NSNull {
        return nil
    }
    return obj
}

///过滤null的字符串，当nil时返回一个初始化的空字符串
public let kFilterNullOfString:((Any)->String) = {(obj: Any) -> String in
    if obj is String {
        return obj as! String
    }
    return ""
}

/// 过滤null的数组，当nil时返回一个初始化的空数组
public let kFilterNullOfArray:((Any)->Array<Any>) = {(obj: Any) -> Array<Any> in
    if obj is Array<Any> {
        return obj as! Array<Any>
    }
    return Array()
}

/// 过滤null的字典，当为nil时返回一个初始化的字典
public let kFilterNullOfDictionary:((Any) -> Dictionary<AnyHashable, Any>) = {( obj: Any) -> Dictionary<AnyHashable, Any> in
    if obj is Dictionary<AnyHashable, Any> {
        return obj as! Dictionary<AnyHashable, Any>
    }
    return Dictionary()
}

