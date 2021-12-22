//
//	VehicleDetail.swift
//
//	Create by MacPro3 on 24/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class VehicleDetail: Model {

	var id : String!
	var accessibility : [String]!
	var adminTypeId : String!
	var color : String!
	var isDocumentsExpired : Bool!
	var isSelected : Bool!
	var model : String!
	var name : String!
	var passingYear : String!
	var plateNo : String!
	var serviceType : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = (dictionary["_id"] as? String) ?? ""
		accessibility = (dictionary["accessibility"] as? [String]) ?? []
		adminTypeId = (dictionary["admin_type_id"] as? String) ?? ""
		color = (dictionary["color"] as? String) ?? ""
		isDocumentsExpired = (dictionary["is_documents_expired"] as? Bool) ?? false
		isSelected = (dictionary["is_selected"] as? Bool) ?? false
		model = (dictionary["model"] as? String) ?? ""
		name = (dictionary["name"] as? String) ?? ""
		passingYear = (dictionary["passing_year"] as? String) ?? ""
		plateNo = (dictionary["plate_no"] as? String) ?? ""
		serviceType = (dictionary["service_type"] as? String) ?? ""
	}

}
