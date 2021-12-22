//
//	DayTime.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class DayTime: ModelNSObj, NSCoding{

	var endTime : String!
	var multiplier : String!
	var startTime : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		endTime = dictionary["end_time"] as? String
		multiplier = dictionary["multiplier"] as? String
		startTime = dictionary["start_time"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if endTime != nil{
			dictionary["end_time"] = endTime
		}
		if multiplier != nil{
			dictionary["multiplier"] = multiplier
		}
		if startTime != nil{
			dictionary["start_time"] = startTime
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         endTime = aDecoder.decodeObject(forKey: "end_time") as? String
         multiplier = aDecoder.decodeObject(forKey: "multiplier") as? String
         startTime = aDecoder.decodeObject(forKey: "start_time") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if endTime != nil{
			aCoder.encode(endTime, forKey: "end_time")
		}
		if multiplier != nil{
			aCoder.encode(multiplier, forKey: "multiplier")
		}
		if startTime != nil{
			aCoder.encode(startTime, forKey: "start_time")
		}

	}

}
