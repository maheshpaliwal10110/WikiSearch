//
//  WSResultsController.swift
//  WikiSearch
//
//  Created by mahesh kumar on 25/08/18.
//  Copyright © 2018 mahesh kumar. All rights reserved.
//

import UIKit

class WSResultsController: UIViewController
{
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    @IBOutlet weak var search:UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorLabel:UILabel!

    private let restInterface = RestInterface()
    private let util          = WSUtility()

    var dataSource:[WSSearchModel] = [WSSearchModel]()

    // Doing search call to fetch the response
    fileprivate func doSearchCall() {
        
        self.errorLabel.isHidden = true
        self.activityIndicator.isHidden = false
        restInterface.searchCall(searchText: search.text!, completionHandler:{ response in
            self.dataSource = response
            // store the data in the data source for binding the collection view
            if self.dataSource.count>0
            {
                DispatchQueue.main.async {
                    self.collectionView.isHidden = false
                    self.activityIndicator.isHidden = true

                    self.collectionView.reloadData()
                }
            } else
            { // If data is not available , show the no data label message
                 DispatchQueue.main.async {
                    self.errorLabel.isHidden = false
                    self.activityIndicator.isHidden = true
                    self.collectionView.isHidden = true
                }
            }
        })
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        search.delegate            = self
        collectionView.isHidden    = true
        errorLabel.isHidden        = true
        activityIndicator.isHidden = false

        //read the search string
        search.text = UserDefaults.standard.object(forKey: "searchText") as? String

        //do setup cell id for collection view
        self.collectionView.register(UINib(nibName: "WSCell", bundle: nil), forCellWithReuseIdentifier: "WikiCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doSearchCall()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension WSResultsController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell:WSCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WikiCell", for: indexPath) as! WSCell
        let searchDetails:WSSearchModel = dataSource[indexPath.row]
        
        cell.title.text             = searchDetails.title
        cell.detailDescription.text = searchDetails.detailDesc
        cell.detailDescription.textContainer.maximumNumberOfLines = 2
        cell.detailDescription.textContainer.lineBreakMode = .byTruncatingTail

        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            if searchDetails.thumbnail != nil{
                let imageData = try! Data(contentsOf: URL(string: searchDetails.thumbnail!)!)
                cell.thumbImage.image   = UIImage(data: imageData)
            }
            else {
                cell.thumbImage.image = UIImage(named: "NoImageAvailable")
            }
        }else{
            print("Internet Connection not Available!")
                cell.thumbImage.image = UIImage(named: "NoImageAvailable")
        }
        
        
        
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //Launch details view : webview
        let searchDetails = dataSource[indexPath.row]
        UserDefaults.standard.setValue(searchDetails.title, forKey:"searchDetails")
        let storageVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsView") as! WSView
        self.navigationController?.pushViewController(storageVC, animated: true)
    }
}
extension WSResultsController :UISearchBarDelegate
{

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        //Calling API
        if (search.text?.count)! >= 1 {
            doSearchCall()
        }else {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter the string or character";
        }
    }
}
