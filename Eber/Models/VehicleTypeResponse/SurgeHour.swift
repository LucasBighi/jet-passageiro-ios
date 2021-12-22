//
//	SurgeHour.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class SurgeHour: ModelNSObj, NSCoding{

	var day : String!
	var dayTime : [DayTime]!
	var isSurge : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		day = dictionary["day"] as? String
		dayTime = [DayTime]()
		if let dayTimeArray = dictionary["day_time"] as? [[String:Any]]{
			for dic in dayTimeArray{
				let value = DayTime(fromDictionary: dic)
				dayTime.append(value)
			}
		}
		isSurge = dictionary["is_surge"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if day != nil{
			dictionary["day"] = day
		}
		if dayTime != nil{
			var dictionaryElements = [[String:Any]]()
			for dayTimeElement in dayTime {
				dictionaryElements.append(dayTimeElement.toDictionary())
			}
			dictionary["day_time"] = dictionaryElements
		}
		if isSurge != nil{
			dictionary["is_surge"] = isSurge
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         day = aDecoder.decodeObject(forKey: "day") as? String
         dayTime = aDecoder.decodeObject(forKey :"day_time") as? [DayTime]
         isSurge = aDecoder.decodeObject(forKey: "is_surge") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if day != nil{
			aCoder.encode(day, forKey: "day")
		}
		if dayTime != nil{
			aCoder.encode(dayTime, forKey: "day_time")
		}
		if isSurge != nil{
			aCoder.encode(isSurge, forKey: "is_surge")
		}

	}

}
