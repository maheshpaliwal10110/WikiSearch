//
//  WSUtility.swift
//  WikiSearch
//
//  Created by mahesh kumar on 25/08/18.
//  Copyright © 2018 mahesh kumar. All rights reserved.
//

import Foundation

final class WSUtility {
    
    //MARK: To get wikipedia URL for search results
    func getWikiURL()->String? {
        if let path = Bundle.main.path(forResource: "WebServices", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            guard let _ = dict["search"] else {
                return ""
            }
            return dict["search"] as? String
        }
        return ""
    }
    
    //MARK: To get details wikipedia URL for the selected search item
    func getWikiDetailsURL()->String? {
        if let path = Bundle.main.path(forResource: "WebServices", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            guard let _ = dict["searchDetails"] else {
                return ""
            }
            return dict["searchDetails"] as? String
        }
        return ""
    }
}
