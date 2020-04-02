//
//  Parser.swift
//  MaskIsseoyo
//
//  Created by Seungyeon Lee on 2020/03/13.
//  Copyright © 2020 Seungyeon Lee. All rights reserved.
//

import Foundation

class Parser {
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        
        return jsonDecoder
    }()
}
