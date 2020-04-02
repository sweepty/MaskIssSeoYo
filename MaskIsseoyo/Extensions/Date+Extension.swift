//
//  Date+Extension.swift
//  MaskIsseoyo
//
//  Created by Seungyeon Lee on 2020/03/18.
//  Copyright © 2020 Seungyeon Lee. All rights reserved.
//

import Foundation

extension Date {
    func convertAgo() -> String {
        let now = Date()
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Locale.init(identifier: "ko_kr")

        let result = formatter.localizedString(for: self, relativeTo: now)
        return result
    }
}
