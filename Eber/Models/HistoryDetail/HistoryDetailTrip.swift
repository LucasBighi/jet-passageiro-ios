//
//	HistoryDetailTrip.swift
//
//	Create by MacPro3 on 12/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class HistoryDetailTrip: ModelNSObj {

	var v : Int!
	var id : String!
	var acceptedTime : String!
	var adminCurrency : String!
	var adminCurrencycode : String!
	var baseDistanceCost : Double!
	var cancelReason : String!
	var cardPayment : Double!
	var cashPayment : Double!
	var cityId : String!
	var completeDateInCityTimezone : String!
	var completeDateTag : String!
	var confirmedProvider : String!
	var countryId : String!
	var createdAt : String!
	var currency : String!
	var currencycode : String!
	var currentProvider : String!
	var currentRate : Double!
	var destinationLocation : [Double]!
	var destinationAddress : String!
	var distanceCost : Double!
	var fixedPrice : Double!
	var floor : Double!
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
	var paymentMode : Int!
	
	var promoPayment : Double!
	var promoReferralAmount : Double!
	var providerLocation : [Double]!
	var providerPreviousLocation : [Double]!
	var providerArrivedTime : String!
	var providerFirstName : String!
	var providerHaveCash : Double!
	var providerId : String!
	var providerIncomeSetInWallet : Double!
	
	var providerLastName : String!
	var providerMiscellaneousFee : Int!
	var providerServiceFees : Double!
	var providerServiceFeesInAdminCurrency : Double!
	var providerTaxFee : Double!
	var providerTripEndTime : String!
	var providerTripStartTime : String!
	var providerType : Int!


	var referralPayment : Double!
	var refundAmount : Double!
	var remainingPayment : Double!
	var roomNumber : String!

	var serviceTotalInAdminCurrency : Double!
	var serviceTypeId : String!
	var sourceLocation : [Double]!
	var sourceAddress : String!
	var speed : Int!
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
	var userMiscellaneousFee : Int!
	var userTaxFee : Double!
	var userType : Int!

	var waitingTimeCost : Double!
	var walletCurrentRate : Double!
	var walletPayment : Double!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = (dictionary["__v"] as? Int) ?? 0
		id = (dictionary["_id"] as? String) ?? ""
		acceptedTime = (dictionary["accepted_time"] as? String) ?? ""

		adminCurrency = (dictionary["admin_currency"] as? String) ?? ""
		adminCurrencycode = (dictionary["admin_currencycode"] as? String) ?? ""
		baseDistanceCost = (dictionary["base_distance_cost"] as? Double) ?? 0.0
		cancelReason = (dictionary["cancel_reason"] as? String) ?? ""
		cardPayment = (dictionary["card_payment"] as? Double) ?? 0.0
		cashPayment = (dictionary["cash_payment"] as? Double) ?? 0.0
		cityId = (dictionary["city_id"] as? String) ?? ""
		completeDateInCityTimezone = (dictionary["complete_date_in_city_timezone"] as? String) ?? ""
		completeDateTag = (dictionary["complete_date_tag"] as? String) ?? ""
		confirmedProvider = (dictionary["confirmed_provider"] as? String) ?? ""
		countryId = (dictionary["country_id"] as? String) ?? ""
		createdAt = (dictionary["created_at"] as? String) ?? ""
		currency = (dictionary["currency"] as? String) ?? ""
		currencycode = (dictionary["currencycode"] as? String) ?? ""
		currentProvider = (dictionary["confirmed_provider"] as? String) ?? ""
		currentRate = (dictionary["current_rate"] as? Double) ?? 0.0
		destinationLocation = (dictionary["destinationLocation"] as? [Double]) ?? [0.0,0.0]
		destinationAddress = (dictionary["destination_address"] as? String) ?? ""
		distanceCost = (dictionary["distance_cost"] as? Double) ?? 0.0
		fixedPrice = (dictionary["fixed_price"] as? Double) ?? 0.0
		floor = (dictionary["floor"] as? Double) ?? 0.0
		invoiceNumber = (dictionary["invoice_number"] as? String) ?? ""
		isAmountRefund = (dictionary["is_amount_refund"] as? Bool) ?? false
		isCancellationFee = (dictionary["is_cancellation_fee"] as? Int) ?? 0
		isFixedFare = (dictionary["is_fixed_fare"] as? Bool) ?? false
		isMinFareUsed = (dictionary["is_min_fare_used"] as? Int) ?? 0
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
		isTripCompleted = (dictionary["is_trip_completed"] as? Int) ?? 0
		isTripEnd = (dictionary["is_trip_end"] as? Int) ?? 0
		isUserInvoiceShow = (dictionary["is_user_invoice_show"] as? Int) ?? 0
		isUserRated = (dictionary["is_user_rated"] as? Int) ?? 0
		noOfTimeSendRequest = (dictionary["no_of_time_send_request"] as? Int) ?? 0
		payToProvider = (dictionary["pay_to_provider"] as? Double) ?? 0.0
		paymentError = (dictionary["payment_error"] as? String) ?? ""
		paymentErrorMessage = (dictionary["payment_error_message"] as? String) ?? ""
		paymentMode = (dictionary["payment_mode"] as? Int) ?? 0
		promoPayment = (dictionary["promo_payment"] as? Double) ?? 0.0
		promoReferralAmount = (dictionary["promo_referral_amount"] as? Double) ?? 0.0
		providerLocation = (dictionary["providerLocation"] as? [Double]) ?? [0.0,0.0]
		providerPreviousLocation = (dictionary["providerPreviousLocation"] as? [Double]) ?? [0.0,0.0]
		providerArrivedTime = (dictionary["provider_arrived_time"] as? String) ?? ""
		providerFirstName = (dictionary["provider_first_name"] as? String) ?? ""
		providerHaveCash = (dictionary["provider_have_cash"] as? Double) ?? 0.0
		providerId = (dictionary["provider_id"] as? String) ?? ""
		providerIncomeSetInWallet = (dictionary["provider_income_set_in_wallet"] as? Double) ?? 0.0
		providerLastName = (dictionary["provider_last_name"] as? String) ?? ""
		providerMiscellaneousFee = (dictionary["provider_miscellaneous_fee"] as? Int) ?? 0
		providerServiceFees = (dictionary["provider_service_fees"] as? Double) ?? 0.0
		providerServiceFeesInAdminCurrency = (dictionary["provider_service_fees_in_admin_currency"] as? Double) ?? 0.0
		providerTaxFee = (dictionary["provider_tax_fee"] as? Double) ?? 0.0
		providerTripEndTime = (dictionary["provider_trip_end_time"] as? String) ?? ""
		providerTripStartTime = (dictionary["provider_trip_start_time"] as? String) ?? ""
		providerType = (dictionary["provider_type"] as? Int) ?? 0
		referralPayment = (dictionary["referral_payment"] as? Double) ?? 0.0
		refundAmount = (dictionary["refund_amount"] as? Double) ?? 0.0
		remainingPayment = (dictionary["remaining_payment"] as? Double) ?? 0.0
		roomNumber = (dictionary["room_number"] as? String) ?? ""
		serviceTotalInAdminCurrency = (dictionary["service_total_in_admin_currency"] as? Double) ?? 0.0
		serviceTypeId = (dictionary["service_type_id"] as? String) ?? ""
		sourceLocation = (dictionary["sourceLocation"] as? [Double]) ?? [0.0,0.0]
		sourceAddress = (dictionary["source_address"] as? String) ?? ""
		speed = (dictionary["speed"] as? Int) ?? 0
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
		userMiscellaneousFee = (dictionary["user_miscellaneous_fee"] as? Int) ?? 0
		userTaxFee = (dictionary["user_tax_fee"] as? Double) ?? 0.0
		userType = (dictionary["user_type"] as? Int) ?? 0
		waitingTimeCost = (dictionary["waiting_time_cost"] as? Double) ?? 0.0
		walletCurrentRate = (dictionary["wallet_current_rate"] as? Double) ?? 0.0
		walletPayment = (dictionary["wallet_payment"] as? Double) ?? 0.0
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if v != nil{
			dictionary["__v"] = v
		}
		if id != nil{
			dictionary["_id"] = id
		}
		if acceptedTime != nil{
			dictionary["accepted_time"] = acceptedTime
		}
		
		if adminCurrency != nil{
			dictionary["admin_currency"] = adminCurrency
		}
		if adminCurrencycode != nil{
			dictionary["admin_currencycode"] = adminCurrencycode
		}
		if baseDistanceCost != nil{
			dictionary["base_distance_cost"] = baseDistanceCost
		}
		if cancelReason != nil{
			dictionary["cancel_reason"] = cancelReason
		}
		if cardPayment != nil{
			dictionary["card_payment"] = cardPayment
		}
		if cashPayment != nil{
			dictionary["cash_payment"] = cashPayment
		}
		if cityId != nil{
			dictionary["city_id"] = cityId
		}
		if completeDateInCityTimezone != nil{
			dictionary["complete_date_in_city_timezone"] = completeDateInCityTimezone
		}
		if completeDateTag != nil{
			dictionary["complete_date_tag"] = completeDateTag
		}
		if confirmedProvider != nil{
			dictionary["confirmed_provider"] = confirmedProvider
		}
		if countryId != nil{
			dictionary["country_id"] = countryId
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if currency != nil{
			dictionary["currency"] = currency
		}
		if currencycode != nil{
			dictionary["currencycode"] = currencycode
		}
		if currentProvider != nil{
			dictionary["confirmed_provider"] = currentProvider
		}
		if currentRate != nil{
			dictionary["current_rate"] = currentRate
		}
		if destinationLocation != nil{
			dictionary["destinationLocation"] = destinationLocation
		}
		if destinationAddress != nil{
			dictionary["destination_address"] = destinationAddress
		}
		if distanceCost != nil{
			dictionary["distance_cost"] = distanceCost
		}
		if fixedPrice != nil{
			dictionary["fixed_price"] = fixedPrice
		}
		if floor != nil{
			dictionary["floor"] = floor
		}
		if invoiceNumber != nil{
			dictionary["invoice_number"] = invoiceNumber
		}
		if isAmountRefund != nil{
			dictionary["is_amount_refund"] = isAmountRefund
		}
		if isCancellationFee != nil{
			dictionary["is_cancellation_fee"] = isCancellationFee
		}
		if isFixedFare != nil{
			dictionary["is_fixed_fare"] = isFixedFare
		}
		if isMinFareUsed != nil{
			dictionary["is_min_fare_used"] = isMinFareUsed
		}
		if isPaid != nil{
			dictionary["is_paid"] = isPaid
		}
		if isPendingPayments != nil{
			dictionary["is_pending_payments"] = isPendingPayments
		}
		if isProviderAccepted != nil{
			dictionary["is_provider_accepted"] = isProviderAccepted
		}
		if isProviderEarningSetInWallet != nil{
			dictionary["is_provider_earning_set_in_wallet"] = isProviderEarningSetInWallet
		}
		if isProviderInvoiceShow != nil{
			dictionary["is_provider_invoice_show"] = isProviderInvoiceShow
		}
		if isProviderRated != nil{
			dictionary["is_provider_rated"] = isProviderRated
		}
		if isProviderStatus != nil{
			dictionary["is_provider_status"] = isProviderStatus
		}
		if isScheduleTrip != nil{
			dictionary["is_schedule_trip"] = isScheduleTrip
		}
		if isSurgeHours != nil{
			dictionary["is_surge_hours"] = isSurgeHours
		}
		if isTip != nil{
			dictionary["is_tip"] = isTip
		}
		if isToll != nil{
			dictionary["is_toll"] = isToll
		}
		if isTransfered != nil{
			dictionary["is_transfered"] = isTransfered
		}
		if isTripCancelled != nil{
			dictionary["is_trip_cancelled"] = isTripCancelled
		}
		if isTripCancelledByProvider != nil{
			dictionary["is_trip_cancelled_by_provider"] = isTripCancelledByProvider
		}
		if isTripCancelledByUser != nil{
			dictionary["is_trip_cancelled_by_user"] = isTripCancelledByUser
		}
		if isTripCompleted != nil{
			dictionary["is_trip_completed"] = isTripCompleted
		}
		if isTripEnd != nil{
			dictionary["is_trip_end"] = isTripEnd
		}
		if isUserInvoiceShow != nil{
			dictionary["is_user_invoice_show"] = isUserInvoiceShow
		}
		if isUserRated != nil{
			dictionary["is_user_rated"] = isUserRated
		}
		if noOfTimeSendRequest != nil{
			dictionary["no_of_time_send_request"] = noOfTimeSendRequest
		}
		if payToProvider != nil{
			dictionary["pay_to_provider"] = payToProvider
		}
		if paymentError != nil{
			dictionary["payment_error"] = paymentError
		}
		if paymentErrorMessage != nil{
			dictionary["payment_error_message"] = paymentErrorMessage
		}
		if paymentMode != nil{
			dictionary["payment_mode"] = paymentMode
		}
	
		if promoPayment != nil{
			dictionary["promo_payment"] = promoPayment
		}
		if promoReferralAmount != nil{
			dictionary["promo_referral_amount"] = promoReferralAmount
		}
		if providerLocation != nil{
			dictionary["providerLocation"] = providerLocation
		}
		if providerPreviousLocation != nil{
			dictionary["providerPreviousLocation"] = providerPreviousLocation
		}
		if providerArrivedTime != nil{
			dictionary["provider_arrived_time"] = providerArrivedTime
		}
		if providerFirstName != nil{
			dictionary["provider_first_name"] = providerFirstName
		}
		if providerHaveCash != nil{
			dictionary["provider_have_cash"] = providerHaveCash
		}
		if providerId != nil{
			dictionary["provider_id"] = providerId
		}
		if providerIncomeSetInWallet != nil{
			dictionary["provider_income_set_in_wallet"] = providerIncomeSetInWallet
		}
		
		if providerLastName != nil{
			dictionary["provider_last_name"] = providerLastName
		}
		if providerMiscellaneousFee != nil{
			dictionary["provider_miscellaneous_fee"] = providerMiscellaneousFee
		}
		if providerServiceFees != nil{
			dictionary["provider_service_fees"] = providerServiceFees
		}
		if providerServiceFeesInAdminCurrency != nil{
			dictionary["provider_service_fees_in_admin_currency"] = providerServiceFeesInAdminCurrency
		}
		if providerTaxFee != nil{
			dictionary["provider_tax_fee"] = providerTaxFee
		}
		if providerTripEndTime != nil{
			dictionary["provider_trip_end_time"] = providerTripEndTime
		}
		if providerTripStartTime != nil{
			dictionary["provider_trip_start_time"] = providerTripStartTime
		}
		if providerType != nil{
			dictionary["provider_type"] = providerType
		}
		
		if referralPayment != nil{
			dictionary["referral_payment"] = referralPayment
		}
		if refundAmount != nil{
			dictionary["refund_amount"] = refundAmount
		}
		if remainingPayment != nil{
			dictionary["remaining_payment"] = remainingPayment
		}
		if roomNumber != nil{
			dictionary["room_number"] = roomNumber
		}
		
		if serviceTotalInAdminCurrency != nil{
			dictionary["service_total_in_admin_currency"] = serviceTotalInAdminCurrency
		}
		if serviceTypeId != nil{
			dictionary["service_type_id"] = serviceTypeId
		}
		if sourceLocation != nil{
			dictionary["sourceLocation"] = sourceLocation
		}
		if sourceAddress != nil{
			dictionary["source_address"] = sourceAddress
		}
		if speed != nil{
			dictionary["speed"] = speed
		}
		if surgeFee != nil{
			dictionary["surge_fee"] = surgeFee
		}
		if taxFee != nil{
			dictionary["tax_fee"] = taxFee
		}
		if timeCost != nil{
			dictionary["time_cost"] = timeCost
		}
		if timezone != nil{
			dictionary["timezone"] = timezone
		}
		if tipAmount != nil{
			dictionary["tip_amount"] = tipAmount
		}
		if tollAmount != nil{
			dictionary["toll_amount"] = tollAmount
		}
		if total != nil{
			dictionary["total"] = total
		}
		if totalAfterPromoPayment != nil{
			dictionary["total_after_promo_payment"] = totalAfterPromoPayment
		}
		if totalAfterReferralPayment != nil{
			dictionary["total_after_referral_payment"] = totalAfterReferralPayment
		}
		if totalAfterSurgeFees != nil{
			dictionary["total_after_surge_fees"] = totalAfterSurgeFees
		}
		if totalAfterTaxFees != nil{
			dictionary["total_after_tax_fees"] = totalAfterTaxFees
		}
		if totalAfterWalletPayment != nil{
			dictionary["total_after_wallet_payment"] = totalAfterWalletPayment
		}
		if totalDistance != nil{
			dictionary["total_distance"] = totalDistance
		}
		if totalInAdminCurrency != nil{
			dictionary["total_in_admin_currency"] = totalInAdminCurrency
		}
		if totalServiceFees != nil{
			dictionary["total_service_fees"] = totalServiceFees
		}
		if totalTime != nil{
			dictionary["total_time"] = totalTime
		}
		if totalWaitingTime != nil{
			dictionary["total_waiting_time"] = totalWaitingTime
		}
		if tripServiceCityTypeId != nil{
			dictionary["trip_service_city_type_id"] = tripServiceCityTypeId
		}
		if tripType != nil{
			dictionary["trip_type"] = tripType
		}
		if tripTypeAmount != nil{
			dictionary["trip_type_amount"] = tripTypeAmount
		}
		if uniqueId != nil{
			dictionary["unique_id"] = uniqueId
		}
		if unit != nil{
			dictionary["unit"] = unit
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if userCreateTime != nil{
			dictionary["user_create_time"] = userCreateTime
		}
		if userFirstName != nil{
			dictionary["user_first_name"] = userFirstName
		}
		if userId != nil{
			dictionary["user_id"] = userId
		}
		if userLastName != nil{
			dictionary["user_last_name"] = userLastName
		}
		if userMiscellaneousFee != nil{
			dictionary["user_miscellaneous_fee"] = userMiscellaneousFee
		}
		if userTaxFee != nil{
			dictionary["user_tax_fee"] = userTaxFee
		}
		if userType != nil{
			dictionary["user_type"] = userType
		}
		
		if waitingTimeCost != nil{
			dictionary["waiting_time_cost"] = waitingTimeCost
		}
		if walletCurrentRate != nil{
			dictionary["wallet_current_rate"] = walletCurrentRate
		}
		if walletPayment != nil{
			dictionary["wallet_payment"] = walletPayment
		}
		return dictionary
	}

}
