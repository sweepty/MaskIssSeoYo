//
//  Stores.swift
//  MaskIsseoyo
//
//  Created by Seungyeon Lee on 2020/03/12.
//  Copyright © 2020 Seungyeon Lee. All rights reserved.
//

import Foundation
import CoreLocation

struct StoreResult: Decodable {
    var count: Int
    var stores: [Store]
}

/// Store struct
struct Store: Decodable {
    // 주소
    var addr: String
    // 식별 코드
    var code: String
    // 데이터 생성 일자 YYYY/MM/DD HH:mm:ss
    var createdAt: String?
    // 위도
    var lat: Double
    // 경도
    var lng: Double
    // 이름
    var name: String
    // 재고 상태
    /*
     100개 이상(녹색): 'plenty'
     30개 이상 100개미만(노랑색): 'some'
     2개 이상 30개 미만(빨강색): 'few'
     1개 이하(회색): 'empty'
     판매중지: 'break'
     */
    var remainStat: String?
    // 입고 시간 YYYY/MM/DD HH:mm:ss
    var stockAt: String?
    // 판매처 유형
    // 약국: '01', 우체국: '02', 농협: '03'
    var type: String
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: lat,
            longitude: lng)
    }
    
    var maskRemainLevel: MaskRemainLevel {
        switch remainStat {
        case "plenty": return .plenty
        case "some": return .some
        case "few": return .few
        case "empty": return .empty
        case "break": return .breakSale
        default: return .notSupported
        }
    }
}


struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}
