//
//  WSSharedDataManager.swift
//  WikiSearch
//
//  Created by mahesh kumar on 26/08/18.
//  Copyright © 2018 mahesh kumar. All rights reserved.
//

import UIKit
import Foundation
import CoreData

final class WSSharedDataManager : NSObject{
    static let sharedInstance = WSSharedDataManager()
    private override init() {}
    
    public func saveDataInDb(data:WSSearchModel, searchText : String){
        let context = (UIApplication.shared.delegate as! WSAppDelegate).persistentContainer.viewContext
        let searchResultDb = SearchResults(context: context)
        searchResultDb.title = data.title
        searchResultDb.thumbURL = data.thumbnail
        searchResultDb.desc = data.detailDesc
        searchResultDb.srchtext = searchText
        // Save the data to coredata
        (UIApplication.shared.delegate as! WSAppDelegate).saveContext()

    }
    
    public func saveArrayOfDataInDb(dataArray:[WSSearchModel], searchText : String)
    {
        print("saving started")
        for item in dataArray {
            self.saveDataInDb(data: item, searchText: searchText)
        }
        print("saving completed")
    }
    
    public func getDataByText(text:String) ->Array<Any>?
    {
        
        let context = (UIApplication.shared.delegate as! WSAppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchResults")

        let predicate = NSPredicate(format: "srchtext LIKE[cd] %@",text)
        fetchRequest.predicate = predicate
        do{
            let dataArray:[SearchResults] =  try context.fetch(fetchRequest) as! [SearchResults]
            var resArray : [WSSearchModel] = []
            for item:SearchResults in dataArray {
                let res : WSSearchModel = WSSearchModel()
                res.title = item.title
                res.thumbnail = item.thumbURL
                res.detailDesc = item.desc
                
                resArray.append(res)
            }
            
            return resArray
        }catch
        {
            return nil
        }
    }
    
}
