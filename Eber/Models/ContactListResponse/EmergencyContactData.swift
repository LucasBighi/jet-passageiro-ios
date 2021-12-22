//
//	EmergencyContactData.swift
//
//	Create by MacPro3 on 12/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class EmergencyContactData: ModelNSObj, NSCoding {


	var id : String!
	var createdAt : String!
	var isAlwaysShareRideDetail : Int!
	var name : String!
	var phone : String!
	var updatedAt : String!
	var userId : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){

		id = (dictionary["_id"] as? String) ?? ""
		createdAt = (dictionary["created_at"] as? String) ?? ""
		isAlwaysShareRideDetail = (dictionary["is_always_share_ride_detail"] as? Int) ?? 1
		name = (dictionary["name"] as? String) ?? ""
		phone = (dictionary["phone"] as? String) ?? ""
		updatedAt = (dictionary["updated_at"] as? String) ?? ""
		userId = (dictionary["user_id"] as? String) ?? ""
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
	
		if id != nil{
			dictionary["_id"] = id
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if isAlwaysShareRideDetail != nil{
			dictionary["is_always_share_ride_detail"] = isAlwaysShareRideDetail
		}
		if name != nil{
			dictionary["name"] = name
		}
		if phone != nil{
			dictionary["phone"] = phone
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if userId != nil{
			dictionary["user_id"] = userId
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
       
         id =  (aDecoder.decodeObject(forKey: "_id") as? String) ?? ""
         createdAt =  (aDecoder.decodeObject(forKey: "created_at") as? String) ?? ""
         isAlwaysShareRideDetail =  (aDecoder.decodeObject(forKey: "is_always_share_ride_detail") as? Int) ?? 1
         name =  (aDecoder.decodeObject(forKey: "name") as? String) ?? ""
         phone =  (aDecoder.decodeObject(forKey: "phone") as? String) ?? ""
         updatedAt =  (aDecoder.decodeObject(forKey: "updated_at") as? String) ?? ""
         userId =  (aDecoder.decodeObject(forKey: "user_id") as? String) ?? ""

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
	
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if isAlwaysShareRideDetail != nil{
			aCoder.encode(isAlwaysShareRideDetail, forKey: "is_always_share_ride_detail")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}
