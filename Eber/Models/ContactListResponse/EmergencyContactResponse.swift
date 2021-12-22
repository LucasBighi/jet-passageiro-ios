//
//	EmergencyContactResponse.swift
//
//	Create by MacPro3 on 12/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class EmergencyContactResponse: ModelNSObj, NSCoding {

	var emergencyContactData : [EmergencyContactData]!
	var message : String!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		emergencyContactData = [EmergencyContactData]()
		if let emergencyContactDataArray = dictionary["emergency_contact_data"] as? [[String:Any]]{
			for dic in emergencyContactDataArray{
				let value = EmergencyContactData(fromDictionary: dic)
				emergencyContactData.append(value)
			}
		}
		message = dictionary["message"] as? String
		success = dictionary["success"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if emergencyContactData != nil{
			var dictionaryElements = [[String:Any]]()
			for emergencyContactDataElement in emergencyContactData {
				dictionaryElements.append(emergencyContactDataElement.toDictionary())
			}
			dictionary["emergency_contact_data"] = dictionaryElements
		}
		if message != nil{
			dictionary["message"] = message
		}
		if success != nil{
			dictionary["success"] = success
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         emergencyContactData = aDecoder.decodeObject(forKey :"emergency_contact_data") as? [EmergencyContactData]
         message = aDecoder.decodeObject(forKey: "message") as? String
         success = aDecoder.decodeObject(forKey: "success") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if emergencyContactData != nil{
			aCoder.encode(emergencyContactData, forKey: "emergency_contact_data")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if success != nil{
			aCoder.encode(success, forKey: "success")
		}

	}

}
