//
//	TypeDetail.swift
//
//	Create by MacPro3 on 17/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class TypeDetail: ModelNSObj {

	var v : Int!
	var id : String!
	var createdAt : String!
	var descriptionField : String!
	var isBusiness : Int!
	var mapPinImageUrl : String!
	var priority : Int!
	var serviceType : Int!
	var typeImageUrl : String!
	var typename : String!
	var updatedAt : String!
    var isDefaultSelected : Bool = false

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = (dictionary["__v"] as? Int) ?? 0
		id = (dictionary["_id"] as? String) ?? ""
		createdAt = (dictionary["created_at"] as? String) ?? ""
		descriptionField = (dictionary["description"] as? String) ?? ""
		isBusiness = (dictionary["is_business"] as? Int) ?? 0
		mapPinImageUrl = (dictionary["map_pin_image_url"] as? String) ?? ""
		priority = (dictionary["priority"] as? Int) ?? 0
		serviceType = (dictionary["service_type"] as? Int) ?? 0
		typeImageUrl = (dictionary["type_image_url"] as? String) ?? ""
		typename = (dictionary["typename"] as? String) ?? ""
		updatedAt = (dictionary["updated_at"] as? String) ?? ""
        isDefaultSelected  = (dictionary["is_default_selected"] as? Bool) ?? false
	}

}
