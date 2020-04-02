//
//  DateFormatter+Extension.swift
//  MaskIsseoyo
//
//  Created by Seungyeon Lee on 2020/03/18.
//  Copyright © 2020 Seungyeon Lee. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.calendar = Calendar.init(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.autoupdatingCurrent
        
        return dateFormatter
    }()
}
