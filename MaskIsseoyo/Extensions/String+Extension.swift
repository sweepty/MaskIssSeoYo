//
//  String+Extension.swift
//  MaskIsseoyo
//
//  Created by Seungyeon Lee on 2020/03/18.
//  Copyright © 2020 Seungyeon Lee. All rights reserved.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter.yyyyMMdd
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let date = dateFormatter.date(from: self)
        return date
    }
}
