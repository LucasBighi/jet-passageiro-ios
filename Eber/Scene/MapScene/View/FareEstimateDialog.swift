//
//  FareEstimateDialog.swift
//  
//
//  Created by Elluminati  on 07/09/18.
//

import UIKit

class FareEstimateDialog: CustomDialog
{

    @IBOutlet weak var viewForFareEstimateDialog: UIView!
    @IBOutlet weak var lblServicetypeName: UILabel!
    @IBOutlet weak var imgServicetype: UIImageView!
    
    @IBOutlet weak var vehicleView: UIView!
    @IBOutlet weak var viewForEstimateCost: UIView!
    
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblBaseFareValue: UILabel!
    
    @IBOutlet weak var lblDistanceFare: UILabel!
    @IBOutlet weak var lblDistanceFareValue: UILabel!
    
    @IBOutlet weak var lblTimeFare: UILabel!
    @IBOutlet weak var lblTimeFareValue: UILabel!
    
    @IBOutlet weak var lblMaxSize: UILabel!
    @IBOutlet weak var lblMaxSizeValue: UILabel!
   
    @IBOutlet weak var stkCancellationChargeView: UIStackView!
    @IBOutlet weak var lblCancellationFare: UILabel!
    @IBOutlet weak var lblCancellationValue: UILabel!
    
    
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblTaxValue: UILabel!
    
    @IBOutlet weak var stkPickupAddressView: UIStackView!
    @IBOutlet weak var lblPickupAddress: UILabel!
    
    @IBOutlet weak var stkDestinationAddressView: UIStackView!
    @IBOutlet weak var lblDestinationAddress: UILabel!
    
    @IBOutlet weak var lblDivider: UILabel!
    
    @IBOutlet weak var lblTotalDistance: UILabel!
    @IBOutlet weak var lblTotalDistanceValue: UILabel!
    
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblTotalTimeValue: UILabel!
    
    @IBOutlet weak var lblEstMsg: UILabel!
    

    
    @IBOutlet weak var viewForFareAmount: UIView!
    
    @IBOutlet weak var stkSurgeView: UIStackView!
    @IBOutlet weak var lblSurgeFare: UILabel!
    @IBOutlet weak var lblSurgeFareValue: UILabel!
    
    @IBOutlet weak var lblFareAmount: UILabel!
    @IBOutlet weak var lblFareAmountValue: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    @IBOutlet weak var viewForFixedFare: UIView!
    @IBOutlet weak var lblTripType: UILabel!
    @IBOutlet weak var lblFixedFareMaxSize: UILabel!
    @IBOutlet weak var lblFixedFareMaxSizeValue: UILabel!
    @IBOutlet weak var lblFixedRate: UILabel!
    @IBOutlet weak var lblFixedRateValue: UILabel!
  
    @IBOutlet weak var lblIconETA: UILabel!
    @IBOutlet weak var lblIconDistance: UILabel!
    
