//
//  WSView.swift
//  WikiSearch
//
//  Created by mahesh kumar on 25/08/18.
//  Copyright © 2018 mahesh kumar. All rights reserved.
//

import Foundation
import WebKit

class WSView:UIViewController,UIWebViewDelegate
{
    @IBOutlet weak var webView:WKWebView!
    @IBOutlet weak var errorLabel:UILabel!

    private let utility = WSUtility()

    //MARK: View Life Cycle Methods
    override func viewDidLoad()
    {
        if let val:String = UserDefaults.standard.object(forKey: "searchDetails") as? String
        {
            errorLabel.isHidden = true
            webView.isHidden    = false

            var urlPath = utility.getWikiDetailsURL()
            urlPath = urlPath?.replacingOccurrences(of: "title", with: val)
            urlPath = urlPath?.replacingOccurrences(of: " ", with: "_")
            let request = NSURLRequest(url: URL(string: urlPath!)!)
            self.webView.navigationDelegate = self as? WKNavigationDelegate
            
            webView.load(request as URLRequest)
        } else {
            errorLabel.isHidden = false
            webView.isHidden = true
        }
    }
}
