//
//  RestInterface.swift
//  WikiSearch
//
//  Created by mahesh kumar on 25/08/18.
//  Copyright © 2018 mahesh kumar. All rights reserved.
//

import Foundation
import UIKit

class RestInterface:NSObject {
    
    private let util  = WSUtility()
    private let restConnector = RestConnetor()
    private let dataParse = dataParser()
    
    func add(i:Int, j:Int) ->Int{
        return i+j
    }
    func searchCall(searchText: String,completionHandler: @escaping (_ response: [WSSearchModel]) -> ())
    {
        var searchUrl = util.getWikiURL()
        
        searchUrl = searchUrl?.replacingOccurrences(of:"gpssearch=" , with:"gpssearch="+searchText)
        searchUrl = searchUrl?.replacingOccurrences(of:" " , with:"_")
        
        let  request         = URLRequest(url: URL(string:searchUrl!)!) as! NSMutableURLRequest
        
        if Reachability.isConnectedToNetwork(){
            
            restConnector.restCall(request: request, completionHandler: { result, error in
                if error != nil {
                    let res:[WSSearchModel] = WSSharedDataManager.sharedInstance.getDataByText(text: searchText) as! [WSSearchModel]
                    completionHandler(res)
                }
                else
                {
                    let res:[WSSearchModel] = self.dataParse.searchDataParser(response: result! as! [String : Any])!
                    WSSharedDataManager.sharedInstance.saveArrayOfDataInDb(dataArray: res, searchText: searchText)
                    completionHandler(res)
                }
                
            })
        }else {
            let res:[WSSearchModel] = WSSharedDataManager.sharedInstance.getDataByText(text: searchText) as! [WSSearchModel]
            completionHandler(res)
            
        }
    }
}
