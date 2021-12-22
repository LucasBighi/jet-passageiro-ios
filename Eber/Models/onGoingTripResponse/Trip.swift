//
//	Trip.swift
//
//	Create by MacPro3 on 24/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class Trip: Model {

	var v : Int!
	var id : String!
	var acceptedTime : String!
	var accessibility : [String]!
	var adminCurrency : String!
	var adminCurrencycode : String!
	var baseDistanceCost : Double!
	var cancelReason : String!
	var cardPayment : Double!
	var cashPayment : Double!
	var cityId : String!
	var completeDateTag : String!
	var confirmedProvider : String!
	var countryId : String!
	var createdAt : String!
	var currency : String!
	var currencycode : String!
	var currentProvider : String!
	var destinationLocation : [Double]!
	var destinationAddress : String!
	var distanceCost : Double!
	var fixedPrice : Double!
	var floor : Int!
	var invoiceNumber : String!
	var isAmountRefund : Bool!
	var isCancellationFee : Int!
	var isFixedFare : Bool!
	var isMinFareUsed : Int!
	var isPaid : Int!
	var isPendingPayments : Int!
	var isProviderAccepted : Int!
	var isProviderEarningSetInWallet : Bool!
	var isProviderInvoiceShow : Int!
	var isProviderRated : Int!
	var isProviderStatus : Int!
	var isScheduleTrip : Bool!
	var isSurgeHours : Int!
	var isTip : Bool!
	var isToll : Bool!
	var isTransfered : Bool!
	var isTripCancelled : Int!
	var isTripCancelledByProvider : Int!
	var isTripCancelledByUser : Int!
	var isTripCompleted : Int!
	var isTripEnd : Int!
	var isUserInvoiceShow : Int!
	var isUserRated : Int!
	var noOfTimeSendRequest : Int!
	var payToProvider : Double!
	var paymentError : String!
	var paymentErrorMessage : String!
    var promoId : String!
	var paymentMode : Int!
	var paymentTransaction : [String]!
	var promoPayment : Double!
	var promoReferralAmount : Double!
	var providerLocation : [Double]!
	var providerArrivedTime : String!
	var providerFirstName : String!
    var bearing:Double!
	var providerHaveCash : Int!
	var providerId : String!
	var providerIncomeSetInWallet : Int!
	var providerLanguage : [String]!
	var providerLastName : String!
	var providerMiscellaneousFee : Double!
	var providerServiceFees :Double!
	var providerServiceFeesInAdminCurrency : Double!
	var providerTaxFee : Double!
	var providerTripEndTime : String!
	var providerTripStartTime : String!
	var providerType : Int!
	var providerTypeId : String!
	var providersIdThatRejectedTrip : [String]!
	var receivedTripFromGender : [String]!
	var referralPayment : Double!
	var refundAmount : Double!
	var remainingPayment : Double!
	var roomNumber : String!
	var scheduleStartTime : String!
	var serverStartTimeForSchedule : String!
	var serviceTotalInAdminCurrency : Double!
	var serviceTypeId : String!
	var sourceLocation : [Double]!
	var sourceAddress : String!
	var speed : Double!
	var surgeFee : Double!
	var taxFee : Double!
	var timeCost : Double!
	var timezone : String!
	var tipAmount : Double!
	var tollAmount : Double!
	var total : Double!
	var totalAfterPromoPayment : Double!
	var totalAfterReferralPayment : Double!
	var totalAfterSurgeFees : Double!
	var totalAfterTaxFees : Double!
	var totalAfterWalletPayment : Double!
	var totalDistance : Double!
	var totalInAdminCurrency : Double!
	var totalServiceFees : Double!
	var totalTime : Double!
	var totalWaitingTime : Double!
	var tripServiceCityTypeId : String!
	var tripType : Int!
	var tripTypeAmount : Double!
	var uniqueId : Int!
	var unit : Int!
	var updatedAt : String!
	var userCreateTime : String!
	var userFirstName : String!
	var userId : String!
	var userLastName : String!
	var userMiscellaneousFee : Double!
	var userTaxFee : Double!
	var userType : Double!
	var userTypeId : String!
	var waitingTimeCost : Double!
	var walletPayment : Double!
    var providerRate:Double = 0.0
    var isFavouriteProvider: Bool = false
    var timeLeftForTip: Int = 30
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = (dictionary["__v"] as? Int) ?? 0
		id = (dictionary["_id"] as? String) ?? ""
        isFavouriteProvider = (dictionary["is_favourite_provider"] as? Bool) ?? false
        providerRate = (dictionary["rate"] as? Double) ?? 0.0
		acceptedTime = (dictionary["accepted_time"] as? String) ?? ""
		accessibility = (dictionary["accessibility"] as? [String]) ?? []
		adminCurrency = (dictionary["admin_currency"] as? String) ?? ""
        promoId = (dictionary["promo_id"] as? String) ?? ""
		adminCurrencycode = (dictionary["admin_currencycode"] as? String) ?? ""
		baseDistanceCost = (dictionary["base_distance_cost"] as? Double) ?? 0.0
		cancelReason = (dictionary["cancel_reason"] as? String) ?? ""
		cardPayment = (dictionary["card_payment"] as? Double) ?? 0.0
        bearing = (dictionary["bearing"] as? Double) ?? 0.0
		cashPayment = (dictionary["cash_payment"] as? Double) ?? 0.0
		cityId = (dictionary["city_id"] as? String) ?? ""
		completeDateTag = (dictionary["complete_date_tag"] as? String) ?? ""
		confirmedProvider = (dictionary["confirmed_provider"] as? String) ?? ""
		countryId = (dictionary["country_id"] as? String) ?? ""
		createdAt = (dictionary["created_at"] as? String) ?? ""
		currency = (dictionary["currency"] as? String) ?? ""
		currencycode = (dictionary["currencycode"] as? String) ?? ""
		currentProvider = (dictionary["confirmed_provider"] as? String) ?? ""
		destinationLocation = (dictionary["destinationLocation"] as? [Double]) ?? [0.0,0.0]
        
        if destinationLocation.isEmpty
        {
            destinationLocation = [0.0,0.0]
        }
		destinationAddress = (dictionary["destination_address"] as? String) ?? ""
		distanceCost = (dictionary["distance_cost"] as? Double) ?? 0.0
		fixedPrice = (dictionary["fixed_price"] as? Double) ?? 0.0
		floor = (dictionary["floor"] as? Int) ?? 0
		invoiceNumber = (dictionary["invoice_number"] as? String) ?? ""
		isAmountRefund = (dictionary["is_amount_refund"] as? Bool) ?? false
		isCancellationFee = (dictionary["is_cancellation_fee"] as? Int) ?? 0
		isFixedFare = (dictionary["is_fixed_fare"] as? Bool) ?? false
		isMinFareUsed = (dictionary["is_min_fare_used"] as?Int) ?? 0
		isPaid = (dictionary["is_paid"] as? Int) ?? 0
		isPendingPayments = (dictionary["is_pending_payments"] as? Int) ?? 0
		isProviderAccepted = (dictionary["is_provider_accepted"] as? Int) ?? 0
		isProviderEarningSetInWallet = (dictionary["is_provider_earning_set_in_wallet"] as? Bool) ?? false
		isProviderInvoiceShow = (dictionary["is_provider_invoice_show"] as? Int) ?? 0
		isProviderRated = (dictionary["is_provider_rated"] as? Int) ?? 0
		isProviderStatus = (dictionary["is_provider_status"] as? Int) ?? 0
		isScheduleTrip = (dictionary["is_schedule_trip"] as? Bool) ?? false
		isSurgeHours = (dictionary["is_surge_hours"] as? Int) ?? 0
		isTip = (dictionary["is_tip"] as? Bool) ?? false
		isToll = (dictionary["is_toll"] as? Bool) ?? false
		isTransfered = (dictionary["is_transfered"] as? Bool) ?? false
		isTripCancelled = (dictionary["is_trip_cancelled"] as? Int) ?? 0
		isTripCancelledByProvider = (dictionary["is_trip_cancelled_by_provider"] as? Int) ?? 0
		isTripCancelledByUser = (dictionary["is_trip_cancelled_by_user"] as? Int) ?? 0
		isTripCompleted = (dictionary["is_trip_completed"] as? Int) ?? 00
		isTripEnd = (dictionary["is_trip_end"] as? Int) ?? 0
		isUserInvoiceShow = (dictionary["is_user_invoice_show"] as? Int) ?? 0
		isUserRated = (dictionary["is_user_rated"] as? Int) ?? 0
		noOfTimeSendRequest = (dictionary["no_of_time_send_request"] as? Int) ?? 0
		payToProvider = (dictionary["pay_to_provider"] as? Double) ?? 0.0
		paymentError = (dictionary["payment_error"] as? String) ?? ""
		paymentErrorMessage = (dictionary["payment_error_message"] as? String) ?? ""
		paymentMode = (dictionary["payment_mode"] as? Int) ?? 0
		paymentTransaction = (dictionary["payment_transaction"] as? [String]) ?? []
		promoPayment = (dictionary["promo_payment"] as? Double) ?? 0.0
		promoReferralAmount = (dictionary["promo_referral_amount"] as? Double) ?? 0.0
		providerLocation = (dictionary["providerLocation"] as? [Double]) ?? [0.0,0.0]
        if providerLocation.isEmpty
        {
            providerLocation = [0.0,0.0]
        }
		providerArrivedTime = (dictionary["provider_arrived_time"] as? String) ?? ""
		providerFirstName = (dictionary["provider_first_name"] as? String) ?? ""
		providerHaveCash = (dictionary["provider_have_cash"] as? Int) ?? 0
		providerId = (dictionary["provider_id"] as? String) ?? ""
		providerIncomeSetInWallet = (dictionary["provider_income_set_in_wallet"] as? Int) ?? 0
		providerLanguage = (dictionary["provider_language"] as? [String]) ?? []
		providerLastName = (dictionary["provider_last_name"] as? String) ?? ""
		providerMiscellaneousFee = (dictionary["provider_miscellaneous_fee"] as? Double) ?? 0.0
		providerServiceFees = (dictionary["provider_service_fees"] as? Double) ?? 0.0
		providerServiceFeesInAdminCurrency = (dictionary["provider_service_fees_in_admin_currency"] as? Double) ?? 0.0
		providerTaxFee = (dictionary["provider_tax_fee"] as? Double) ?? 0.0
		providerTripEndTime = (dictionary["provider_trip_end_time"] as? String) ?? ""
		providerTripStartTime = (dictionary["provider_trip_start_time"] as? String) ?? ""
		providerType = (dictionary["provider_type"] as? Int) ?? 0
		providerTypeId = (dictionary["provider_type_id"] as? String) ?? ""
		providersIdThatRejectedTrip = (dictionary["providers_id_that_rejected_trip"] as? [String]) ?? []
		receivedTripFromGender = (dictionary["received_trip_from_gender"] as? [String]) ?? []
		referralPayment = (dictionary["referral_payment"] as? Double) ?? 0.0
		refundAmount = (dictionary["refund_amount"] as? Double) ?? 0.0
		remainingPayment = (dictionary["remaining_payment"] as? Double) ?? 0.0
		roomNumber = (dictionary["room_number"] as? String) ?? ""
		scheduleStartTime = (dictionary["schedule_start_time"] as? String) ?? ""
		serverStartTimeForSchedule = (dictionary["server_start_time_for_schedule"] as? String) ?? ""
		serviceTotalInAdminCurrency = (dictionary["service_total_in_admin_currency"] as? Double) ?? 0.0
		serviceTypeId = (dictionary["service_type_id"] as? String) ?? ""
		sourceLocation = (dictionary["sourceLocation"] as? [Double]) ?? [0.0,0.0]
		sourceAddress = (dictionary["source_address"] as? String) ?? ""
		speed = (dictionary["speed"] as? Double) ?? 0.0
		surgeFee = (dictionary["surge_fee"] as? Double) ?? 0.0
		taxFee = (dictionary["tax_fee"] as? Double) ?? 0.0
		timeCost = (dictionary["time_cost"] as? Double) ?? 0.0
		timezone = (dictionary["timezone"] as? String) ?? ""
		tipAmount = (dictionary["tip_amount"] as? Double) ?? 0.0
		tollAmount = (dictionary["toll_amount"] as? Double) ?? 0.0
		total = (dictionary["total"] as? Double) ?? 0.0
		totalAfterPromoPayment = (dictionary["total_after_promo_payment"] as? Double) ?? 0.0
		totalAfterReferralPayment = (dictionary["total_after_referral_payment"] as? Double) ?? 0.0
		totalAfterSurgeFees = (dictionary["total_after_surge_fees"] as? Double) ?? 0.0
		totalAfterTaxFees = (dictionary["total_after_tax_fees"] as? Double) ?? 0.0
		totalAfterWalletPayment = (dictionary["total_after_wallet_payment"] as? Double) ?? 0.0
		totalDistance = (dictionary["total_distance"] as? Double) ?? 0.0
		totalInAdminCurrency = (dictionary["total_in_admin_currency"] as? Double) ?? 0.0
		totalServiceFees = (dictionary["total_service_fees"] as? Double) ?? 0.0
		totalTime = (dictionary["total_time"] as? Double) ?? 0.0
		totalWaitingTime = (dictionary["total_waiting_time"] as? Double) ?? 0.0
		tripServiceCityTypeId = (dictionary["trip_service_city_type_id"] as? String) ?? ""
		tripType = (dictionary["trip_type"] as? Int) ?? 0
		tripTypeAmount = (dictionary["trip_type_amount"] as? Double) ?? 0.0
		uniqueId = (dictionary["unique_id"] as? Int) ?? 0
		unit = (dictionary["unit"] as? Int) ?? 0
		updatedAt = (dictionary["updated_at"] as? String) ?? ""
		userCreateTime = (dictionary["user_create_time"] as? String) ?? ""
		userFirstName = (dictionary["user_first_name"] as? String) ?? ""
		userId = (dictionary["user_id"] as? String) ?? ""
		userLastName = (dictionary["user_last_name"] as? String) ?? ""
		userMiscellaneousFee = (dictionary["user_miscellaneous_fee"] as? Double) ?? 0.0
		userTaxFee = (dictionary["user_tax_fee"] as? Double) ?? 0.0
		userType = (dictionary["user_type"] as? Double) ?? 0.0
		userTypeId = (dictionary["user_type_id"] as? String) ?? ""
		waitingTimeCost = (dictionary["waiting_time_cost"] as? Double) ?? 0.0
		walletPayment = (dictionary["wallet_payment"] as? Double) ?? 0.0
	}

}
