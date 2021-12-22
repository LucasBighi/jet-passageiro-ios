//
//  FeedbackVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class FeedbackVC: BaseVC, RatingViewDelegate, UITextViewDelegate{
    
    
    @IBOutlet var viewForFavourite: UIView!
    @IBOutlet var lblFavourite: UILabel!
    @IBOutlet var lblIconForFavourite: UILabel!
    @IBOutlet var btnFavourite: UIButton!
    
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var navigationView: UIView!
    
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ratingView: RatingView!
        
  @IBOutlet weak var txtComment: UITextView!
  @IBOutlet weak var btnSubmit: UIButton!
  @IBOutlet weak var btnCancel: UIButton!
  
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDistanceValue: UILabel!
    
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblTotalTimeValue: UILabel!
    
    @IBOutlet weak var lblComments: UILabel!
    
    @IBOutlet weak var lblIconETA: UILabel!
    @IBOutlet weak var lblIconDistance: UILabel!
    @IBOutlet weak var lblDivider: UIView!
    var tripDetail:InvoiceTrip = InvoiceTrip.init(fromDictionary: [:])
    

    var isFromHistory:Bool = false
    var providerDetail:InvoiceProvider = InvoiceProvider.init(fromDictionary: [:])
    
    
    let toolBar = UIToolbar()
    var rate:Float =  0.0
    
    //MARK:
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()
        self.updateUIForFavouriteDriver(isFavourite: CurrentTrip.shared.tripStaus.trip.isFavouriteProvider)
        
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        imgProfilePic.setRound()
        navigationView.navigationShadow()
    }
    
    
    //MARK:
    //MARK: Set localized layout
    func setLocalization()
    {
        self.createToolbar(textview: txtComment)
        rate = 0.0
        // Required float rating view params
       
        // Optional params
        self.ratingView.delegate = self
        self.ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 1
        self.ratingView.rating = 0.0
        self.ratingView.editable = true
        self.ratingView.minImageSize = CGSize.init(width: 20, height: 20)
        txtComment.text = ""
        
        txtComment.placeholder = "TXT_COMMENT_PLACEHOLDER".localized
        
        // COLORS
        
        lblName.textColor = UIColor.themeTextColor
        txtComment.textColor = UIColor.themeLightTextColor
        txtComment.tintColor = UIColor.themeLightTextColor
        lblDivider.backgroundColor = UIColor.themeTextColor
        
        
        // LOCALIZED
        
        self.title = "TXT_FEEDBACK".localized
        
        
        txtComment.delegate = self
        /*Set Font*/
        lblName.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        txtComment.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
      
        
        
        
        lblName.text = providerDetail.first_name + " " + providerDetail.last_name
        
        imgProfilePic.downloadedFrom(link: providerDetail.picture)
        lblDistance.text = "TXT_DISTANCE".localized
        lblDistance.textColor = UIColor.themeLightTextColor
        lblDistance.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        
        
        lblComments.text = "TXT_COMMENTS".localized
        lblComments.textColor = UIColor.themeLightTextColor
        lblComments.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblTotalTime.text = "TXT_TIME".localized
        lblTotalTime.textColor = UIColor.themeLightTextColor
        lblTotalTime.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        lblDistanceValue.textColor = UIColor.themeTextColor
        lblDistanceValue.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)

        self.lblDistanceValue.text =  tripDetail.totalDistance.toString(places: 2) + " " + Utility.getDistanceUnit(unit: tripDetail.unit)

        lblTotalTimeValue.textColor = UIColor.themeTextColor
        lblTotalTimeValue.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        Utility.hmsFrom(seconds: tripDetail.totalTime * 60, completion: { (hours, minutes, seconds) in
            if hours > 0
            {
                self.lblTotalTimeValue.text = hours.toString() + " : " + minutes.toString() + MeasureUnit.MINUTES
            }
            else
            {
                self.lblTotalTimeValue.text =  minutes.toString() + MeasureUnit.MINUTES
            }
        })
        
        
        btnCancel.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnCancel.titleLabel?.font =  FontHelper.font(size: FontSize.small
            , type:     FontType.Regular)
        btnCancel.setTitle("TXT_CANCEL".localizedCapitalized, for: .normal)
        
        btnSubmit.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        btnSubmit.setupButton()
        btnSubmit.setTitle("TXT_SUBMIT".localizedCapitalized, for: UIControl.State.normal)
        
        
        btnSubmit.titleLabel?.font =  FontHelper.font(size: FontSize.small
            , type:     FontType.Regular)
        lblIconETA.text = FontAsset.icon_time
        lblIconDistance.text = FontAsset.icon_distance
        lblIconForFavourite.text = FontAsset.icon_favourite
        
        lblIconDistance.setForIcon()
        lblIconETA.setForIcon()
        lblIconForFavourite.setForIcon()
        lblIconForFavourite.textColor = UIColor.themeButtonTitleColor
        
        viewForFavourite.backgroundColor = UIColor.themeButtonBackgroundColor
        viewForFavourite.setRound(withBorderColor: UIColor.clear, andCornerRadious: 20, borderWidth: 1.0)
        lblFavourite.textColor = UIColor.themeButtonTitleColor
        lblFavourite.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblFavourite.text = "TXT_FAVOURITE".localized
        
        
        
    }
    
    //MARK:
    //MARK: Textview Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
       
    }
  
    @IBAction func onClickBtnCancel(_ sender: Any) {
        if self.isFromHistory
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            APPDELEGATE.gotoMap()
        }
    }
    @IBAction func onClickBtnFavourite(_ sender: Any) {
        if btnFavourite.isSelected
        {
            self.wsRemoveFromFavouriteProvider()
        }
        else
        {
            self.wsAddToFavouriteProvider()
        }
    }
    
    
    //MARK:
    //MARK: Create Toolbar
    func createToolbar(textview : UITextView){
        
        toolBar.barStyle = UIBarStyle.black
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "TXT_DONE".localized,
            style: .plain,
            target: self,
            action: #selector(doneTextView(sender:))
        )
        doneButton.tag = textview.tag
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textview.inputAccessoryView = toolBar
    }
    @objc func doneTextView(sender : UIBarButtonItem){
        txtComment.resignFirstResponder()
       
    }
    
    //MARK:
    //MARK: Button action methods
    @IBAction func onClickSubmit(_ sender: UIButton)
    {
        if rate != 0.0
        {
            wsRateToProvider()
        }
        else
        {
            Utility.showToast(message: "VALIDATION_MSG_RATE_PROVIDER".localized)
        }
        
    }
    
    func RatingView(_ ratingView: RatingView, didUpdate rating: Float) {
        rate = rating
    }
    //MARK:Web Service Calls
    func wsRateToProvider()
    {
        
        Utility.showLoading()
        var review:String = txtComment.text ?? ""
        if review.compare("TXT_COMMENT_PLACEHOLDER".localized) == .orderedSame
        {
            review = ""
        }
        
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.TRIP_ID:tripDetail.id!,
             PARAMS.REVIEW:review,
             PARAMS.RATING:rate
        ];
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.RATE_PROVIDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        { (response, error) -> (Void) in
            Utility.hideLoading()
            if (Parser.isSuccess(response: response))
            {
                if self.isFromHistory
                {
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                APPDELEGATE.gotoMap()
                }
                return
            }
        }
 
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateUIForFavouriteDriver(isFavourite: Bool)
    {
        btnFavourite.isSelected = isFavourite
        if isFavourite
        {
            lblIconForFavourite.textColor = UIColor.themeErrorTextColor
        }
        else
        {
            lblIconForFavourite.textColor = UIColor.themeButtonTitleColor
        }
    }


}

extension FeedbackVC
{
    func wsAddToFavouriteProvider()
    {
        
        Utility.showLoading()
        
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID:tripDetail.providerId!,
        ];
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.ADD_FAVOURITE_DRIVER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        { (response, error) -> (Void) in
            Utility.hideLoading()
            if (Parser.isSuccess(response: response))
            {
                self.updateUIForFavouriteDriver(isFavourite: true)
            }
        }
        
        
    }
    
    func wsRemoveFromFavouriteProvider()
    {
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID:tripDetail.providerId!,
        ];
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.REMOVE_FAVOURITE_DRIVER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        { (response, error) -> (Void) in
            Utility.hideLoading()
            if (Parser.isSuccess(response: response))
            {
               self.updateUIForFavouriteDriver(isFavourite: false)
            }
        }
    }
}
