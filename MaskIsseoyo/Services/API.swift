//
//  API.swift
//  MaskIsseoyo
//
//  Created by Seungyeon Lee on 2020/03/12.
//  Copyright © 2020 Seungyeon Lee. All rights reserved.
//

import Foundation
import MapKit

class API {
    static func storesByGeo(coordinate: CLLocationCoordinate2D, meter: Int = Constants.meter, completionHandler: @escaping(Result<[Store], MIError>) -> Void) {
        let decoder = Parser.jsonDecoder

        let myBaseURL = URL(string: "\(Constants.baseURL)?lat=\(String(coordinate.latitude))&lng=\(String(coordinate.longitude))&m=\(meter)")!
        let task = URLSession.shared.dataTask(with: myBaseURL) { data, response, error in
            if let error = error {
                completionHandler(.failure(MIError.error(error: error)))
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    completionHandler(.failure(MIError.server))
                    return
            }
            
            guard let responseData = data else {
                completionHandler(.failure(MIError.noData))
                return
            }
            
            if let storeList = try? decoder.decode(StoreResult.self, from: responseData) {
                print("result count: \(storeList.count)")
                if storeList.count > 0 {
                    completionHandler(.success(storeList.stores))
                } else {
                    completionHandler(.failure(MIError.noData))
                }
            } else { // parse error, no data... lat, lng err
                completionHandler(.failure(MIError.noData))
            }
        }
        task.resume()
    }
}


struct APIError: Error {
    
}
