//
//  ProfileDataResponse.swift
//  InstaAssignment
//
//  Created by Pallav Trivedi on 18/07/17.
//  Copyright © 2017 Pallav Trivedi. All rights reserved.
//

import UIKit

class ProfileDataResponseVO: NSObject
{
    var profileData = [ProfileModel]()
}
extension ProfileDataResponseVO:WebServiceResponseVO
{
    func setData(response: Any)
    {
        if(response is [String:Any])
        {
            let dictionary = response as! [String:Any]
            let posts = dictionary["data"] as![[String:Any]]
            
            for post in posts
            {
                var profileModel = ProfileModel()
                
                var caption:[String:Any]?
                if((post["caption"] as? [String:Any]) != nil)
                {
                     caption = post["caption"] as? [String:Any]
                    profileModel.text = caption?["text"] as! String
                }
                else
                {
                    profileModel.text = "Text not available for this post"
                }
                profileModel.filter = post["filter"] as! String
                let images = post["images"] as! [String:Any]
                let thumbnail = images["thumbnail"] as! [String:Any]
                 profileModel.imageUrl = thumbnail["url"] as! String
                
                let likes = post["likes"] as! [String:Any]
                profileModel.likesCount = likes["count"] as! Int 
                
                profileData.append(profileModel)
            }

        }
    }
}
