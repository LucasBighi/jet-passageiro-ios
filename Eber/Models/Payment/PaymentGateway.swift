//
//	PaymentGateway.swift
//
//	Create by MacPro3 on 14/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class PaymentGateway: Model {

	var id : Int!
	var name : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = (dictionary["id"] as? Int) ?? 0
        name = (dictionary["name"] as? String) ?? ""
        
	}

}

