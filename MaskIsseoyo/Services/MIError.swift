//
//  APIError.swift
//  MaskIsseoyo
//
//  Created by Seungyeon Lee on 2020/03/19.
//  Copyright © 2020 Seungyeon Lee. All rights reserved.
//

import Foundation

public enum MIError: Error {
    case noData
    case server
    case parsing
    case error(error: Error)
}

extension MIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData: return "반경 \(String(Constants.meter))이내에 마스크 판매점이 없습니다.😢"
        case .server: return "Http Response Error"
        case .parsing: return "데이터 parsing에 실패했습니다."
        case .error: return self.errorDescription
        }
    }
}
