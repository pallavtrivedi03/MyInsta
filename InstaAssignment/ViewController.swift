//
//  ViewController.swift
//  InstaAssignment
//
//  Created by Pallav Trivedi on 18/07/17.
//  Copyright © 2017 Pallav Trivedi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var postsTableView: UITableView!
    
    let baseURL = "https://api.instagram.com/v1/users/self/media/recent/?access_token=1567827634.dcebd88.95b4f10d2ec54d6a97d733d89784fc08"
    
    var profileDataResponse:ProfileDataResponseVO?
    var filteredPosts:[Int] = []
    var isSearchActive = false
    var didReceiveResponse = false
    override func viewDidLoad() {
        super.viewDidLoad()
        postsTableView.tableFooterView = UIView.init()
        _ = callWebServiceForProfileData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func callWebServiceForProfileData()
    {
        profileDataResponse = ProfileDataResponseVO()
        ApplicationController.sharedInstance.webServiceHelper?.setCachePolicyForRequest(policy: .returnCacheDataElseLoad)
        ApplicationController.sharedInstance.webServiceHelper?.getWebServiceWith(url: baseURL, returningVO: profileDataResponse!, completionHandler: { (vo) in
            
            DispatchQueue.main.async
                {
                    self.activityIndicator.isHidden = true
                    self.loadingLabel.isHidden = true
                    self.didReceiveResponse = true
                self.postsTableView.reloadData()
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(isSearchActive == true)
        {
            return (filteredPosts.count)
        }
        else if(didReceiveResponse == true)
        {
            return (profileDataResponse?.profileData.count)!
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postsTableViewCell", for: indexPath) as! PostsTableViewCell
        var post:ProfileModel?
        if(isSearchActive == true)
        {
         post = profileDataResponse?.profileData[(filteredPosts[indexPath.row])]
        }
        else
        {
         post = profileDataResponse?.profileData[indexPath.row]
        }
        ApplicationController.sharedInstance.webServiceHelper?.setCachePolicyForRequest(policy: .returnCacheDataElseLoad)
        ApplicationController.sharedInstance.webServiceHelper?.downloadImageFromURL(url: (post?.imageUrl)!, completionHandler: { (image) in
            
            DispatchQueue.main.async
                {
                    cell.postImageView.image = image
            }
        })
        cell.captionTextLabel.text = post?.text
        cell.filterLabel.text = post?.filter
        cell.likesCountLabel.text = "\(post!.likesCount)"
        return cell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        isSearchActive = true
        loadingLabel.isHidden = true
        filteredPosts.removeAll()
        if(searchText == "")
        {
            isSearchActive = false
            loadingLabel.isHidden = true
        }
        else
        {
        for var i in 0..<profileDataResponse!.profileData.count
        {
            if profileDataResponse!.profileData[i].text.lowercased().range(of: searchText.lowercased(),options: .regularExpression) != nil
            {
                filteredPosts.append(i)
            }
        }
        }
        if(filteredPosts.count == 0 && searchText != "")
        {
            loadingLabel.text = "No results found"
            loadingLabel.isHidden = false
        }
        self.postsTableView.reloadData()
    }
}

