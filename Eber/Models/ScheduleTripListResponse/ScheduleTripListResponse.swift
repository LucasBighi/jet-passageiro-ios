//
//	ScheduleTripListResponse.swift
//
//	Create by MacPro3 on 6/10/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class ScheduleTripListResponse: Model {

	var message : String!
	var scheduledtrip : [Trip]!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? String
		scheduledtrip = [Trip]()
		if let scheduledtripArray = dictionary["scheduledtrip"] as? [[String:Any]]{
			for dic in scheduledtripArray{
				let value = Trip(fromDictionary: dic)
				scheduledtrip.append(value)
			}
		}
		success = dictionary["success"] as? Bool
	}

}
