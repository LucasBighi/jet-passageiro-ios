//
//	HistoryResponse.swift
//
//	Create by MacPro3 on 12/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class HistoryResponse: ModelNSObj, NSCoding{

	var success : Bool!
	var trips : [HistoryTrip]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		success = dictionary["success"] as? Bool
		trips = [HistoryTrip]()
		if let tripsArray = dictionary["trips"] as? [[String:Any]]{
			for dic in tripsArray{
				let value = HistoryTrip(fromDictionary: dic)
				trips.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if success != nil{
			dictionary["success"] = success
		}
		if trips != nil{
			var dictionaryElements = [[String:Any]]()
			for tripsElement in trips {
				dictionaryElements.append(tripsElement.toDictionary())
			}
			dictionary["trips"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         success = aDecoder.decodeObject(forKey: "success") as? Bool
         trips = aDecoder.decodeObject(forKey :"trips") as? [HistoryTrip]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if success != nil{
			aCoder.encode(success, forKey: "success")
		}
		if trips != nil{
			aCoder.encode(trips, forKey: "trips")
		}

	}

}
