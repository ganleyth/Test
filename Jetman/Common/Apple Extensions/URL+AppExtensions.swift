//
//  URL+AppExtensions.swift
//  Jetman
//
//  Created by Thomas Ganley on 4/21/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import Foundation

extension URL {
    func getURLParameters() -> [String: String]? {
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let params = components?.queryItems?.reduce([String: String]()) { (result: [String: String], queryItem: URLQueryItem) in
            var mutableResult = result
            mutableResult[queryItem.name] = queryItem.value
            return mutableResult
        }
        
        return params
    }
}
