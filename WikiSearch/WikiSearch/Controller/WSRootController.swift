//
//  WSRootController.swift
//  WikiSearch
//
//  Created by mahesh kumar on 25/08/18.
//  Copyright © 2018 mahesh kumar. All rights reserved.
//

import Foundation
import UIKit

class WSRootController:UIViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var search:UISearchBar!
    @IBOutlet weak var errorLabel:UILabel!
    var searchTextValue:String? = nil
    var util = WSUtility()
    
    //MARK: View Life Cycle Methods
    override func viewDidLoad()
    {
        initialSetup()
    }
    
    fileprivate func initialSetup() {
        //MARK: Add Tap gesture to dismiss keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
        //MARK: Initial Configuration
        search.delegate = self
        errorLabel.isHidden = true
        searchButton.isEnabled = false
    }
    
    //MARK: Tap gesture recognized Action
    @objc func tap(sender: UITapGestureRecognizer){
        print("tapped")
        view.endEditing(true)
    }
    
    //MARK: Search Action
    @IBAction func searchAction (_ sender:Any) {
        if (search.text?.count)! >= 1 {
            errorLabel.isHidden = true
            setSearchUserDefault(searchTextValue!)
        } else {
            errorLabel.isHidden = false
            errorLabel.text = "Oops!!! Search field cann't be Empty.";
        }
    }
}

extension WSRootController : UISearchBarDelegate {
    
//MARK : Search Bar delegates and datasources
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        print("searchBarSearchButtonClicked")

        if (search.text?.count)! >= 1 {
            searchButton.sendActions(for: .touchUpInside)
        }
        else
        {
            errorLabel.isHidden = false
            errorLabel.text = "Oops!!! Search field cann't be Empty.";
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        searchTextValue = searchText
        if searchText.count >= 1 {
            searchButton.isEnabled = true
        }
    }
    func setSearchUserDefault(_ searchText:String) {
        UserDefaults.standard.set(searchTextValue, forKey: "searchText")
    }
}


