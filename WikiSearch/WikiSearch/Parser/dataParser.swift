//
//  dataParser.swift
//  WikiSearch
//
//  Created by mahesh kumar on 25/08/18.
//  Copyright © 2018 mahesh kumar. All rights reserved.
//

import Foundation

class dataParser {

    func searchDataParser(response:[String : Any])->[WSSearchModel]?
    {
        if let jsonArray = response["query"] as? [String : Any]
        {
            let search = jsonArray["pages"]
            var dataSource:[WSSearchModel] = [WSSearchModel]()
            for details in search as! [[String:Any]]
            {
                let res = WSSearchModel()

                if (details["title"] != nil) {
                    res.title = details["title"] as? String
                }

                if (details["thumbnail"] != nil)
                {
                    let temp = details["thumbnail"] as! [String
                        : Any]
                    if(temp["source"] != nil) {
                        res.thumbnail = temp["source"] as? String;
                    }
                }

                if (details["terms"] != nil)
                {
                    let temp = details["terms"] as! [String
                        : Any]
                    if(temp["description"] != nil)
                    {
                        let descr:Array =  temp["description"] as! [String]
                        if descr.count > 0 {
                            res.detailDesc = descr[0]
                        }
                    }
                }
            dataSource.append(res)
        }
        return dataSource
      }
        return []
    }
}


