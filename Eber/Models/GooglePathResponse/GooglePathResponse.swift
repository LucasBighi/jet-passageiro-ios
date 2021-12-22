//
//	GooglePathResponse.swift
//
//	Create by MacPro3 on 3/10/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class GooglePathResponse: Model {

	var success : Bool!
	var triplocation : Triplocation!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		success = dictionary["success"] as? Bool
		if let triplocationData = dictionary["triplocation"] as? [String:Any]{
			triplocation = Triplocation(fromDictionary: triplocationData)
		}
	}

}
