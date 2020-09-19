//
//  StringExt.swift
//  EateryTour
//
//  Created by Khoa Vo T.A. on 9/7/20.
//  Copyright © 2020 Ha Van H.N. All rights reserved.
//

import UIKit

extension String {

   public subscript(idx: Int) -> String? {
        guard idx >= 0 && idx < count else { return nil }
        return String(self[index(startIndex, offsetBy: idx)])
    }

    public subscript(idx: Int) -> Character? {
        guard idx >= 0 && idx < count else { return nil }
        return self[index(startIndex, offsetBy: idx)]
    }

    public subscript(range: Range<Int>) -> String? {
        let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) ?? endIndex
        let higherIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex
        return String(self[lowerIndex..<higherIndex])
    }

    public subscript(range: ClosedRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) ?? endIndex
        let higherIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex
        return String(self[lowerIndex..<higherIndex])
    }

    public var length: Int {
        return count
    }

    public func trimmedLeft(characterSet set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        if let range = rangeOfCharacter(from: set.inverted) {
            return String(self[range.lowerBound ..< endIndex])
        }
        return ""
    }

    public func trimmedRight(characterSet set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        if let range = rangeOfCharacter(from: set.inverted, options: NSString.CompareOptions.backwards) {
            return String(self[startIndex ..< range.upperBound])
        }
        return ""
    }

    public func trimmed(characterSet set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        return trimmedLeft(characterSet: set).trimmedRight(characterSet: set)
    }

    public func trimmedLeftCJK() -> String {
        var text = self
        while text.first == Character("\n") || text.first == Character(" ") {
            text.removeFirst(1)
        }
        return text
    }

    public func trimmedRightCJK() -> String {
        var text = self
        while text.last == Character("\n") || text.last == Character(" ") {
            text.removeLast(1)
        }
        return text
    }

    public func trimmedCJK() -> String {
        return trimmedLeftCJK().trimmedRightCJK()
    }

    public var intValue: Int {
        return Int(self) ?? 0
    }

    public var doubleValue: Double {
        return Double(self) ?? 0.0
    }

    public var floatValue: Float {
        return Float(self) ?? 0.0
    }

    public var boolValue: Bool {
        return (self as NSString).boolValue
    }

    public func replaceKeysByValues(_ values: [String: AnyObject]) -> String {
        let str: NSMutableString = NSMutableString(string: self)
        let range = NSRange(location: 0, length: str.length)
        for (key, value) in values {
            str.replaceOccurrences(of: key, with: "\(value)", options: [.caseInsensitive, .literal], range: range)
        }
        return str as NSString as String
    }

    public func appending(path: String) -> String {
        let set = CharacterSet(charactersIn: "/")
        let left = trimmedRight(characterSet: set)
        let right = path.trimmed(characterSet: set)
        return left + "/" + right
    }

    /// The file-system path components of the receiver. (read-only)
    public var pathComponents: [String] {
        return (self as NSString).pathComponents
    }

    /// The last path component of the receiver. (read-only)
    public var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    /// The path extension, if any, of the string as interpreted as a path. (read-only)
    public var pathExtension: String {
        return (self as NSString).pathExtension
    }

    /// Initializes an NSURL object with a provided URL string. (read-only)
    public var url: URL? {
        return URL(string: self)
    }

    /// The host, conforming to RFC 1808. (read-only)
    public var host: String {
        if let url = url, let host = url.host {
            return host
        }
        return ""
    }

    // Returns a localized string, using the main bundle.

    public func localized(_ comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    /// Returns data with NSUTF8StringEncoding

    public func toData() -> Data! {
        return data(using: String.Encoding.utf8)
    }

    public func validate(_ regex: String) -> Bool {
        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
        return pre.evaluate(with: self)
    }
}

extension Character {
    public var intValue: Int {
        return (String(self) as NSString).integerValue
    }
}

extension NSMutableAttributedString {
    public func append(string: String, attributes: [NSAttributedString.Key: Any]) {
        let str = NSMutableAttributedString(string: string, attributes: attributes)
        append(str)
    }
}

extension NSMutableParagraphStyle {
    public class func defaultStyle() -> NSMutableParagraphStyle! {
        let style = NSMutableParagraphStyle()
        let defaultStyle = NSParagraphStyle.default
        style.lineSpacing = defaultStyle.lineSpacing
        style.paragraphSpacing = defaultStyle.paragraphSpacing
        style.alignment = defaultStyle.alignment
        style.firstLineHeadIndent = defaultStyle.firstLineHeadIndent
        style.headIndent = defaultStyle.headIndent
        style.tailIndent = defaultStyle.tailIndent
        style.lineBreakMode = defaultStyle.lineBreakMode
        style.minimumLineHeight = defaultStyle.minimumLineHeight
        style.maximumLineHeight = defaultStyle.maximumLineHeight
        style.baseWritingDirection = defaultStyle.baseWritingDirection
        style.lineHeightMultiple = defaultStyle.lineHeightMultiple
        style.paragraphSpacingBefore = defaultStyle.paragraphSpacingBefore
        style.hyphenationFactor = defaultStyle.hyphenationFactor
        style.tabStops = defaultStyle.tabStops
        style.defaultTabInterval = defaultStyle.defaultTabInterval
        return style
    }
}