    @IBAction func onClickBtnCancel(_ sender: Any)
    {
        self.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        
        
        btnCancel.setRound(withBorderColor: .clear, andCornerRadious: 25, borderWidth: 1.0)
        btnCancel.backgroundColor = UIColor.themeButtonBackgroundColor
        btnCancel.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnCancel.setTitle("TXT_CLOSE".localizedCapitalized, for: .normal)
        btnCancel.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        lblPickupAddress.text = "TXT_PICKUP_ADDRESS".localized
        lblPickupAddress.textColor = UIColor.themeTextColor
        lblPickupAddress.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblDestinationAddress.text = "TXT_DESTINATION_ADDRESS".localized
        lblDestinationAddress.textColor = UIColor.themeTextColor
        lblDestinationAddress.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblBaseFare.text = "TXT_BASE_FARE".localized + " : "
        lblBaseFare.textColor = UIColor.themeTextColor
        lblBaseFare.font = FontHelper.font(size: FontSize.small, type: FontType.Light)
        
        lblBaseFareValue.text = "CHF" + "00.0"
        lblBaseFareValue.textColor = UIColor.themeTextColor
        lblBaseFareValue.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        
        lblDistanceFare.text = "TXT_DISTANCE_FARE".localized + " : "
        lblDistanceFare.textColor = UIColor.themeTextColor
        lblDistanceFare.font = FontHelper.font(size: FontSize.small, type: FontType.Light)
        
       lblDistanceFareValue.text = "CHF" + "00.0"
        lblDistanceFareValue.textColor = UIColor.themeTextColor
        lblDistanceFareValue.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblTimeFare.text = "TXT_TIME_FARE".localized + " : "
        lblTimeFare.textColor = UIColor.themeTextColor
        lblTimeFare.font = FontHelper.font(size: FontSize.small, type: FontType.Light)
        
        lblTimeFareValue.text = "CHF" + "00.0"
        lblTimeFareValue.textColor = UIColor.themeTextColor
        lblTimeFareValue.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblMaxSize.text = "TXT_MAX_SIZE".localized + " : "
        lblMaxSize.textColor = UIColor.themeTextColor
        lblMaxSize.font = FontHelper.font(size: FontSize.small, type: FontType.Light)
        
        lblMaxSizeValue.text = "CHF" + "00.0"
        lblMaxSizeValue.textColor = UIColor.themeTextColor
        lblMaxSizeValue.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        
        
        lblCancellationFare.text = "TXT_CANCELLATION_FARE".localized + " : "
        lblCancellationFare.textColor = UIColor.themeTextColor
        lblCancellationFare.font = FontHelper.font(size: FontSize.small, type: FontType.Light)
        
        lblCancellationValue.text = "CHF" + "00.0"
        lblCancellationValue.textColor = UIColor.themeTextColor
        lblCancellationValue.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        
        
        lblTax.text = "TXT_TAX_FARE".localized + " : "
        lblTax.textColor = UIColor.themeTextColor
        lblTax.font = FontHelper.font(size: FontSize.small, type: FontType.Light)
        
        lblTaxValue.text = "CHF" + "00.0"
        lblTaxValue.textColor = UIColor.themeTextColor
        lblTaxValue.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
      
        lblEstMsg.text = "TXT_FARE_ESTIMATE_MSG".localized
        lblEstMsg.textColor = UIColor.themeTextColor
        lblEstMsg.font = FontHelper.font(size: FontSize.small, type: FontType.Light)
      
        
        lblTotalDistance.text = "TXT_DISTANCE".localized
        lblTotalDistance.textColor = UIColor.themeLightTextColor
        lblTotalDistance.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)

        lblTotalDistanceValue.text = "5.0 Miles"
        lblTotalDistanceValue.textColor = UIColor.themeTextColor
        lblTotalDistanceValue.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        lblTotalTime.text = "TXT_ETA".localized
        lblTotalTime.textColor = UIColor.themeLightTextColor
        lblTotalTime.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        

        
        lblTotalTimeValue.text = "0.15 Min"
        lblTotalTimeValue.textColor = UIColor.themeTextColor
        lblTotalTimeValue.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        self.backgroundColor = UIColor.themeOverlayColor
        
        stkSurgeView.isHidden = true
        
        lblSurgeFare.text = "TXT_SURGE_FARE".localized
        lblSurgeFare.textColor = UIColor.themeLightTextColor
        lblSurgeFare.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        lblTripType.text = "TXT_DEFAULT".localized
        lblTripType.textColor = UIColor.themeTextColor
        lblTripType.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        lblSurgeFareValue.text = "0.15 Min"
        lblSurgeFareValue.textColor = UIColor.themeTextColor
        lblSurgeFareValue.font = FontHelper.font(size: FontSize.extraLarge, type: FontType.Bold)
        
        lblFareAmount.text = "TXT_MIN_FARE".localized
        lblFareAmount.textColor = UIColor.themeLightTextColor
        lblFareAmount.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        
        
        lblFareAmountValue.text = "CHF 500.00"
        lblFareAmountValue.textColor = UIColor.themeTextColor
        lblFareAmountValue.font = FontHelper.font(size: FontSize.extraLarge, type: FontType.Bold)
        
