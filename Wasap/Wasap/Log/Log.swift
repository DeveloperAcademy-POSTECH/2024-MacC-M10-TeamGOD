//
//  Log.swift
//  Wasap
//
//  Created by chongin on 9/17/24.
//

import Foundation

public struct Log {
    /// 단순 print
    public static func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        let output = items.map { "\($0)" }.joined(separator: separator)
        print("🪵 [\(getCurrentTime())] \(output)", terminator: terminator)
    }

    /// 상세 내용 출력 : debug
    public static func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        debugPrintWithTime("🗣", items, separator: separator, terminator: terminator)
    }

    /// 상세 내용 출력 : warning
    public static func warning(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        debugPrintWithTime("⚠️", items, separator: separator, terminator: terminator)
    }

    /// 상세 내용 출력 : error
    public static func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        debugPrintWithTime("🚨", items, separator: separator, terminator: terminator)
    }

    private static func debugPrintWithTime(_ icon: String, _ items: Any..., separator: String = " ", terminator: String = "\n") {
        let output = items.map { "\($0)" }.joined(separator: separator)
        debugPrint("\(icon) [\(getCurrentTime())] \(output)", terminator: terminator)
    }

    private static func getCurrentTime() -> String {
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter.string(from: now as Date)
    }
}
