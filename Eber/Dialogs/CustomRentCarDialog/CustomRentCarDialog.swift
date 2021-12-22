//
//  CustomRentCarDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomRentCarDialog: CustomDialog, UITableViewDataSource, UITableViewDelegate
{
    //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblPackages: UITableView!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    //MARK:Variables
    var onClickRightButton : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  verificationDialog = "dialogForRentCar"
    
    @IBOutlet weak var heightForTable: NSLayoutConstraint!
    
    public static func  showCustomRentCarDialog
        (title:String,
         message:String,
         titleLeftButton:String,
         titleRightButton:String,
         tag:Int = 403
        ) ->
        CustomRentCarDialog
    {
        
        
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomRentCarDialog
        view.tag = tag
        view.alertView.setShadow()
        view.alertView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = "TXT_PACKAGES".localized;
        view.tblPackages.dataSource = view
        view.tblPackages.delegate = view
        view.tblPackages.tableFooterView = UIView.init()
        view.setLocalization()
        view.tblPackages.estimatedRowHeight = 150
        
        view.tblPackages.register(UINib.init(nibName: "CustomRentalPackageCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        view.btnLeft.setTitle(titleLeftButton.capitalized, for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.capitalized, for: UIControl.State.normal)
        view.tblPackages.reloadData()
        let height = view.tblPackages.contentSize.height
        if height > 400
        {
            view.heightForTable.constant = 400
        }
        else
        {
            view.heightForTable.constant = height
        }
        
        if let view = (APPDELEGATE.window?.viewWithTag(403))
        {
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        }
        else
        {
            UIApplication.shared.keyWindow?.addSubview(view)
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        }
        view.btnLeft.isHidden =  titleLeftButton.isEmpty()
        view.btnRight.isHidden =  titleRightButton.isEmpty()
        
        return view;
    }
    
    func setLocalization(){
        
        btnLeft.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnLeft.titleLabel?.font =  FontHelper.font(type: FontType.Regular)
        
        
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        btnRight.setupButton()
        
        
        lblTitle.textColor = UIColor.themeTitleColor
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        
        /* Set Font */
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
    }
    
    //ActionMethods
    
    @IBAction func onClickBtnLeft(_ sender: Any)
    {
        CurrentTrip.shared.selectedVehicle.selectedCarRentelId =  ""
        if self.onClickLeftButton != nil
        {
            self.onClickLeftButton!();
        }
        
    }
    @IBAction func onClickBtnRight(_ sender: Any)
    {
        if CurrentTrip.shared.selectedVehicle.selectedCarRentelId.isEmpty()
        {
            Utility.showToast(message: "VALIDATION_MSG_PLEASE_SELECT_VALID_PACKAGE".localized)
        }
        else
        {
        if self.onClickRightButton != nil
        {
            self.onClickRightButton!()
        }
        }
    }
  
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        tableView.deselectRow(at: indexPath, animated: true)
        CurrentTrip.shared.selectedVehicle.selectedCarRentelId =  CurrentTrip.shared.selectedVehicle.carRentalList[indexPath.row].id
        tableView.reloadData()
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
        printE(CurrentTrip.shared.selectedVehicle.carRentalList.count)
        return CurrentTrip.shared.selectedVehicle.carRentalList.count
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! CustomRentalPackageCell;
        let package:CarRentalList = CurrentTrip.shared.selectedVehicle.carRentalList[indexPath.row]
        cell.setData(data: package)
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


class CustomRentalPackageCell:UITableViewCell
{
    @IBOutlet weak var lblPackageName: UILabel!
  
    @IBOutlet weak var lblBasePrice: UILabel!
    @IBOutlet weak var lblBaseTimeAndDistance: UILabel!
    
    @IBOutlet weak var lblExtraDistanceAndTimePrice: UILabel!
    @IBOutlet weak var btnPackageSelected: UIButton!
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib() {
        
        lblPackageName.textColor = UIColor.themeTextColor
        
        lblPackageName.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        lblBasePrice.textColor = UIColor.themeTextColor
        lblBasePrice.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        lblBaseTimeAndDistance.textColor = UIColor.themeLightTextColor
        lblBaseTimeAndDistance.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblExtraDistanceAndTimePrice.textColor = UIColor.themeLightTextColor
        lblExtraDistanceAndTimePrice.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        
      
        
    }
    func setData(data:CarRentalList)
    {
        btnPackageSelected.isSelected = CurrentTrip.shared.selectedVehicle.selectedCarRentelId == data.id
        lblPackageName.text = data.typename
        lblBasePrice.text =  data.basePrice.toCurrencyString(currencyCode: CurrentTrip.shared.currencyCode)
        
        
        lblBaseTimeAndDistance.text =  data.basePriceTime.toString() + MeasureUnit.MINUTES + " & " + data.basePriceDistance.toString() + CurrentTrip.shared.distanceUnit
        
        lblExtraDistanceAndTimePrice.text = "TXT_EXTRA_DISTANCE_CHARGE".localized + data.pricePerUnitDistance.toCurrencyString(currencyCode: CurrentTrip.shared.currencyCode) + "\n" + "TXT_EXTRA_TIME_CHARGE".localized +  data.priceForTotalTime.toCurrencyString(currencyCode: CurrentTrip.shared.currencyCode)
    }
}
