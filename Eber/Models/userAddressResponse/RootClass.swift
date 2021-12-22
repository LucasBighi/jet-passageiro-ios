//
//	RootClass.swift
//
//	Create by MacPro3 on 17/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class UserAddresResponse: Model {

	var success : Bool!
	var userAddress : UserAddress!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		success = dictionary["success"] as? Bool
		if let userAddressData = dictionary["user_address"] as? [String:Any]{
			userAddress = UserAddress(fromDictionary: userAddressData)
		}
	}

}
