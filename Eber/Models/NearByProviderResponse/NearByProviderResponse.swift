//
//	NearByProviderResponse.swift
//
//	Create by MacPro3 on 24/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class NearByProviderResponse: Model {

	var message : String!
	var providers : [Provider]!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = (dictionary["message"] as? String) ?? ""
		providers = [Provider]()
		if let providersArray = dictionary["providers"] as? [[String:Any]]{
			for dic in providersArray{
				let value = Provider(fromDictionary: dic)
				providers.append(value)
			}
		}
		success = (dictionary["success"] as? Bool) ?? false
	}

}

class ProviderResponse{
    
    var message : String!
    var provider : Provider!
    var success : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = (dictionary["message"] as? String) ?? ""
        provider = Provider.init(fromDictionary: [:])
        if let providerData = dictionary["provider"] as? [String:Any]{
            provider = Provider(fromDictionary: providerData)
        }
        success = (dictionary["success"] as? Bool) ?? false
    }
    
}



class ProviderListResponse{
    
    var message : String!
    var provider_list : [Provider]
    var success : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = (dictionary["message"] as? String) ?? ""
       
        provider_list = [Provider]()
        if let providersArray = dictionary["provider_list"] as? [[String:Any]]{
            for dic in providersArray{
                let value = Provider(fromDictionary: dic)
                provider_list.append(value)
            }
        }
        
        success = (dictionary["success"] as? Bool) ?? false
    }
    
}
