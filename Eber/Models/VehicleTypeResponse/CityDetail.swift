//
//	CityDetail.swift
//
//	Create by MacPro3 on 17/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class CityDetail: ModelNSObj {

	var v : Int!
	var id : String!
	var airportBusiness : Int!
	var cityLatLong : [Float]!
	var cityRadius : Int!
	var cityBusiness : Int!
	var cityLocations : [[Float]]!
	var citycode : String!
	var cityname : String!
	var countryid : String!
	var countryname : String!
	var createdAt : String!
	var dailyCronDate : String!
	var destinationCity : [AnyObject]!
	var fullCityname : String!
	var isBusiness : Int!
	var isCountryBusiness : Int!
	var isPromoApplyForCard : Int!
	var isPromoApplyForCash : Int!
	var isAskUserForFixedFare : Bool!
	var isCheckProviderWalletAmountForReceivedCashRequest : Bool!
	var isPaymentModeCard : Int!
	var isPaymentModeCash : Int!
	var isProviderEarningSetInWalletOnCashPayment : Bool!
	var isProviderEarningSetInWalletOnOtherPayment : Bool!
	var isUseCityBoundary : Bool!
	var paymentGateway : [Int]!
	var providerMinWalletAmountSetForReceivedCashRequest : Int!
	var timezone : String!
	var unit : Int!
	var updatedAt : String!
	var zipcode : String!
	var zoneBusiness : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		airportBusiness = dictionary["airport_business"] as? Int
		cityLatLong = dictionary["cityLatLong"] as? [Float]
		cityRadius = dictionary["cityRadius"] as? Int
		cityBusiness = dictionary["city_business"] as? Int
		cityLocations = dictionary["city_locations"] as? [[Float]]
		citycode = dictionary["citycode"] as? String
		cityname = dictionary["cityname"] as? String
		countryid = dictionary["countryid"] as? String
		countryname = dictionary["countryname"] as? String
		createdAt = dictionary["created_at"] as? String
		dailyCronDate = dictionary["daily_cron_date"] as? String
		destinationCity = dictionary["destination_city"] as? [AnyObject]
		fullCityname = dictionary["full_cityname"] as? String
		isBusiness = dictionary["isBusiness"] as? Int
		isCountryBusiness = dictionary["isCountryBusiness"] as? Int
		isPromoApplyForCard = dictionary["isPromoApplyForCard"] as? Int
		isPromoApplyForCash = dictionary["isPromoApplyForCash"] as? Int
		isAskUserForFixedFare = (dictionary["is_ask_user_for_fixed_fare"] as? Bool) ?? true
		isCheckProviderWalletAmountForReceivedCashRequest = dictionary["is_check_provider_wallet_amount_for_received_cash_request"] as? Bool
		isPaymentModeCard = dictionary["is_payment_mode_card"] as? Int
		isPaymentModeCash = dictionary["is_payment_mode_cash"] as? Int
		isProviderEarningSetInWalletOnCashPayment = dictionary["is_provider_earning_set_in_wallet_on_cash_payment"] as? Bool
		isProviderEarningSetInWalletOnOtherPayment = dictionary["is_provider_earning_set_in_wallet_on_other_payment"] as? Bool
		isUseCityBoundary = dictionary["is_use_city_boundary"] as? Bool
		paymentGateway = dictionary["payment_gateway"] as? [Int]
		providerMinWalletAmountSetForReceivedCashRequest = dictionary["provider_min_wallet_amount_set_for_received_cash_request"] as? Int
		timezone = dictionary["timezone"] as? String
		unit = dictionary["unit"] as? Int
		updatedAt = dictionary["updated_at"] as? String
		zipcode = dictionary["zipcode"] as? String
		zoneBusiness = dictionary["zone_business"] as? Int
	}

}
