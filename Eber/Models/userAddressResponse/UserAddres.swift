//
//	UserAddres.swift
//
//	Create by MacPro3 on 17/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class UserAddress: Model {

	var id : String!
	var homeAddress : String!
	var homeLocation : [Double]!
	var workAddress : String!
	var workLocation : [Double]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = (dictionary["_id"] as? String) ?? ""
		homeAddress = (dictionary["home_address"] as? String) ?? ""
		homeLocation = (dictionary["home_location"] as? [Double]) ?? [0.0,0.0]
		workAddress = (dictionary["work_address"] as? String) ?? ""
		workLocation = (dictionary["work_location"] as? [Double]) ?? [0.0,0.0]
	}

}
