//
//	Language.swift
//
//	Create by MacPro3 on 15/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class Language: Model {

	var v : Int!
	var id : String!
	var code : String!
	var createdAt : String!
	var name : String!
	var uniqueId : Int!
	var updatedAt : String!
    var isSelected:Bool = false

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = (dictionary["__v"] as? Int) ?? 0
		id = (dictionary["_id"] as? String) ?? ""
		code = (dictionary["code"] as? String) ?? ""
		createdAt = (dictionary["created_at"] as? String) ?? ""
		name = (dictionary["name"] as? String) ?? ""
		uniqueId = (dictionary["unique_id"] as? Int) ?? 0
		updatedAt = (dictionary["updated_at"] as? String) ?? ""
	}
}
