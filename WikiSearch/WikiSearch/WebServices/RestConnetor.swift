//
//  RestConnetor.swift
//  WikiSearch
//
//  Created by mahesh kumar on 25/08/18.
//  Copyright © 2018 mahesh kumar. All rights reserved.
//

import Foundation

class RestConnetor: NSObject {
var errorMessage = ""

func restCall(request: NSMutableURLRequest, completionHandler: @escaping (_ data: NSDictionary?,_ error: Error?) -> ())
    {
        let  dataTask = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data,  response,  error in
            do {
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                    completionHandler(nil, error)
                }
                else if let data = data
                {
                    let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    guard let arrayForDataWithKey = result else {
                        print("Not a Dictionary")
                        return
                    }
                    completionHandler(arrayForDataWithKey as NSDictionary, error)
                }
            } catch let parseError as NSError {
                print("JSON Error \(parseError.localizedDescription)")
            }
        }
        dataTask.resume()
    }
}
