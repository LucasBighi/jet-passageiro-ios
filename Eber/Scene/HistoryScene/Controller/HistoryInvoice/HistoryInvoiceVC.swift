//
//  HistoryInvoiceVC.swift
//  Edelivery
//   Created by Ellumination 23/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class HistoryInvoiceVC: BaseVC
{
    
    /*Header View*/
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var lblPaymentIcon: UILabel!
    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalValue: UILabel!
    
    @IBOutlet weak var viewForiInvoiceDialog: UIView!
    @IBOutlet weak var lblTripId: UILabel!
    
    @IBOutlet weak var lblIconDistane: UILabel!
    @IBOutlet weak var tblForInvoice: UITableView!
    @IBOutlet weak var lblIconTime: UILabel!
    var arrForInvoice:[[Invoice]]  = []
    var historyInvoiceResponse:HistoryDetailResponse = HistoryDetailResponse.init(fromDictionary: [:])
    /*Footer View*/
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialViewSetup()
        setupInvoice()
     }
    
    func initialViewSetup()
    {
        lblTotalTime.text = ""
        lblTotalTime.textColor = UIColor.themeTextColor
        lblTotalTime.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        lblDistance.text = ""
        lblDistance.textColor = UIColor.themeTextColor
        lblDistance.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        lblPaymentMode.text = ""
        lblPaymentMode.textColor = UIColor.themeTextColor
        lblPaymentMode.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        
        lblTotal.text = "TXT_TOTAL".localized
        lblTotal.textColor = UIColor.themeLightTextColor
        lblTotal.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        
        lblTotalValue.text = ""
        lblTotalValue.textColor = UIColor.themeSelectionColor
        lblTotalValue.font = FontHelper.font(size: FontSize.doubleExtraLarge, type: FontType.Bold)
        
        
        lblTripId.text = ""
        lblTripId.textColor = UIColor.themeLightTextColor
        lblTripId.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        
        
        self.view.backgroundColor = UIColor.themeOverlayColor
        self.viewForiInvoiceDialog.setShadow()
        self.viewForiInvoiceDialog.setRound(withBorderColor: UIColor.clear, andCornerRadious: 10.0, borderWidth: 1.0)
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.dismissMe))
        self.view.addGestureRecognizer(tapGesture)
        
        lblPaymentIcon.text = FontAsset.icon_payment_card
        lblIconTime.text = FontAsset.icon_time
        lblIconDistane.text = FontAsset.icon_distance
        
        lblPaymentIcon.setForIcon()
        lblIconTime.setForIcon()
        lblIconDistane.setForIcon()
    }
    func setupInvoice()
    {
        let tripDetail:InvoiceTrip = historyInvoiceResponse.trip
        lblTripId.text = tripDetail.invoiceNumber
        lblTotalValue.text = tripDetail.total.toCurrencyString(currencyCode: tripDetail.currencycode)
        
        if tripDetail.paymentMode == TRUE {
            //imgPayment.image = UIImage.init(named: "asset-cash")
            lblPaymentMode.text = "TXT_PAID_BY_CASH".localized
            self.lblPaymentIcon.text = FontAsset.icon_payment_cash
        }
        else {
            //imgPayment.image = UIImage.init(named: "asset-card")
            lblPaymentMode.text = "TXT_PAID_BY_CARD".localized
            self.lblPaymentIcon.text = FontAsset.icon_payment_card
            
        }
        
        lblDistance.text = tripDetail.totalDistance.toString(places: 2) + Utility.getDistanceUnit(unit: tripDetail.unit)

        Utility.hmsFrom(seconds: Int(tripDetail.totalTime * 60)) { hours, minutes, seconds in
            
            if hours > 0
            {
                self.lblTotalTime.text = hours.toString() + " : " + minutes.toString() + MeasureUnit.MINUTES
            }
            else
            {
                self.lblTotalTime.text =  minutes.toString() + MeasureUnit.MINUTES
            }
           
        }
        if Parser.parseInvoice(tripService: historyInvoiceResponse.tripservice, tripDetail: historyInvoiceResponse.trip, arrForInvocie: &arrForInvoice)
        {
        tblForInvoice.reloadData()
        }
        
        
        
    }
    @objc func dismissMe()
    {
        self.dismiss(animated: true, completion: nil)
    }
}


extension HistoryInvoiceVC :UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrForInvoice.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForInvoice[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryInvoiceCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HistoryInvoiceCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentInvoiceItem:Invoice = arrForInvoice[indexPath.section][indexPath.row]
        cell.setCellData(cellItem: currentInvoiceItem)
        return cell;
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 0
        }
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! HistoryInvoiceSection
        sectionHeader.setData(title: arrForInvoice[section][0].sectionTitle)
        return sectionHeader
    }
   
}



class HistoryInvoiceCell:UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib() {
        lblTitle.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblTitle.textColor = UIColor.themeLightTextColor
        lblTitle.text = ""
        
        lblSubTitle.font = FontHelper.font(size: FontSize.small, type: .Light)
        lblSubTitle.textColor = UIColor.themeLightTextColor
        lblSubTitle.text = ""
        
        lblPrice.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        lblPrice.textColor = UIColor.themeTextColor
        lblPrice.text = ""
        
        
    }
    func setCellData(cellItem:Invoice)
    {
        lblTitle.text = cellItem.title!
        lblSubTitle.text = cellItem.subTitle!
        lblPrice.text = cellItem.price
    }
}

class HistoryInvoiceSection:UITableViewCell
{
    @IBOutlet weak var lblSection: UILabel!
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib() {
        lblSection.textColor = UIColor.themeSelectionColor
        lblSection.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
    }
    func setData(title: String)
        
    {
        lblSection.text =  title
    }
}