        lblIconETA.text = FontAsset.icon_time
        lblIconDistance.text = FontAsset.icon_distance
        lblIconETA.setForIcon()
        lblIconDistance.setForIcon()
    }
    
    class func showFareEstimateDialog() -> FareEstimateDialog
    {
        let myView = Bundle.main.loadNibNamed("FareEstimate", owner: nil, options: nil)![0] as! FareEstimateDialog
        
        myView.viewForFareEstimateDialog.setShadow()
        myView.viewForFareEstimateDialog.setRound(withBorderColor: UIColor.lightText, andCornerRadious: 10.0, borderWidth: 0.5)
        
        myView.setData()
        
        myView.frame = UIScreen.main.bounds
        APPDELEGATE.window?.addSubview(myView)
        
        
        
        
        return myView
    }
    func setData()
    {
        let vehicleDetail =  CurrentTrip.shared.selectedVehicle
        
        
        imgServicetype.downloadedFrom(link: vehicleDetail.typeDetails.typeImageUrl)
        imgServicetype.contentMode = .scaleAspectFit
        lblServicetypeName.text = vehicleDetail.typeDetails.typename
        lblPickupAddress.text = CurrentTrip.shared.pickupAddress
        lblDestinationAddress.text = CurrentTrip.shared.destinationtAddress
        lblBaseFareValue.text = vehicleDetail.basePrice.toCurrencyString(currencyCode: CurrentTrip.shared.currencyCode)
        lblDistanceFareValue.text =  vehicleDetail.pricePerUnitDistance.toCurrencyString(currencyCode: CurrentTrip.shared.currencyCode) + "/" + CurrentTrip.shared.distanceUnit
        
        lblTimeFareValue.text = vehicleDetail.priceForTotalTime.toCurrencyString(currencyCode: CurrentTrip.shared.currencyCode) + "/" + MeasureUnit.MINUTES
        lblMaxSizeValue.text =  vehicleDetail.maxSpace.toString() + " " + "TXT_PERSON".localized
        lblCancellationValue.text = vehicleDetail.cancellationFee.toCurrencyString(currencyCode: CurrentTrip.shared.currencyCode)
        lblTaxValue.text = vehicleDetail.tax.toString(places: 2) + "%"
        
        if vehicleDetail.cancellationFee == 0.0
        {
            stkCancellationChargeView.isHidden = true
        }
        if CurrentTrip.shared.destinationtAddress.isEmpty()
        {
            lblTotalDistanceValue.text = "0.0" + CurrentTrip.shared.distanceUnit
            lblTotalTimeValue.text = "0.0" + MeasureUnit.MINUTES
        }
        else
        {
            lblTotalDistanceValue.text = CurrentTrip.shared.estimateFareDistance.toString(places: 2) + CurrentTrip.shared.distanceUnit
            lblTotalTimeValue.text = CurrentTrip.shared.estimateFareTime.toString(places: 2) + MeasureUnit.MINUTES
            
        }

        lblSurgeFareValue.text = vehicleDetail.surgeMultiplier.toString(places: 2) + " x"
        
        lblFareAmountValue.text =  CurrentTrip.shared.estimateFareTotal.toCurrencyString(currencyCode: CurrentTrip.shared.currencyCode)
        
        lblTripType.isHidden = false
        
        switch CurrentTrip.shared.tripType
        {
        case TripType.AIRPORT:
             goWithTripType(fixedPrice: CurrentTrip.shared.estimateFareTotal, maxSpace: vehicleDetail.maxSpace, type: "TXT_AIRPORT_TRIP".localized)
        case TripType.ZONE:
            goWithTripType(fixedPrice: CurrentTrip.shared.estimateFareTotal, maxSpace: vehicleDetail.maxSpace, type: "TXT_ZONE_TRIP".localized)
        case TripType.CITY:
            goWithTripType(fixedPrice: CurrentTrip.shared.estimateFareTotal, maxSpace: vehicleDetail.maxSpace, type: "TXT_CITY_TRIP".localized)
        case TripType.NORMAL:
            
            stkSurgeView.isHidden = false
            viewForEstimateCost.isHidden = false
            viewForFixedFare.isHidden = true
            
        default:
            stkSurgeView.isHidden = false
            viewForEstimateCost.isHidden = false
            viewForFixedFare.isHidden = true
        
        }
        stkSurgeView.isHidden = !CurrentTrip.shared.isSurgeHour
    }
    func goWithTripType(fixedPrice:Double,maxSpace:Int,type:String)
    {
        viewForEstimateCost.isHidden = true
        viewForFixedFare.isHidden = false
        lblTripType.text = type
        lblFixedFareMaxSizeValue.text = maxSpace.toString() + " " + "TXT_PERSON".localized
        lblFixedRateValue.text = fixedPrice.toCurrencyString(currencyCode: CurrentTrip.shared.currencyCode)
        lblFixedFareMaxSize.text = "TXT_MAX_SIZE".localized + " : "
        lblFixedRate.text = "TXT_FIXED_RATE".localized + " : "
        
        stkSurgeView.isHidden = true
        lblFareAmount.text = "TXT_FIXED_RATE".localized
        lblEstMsg.text = "TXT_FARE_ESTIMATE_MSG_FIXED_RATE".localized
        
    }
    
}
