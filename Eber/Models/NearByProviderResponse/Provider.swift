//
//	Provider.swift
//
//	Create by MacPro3 on 24/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class Provider: Model {

	var v : Int!
	var id : String!
	var acceptedRequest : Int!
	var accountId : String!
	var address : String!
	var admintypeid : String!
	var appVersion : String!
	var bankId : String!
	var bearing : Double!
	var bio : String!
	var cancelledRequest : Int!
	var carModel : String!
	var carNumber : String!
	var city : String!
	var cityid : String!
	var completedRequest : Int!
	var country : String!
	var countryId : String!
	var countryPhoneCode : String!
	var createdAt : String!
	var deviceTimezone : String!
	var deviceToken : String!
	var deviceType : String!
	var deviceUniqueCode : String!
	var email : String!
	var firstName : String!
	var gender : String!
	var isActive : Int!
	var isApproved : Int!
	var isAvailable : Int!
	var isDocumentUploaded : Int!
	var isDocumentsExpired : Bool!
	var isPartnerApprovedByAdmin : Int!
	var isUseGoogleDistance : Bool!
	var isVehicleDocumentUploaded : Bool!
	var languages : [String]!
	var lastName : String!
	var lastTransferredDate : String!
	var locationUpdatedTime : String!
	var loginBy : String!
	var password : String!
	var phone : String!
	var picture : String!
	var providerLocation : [Double]!
	var providerPreviousLocation : [Double]!
	var providerType : Int!
	var providerTypeId : String!
	var rate : Double!
	var rateCount : Int!
	var receivedTripFromGender : [String]!
	var rejectedRequest : Int!
	var serviceType : String!
	var socialUniqueId : String!
	var startOnlineTime : String!
	var token : String!
	var totalRequest : Int!
	var uniqueId : Int!
	var updatedAt : String!
	var vehicleDetail : [VehicleDetail]!
	var wallet : Double!
	var walletCurrencyCode : String!
	var zipcode : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = (dictionary["__v"] as? Int) ?? 0
		id = (dictionary["_id"] as? String) ?? ""
		acceptedRequest = (dictionary["accepted_request"] as? Int) ?? 0
		accountId = (dictionary["account_id"] as? String) ?? ""
		address = (dictionary["address"] as? String) ?? ""
		admintypeid = (dictionary["admintypeid"] as? String) ?? ""
		appVersion = (dictionary["app_version"] as? String) ?? ""
		bankId = (dictionary["bank_id"] as? String) ?? ""
		bearing = (dictionary["bearing"] as? Double) ?? 0.0
		bio = (dictionary["bio"] as? String) ?? ""
		cancelledRequest = (dictionary["cancelled_request"] as? Int) ?? 0
		carModel = (dictionary["car_model"] as? String) ?? ""
		carNumber = (dictionary["car_number"] as? String) ?? ""
		city = (dictionary["city"] as? String) ?? ""
		cityid = (dictionary["cityid"] as? String) ?? ""
		completedRequest = (dictionary["completed_request"] as? Int) ?? 0
		country = (dictionary["country"] as? String) ?? ""
		countryId = (dictionary["country_id"] as? String) ?? ""
		countryPhoneCode = (dictionary["country_phone_code"] as? String) ?? ""
		createdAt = (dictionary["created_at"] as? String) ?? ""
		deviceTimezone = (dictionary["device_timezone"] as? String) ?? ""
		deviceToken = (dictionary["device_token"] as? String) ?? ""
		deviceType = (dictionary["device_type"] as? String) ?? ""
		deviceUniqueCode = (dictionary["device_unique_code"] as? String) ?? ""
		email = (dictionary["email"] as? String) ?? ""
		firstName = (dictionary["first_name"] as? String) ?? ""
		gender = (dictionary["gender"] as? String) ?? ""
		isActive = (dictionary["is_active"] as? Int) ?? 0
		isApproved = (dictionary["is_approved"] as? Int) ?? 0
		isAvailable = (dictionary["is_available"] as? Int) ?? 0
		isDocumentUploaded = (dictionary["is_document_uploaded"] as? Int) ?? 0
		isDocumentsExpired = (dictionary["is_documents_expired"] as? Bool) ?? false
		isPartnerApprovedByAdmin = (dictionary["is_partner_approved_by_admin"] as? Int) ?? 0
		isUseGoogleDistance = (dictionary["is_use_google_distance"] as? Bool) ?? false
		isVehicleDocumentUploaded = (dictionary["is_vehicle_document_uploaded"] as? Bool) ?? false
		languages = (dictionary["languages"] as? [String]) ?? []
		lastName = (dictionary["last_name"] as? String) ?? ""
		lastTransferredDate = (dictionary["last_transferred_date"] as? String) ?? ""
		locationUpdatedTime = (dictionary["location_updated_time"] as? String) ?? ""
		loginBy = (dictionary["login_by"] as? String) ?? ""
		password = (dictionary["password"] as? String) ?? ""
		phone = (dictionary["phone"] as? String) ?? ""
		picture = (dictionary["picture"] as? String) ?? ""
		providerLocation = (dictionary["providerLocation"] as? [Double]) ?? [0.0,0.0]
		providerPreviousLocation = (dictionary["providerPreviousLocation"] as? [Double]) ?? [0.0,0.0]
		providerType = (dictionary["provider_type"] as? Int) ?? 0
		providerTypeId = (dictionary["provider_type_id"] as? String) ?? ""
		rate = (dictionary["rate"] as? Double) ?? 0.0
		rateCount = (dictionary["rate_count"] as? Int) ?? 0
		receivedTripFromGender = (dictionary["received_trip_from_gender"] as? [String]) ?? []
		rejectedRequest = (dictionary["rejected_request"] as? Int) ?? 0
		serviceType = (dictionary["service_type"] as? String) ?? ""
		socialUniqueId = (dictionary["social_unique_id"] as? String) ?? ""
		startOnlineTime = (dictionary["start_online_time"] as? String) ?? ""
		token = (dictionary["token"] as? String) ?? ""
		totalRequest = (dictionary["total_request"] as? Int) ?? 0
		uniqueId = (dictionary["unique_id"] as? Int) ?? 0
		updatedAt = (dictionary["updated_at"] as? String) ?? ""
		vehicleDetail = [VehicleDetail]()
		if let vehicleDetailArray = (dictionary["vehicle_detail"] as? [[String:Any]]){
			for dic in vehicleDetailArray{
				let value = VehicleDetail(fromDictionary: dic)
				vehicleDetail.append(value)
			}
		}
		wallet = (dictionary["wallet"] as? Double) ?? 0.0
		walletCurrencyCode = (dictionary["wallet_currency_code"] as? String) ?? ""
		zipcode = (dictionary["zipcode"] as? String) ?? ""
	}

}
