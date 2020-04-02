//
//  MaskInfo.swift
//  MaskIsseoyo
//
//  Created by Seungyeon Lee on 2020/03/13.
//  Copyright © 2020 Seungyeon Lee. All rights reserved.
//

import Foundation
import UIKit

public enum MaskRemainLevel: String {
    //    100개 이상(녹색): 'plenty' / 30개 이상 100개미만(노랑색): 'some' / 2개 이상 30개 미만(빨강색): 'few' / 1개 이하(회색): 'empty' / 판매중지: 'break'
    case plenty = "100~"
    case some = "30~100"
    case few = "~30"
    case empty = "품절"
    case breakSale = "판매완료"
    case notSupported = "정보제공안함"
    
    var markerTitle: String {
        switch self {
        case .plenty: return "충분"
        case .some: return "여유"
        case .few: return "부족"
        case .empty: return "품절"
        case .breakSale: return "판매완료"
        case .notSupported: return "정보제공안함"
        }
    }
    
    var color: UIColor {
        switch self {
        case .plenty: return UIColor.systemGreen
        case .some: return UIColor.systemYellow
        case .few: return UIColor.systemRed
        case .empty: return UIColor.systemGray
        case .breakSale: return UIColor.systemGray2
        case .notSupported: return UIColor.systemGray3
        }
    }
}
