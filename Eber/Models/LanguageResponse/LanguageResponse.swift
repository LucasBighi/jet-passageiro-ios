//
//	Card.swift
//
//	Create by MacPro3 on 15/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class LanguageResponse: Model {

	var languages : [Language]!
	var message : String!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		languages = [Language]()
		if let languagesArray = dictionary["languages"] as? [[String:Any]]{
			for dic in languagesArray{
				let value = Language(fromDictionary: dic)
				languages.append(value)
			}
		}
		message = (dictionary["message"] as? String) ?? ""
		success = (dictionary["success"] as? Bool) ?? false
	}

}
