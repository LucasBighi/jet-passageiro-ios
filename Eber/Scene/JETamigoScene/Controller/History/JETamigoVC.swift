//
//  JETamigoVC.swift
//  Edelivery
//
//   Created by Elluminati on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class JETamigoVC: BaseVC {

    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var viewForFilter: UIView!
    @IBOutlet weak var viewForFilterBackground: UIView!
    @IBOutlet weak var stackForDate: UIStackView!
    @IBOutlet weak var viewForFrom: UIView!
    @IBOutlet weak var viewForTo: UIView!
    @IBOutlet weak var btnFrom: UIButton!
    @IBOutlet weak var btnTo: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var lblIconCalender: UILabel!
    @IBOutlet var lblIconToCalender: UILabel!
    //Empty View
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var lblEmptyMsg: UILabel!
    @IBOutlet weak var lblReferralMsg: UILabel!

    var strToDate: String = ""
    var strFromDate: String = ""
    var arrForHistory: [JETAmigoReferral] = []

    var arrForCreateAt = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.wsGetHistory(startDate: strFromDate, endDate: strToDate);
        self.setLocalization()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    //MARK: Set localized layout
    func setLocalization() {
        view.backgroundColor = UIColor.themeViewBackgroundColor;
        tableView.backgroundColor = UIColor.themeViewBackgroundColor
        updateUI(isUpdated: false)
     
        lblEmptyMsg.textColor = UIColor.themeTextColor
        lblEmptyMsg.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblEmptyMsg.text = "TXT_EMPTY_HISTORY_MSG".localized
        
        lblEmpty.textColor = UIColor.themeTextColor
        lblEmpty.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        lblEmpty.text = "TXT_EMPTY_HISTORY".localized
        
        lblTitle.text = "TXT_JETAMIGO".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        //LOCALIZED
        btnFrom.setTitle("TXT_FROM".localizedCapitalized, for: UIControl.State.normal)
        btnTo.setTitle("TXT_TO".localizedCapitalized, for: UIControl.State.normal)
        
        btnApply.setTitle(FontAsset.icon_search, for: .normal)
        btnApply.setRoundIconButton()
            
        //COLORS
        emptyView.backgroundColor = UIColor.themeViewBackgroundColor;
        viewForFilterBackground.backgroundColor = UIColor.groupTableViewBackground
        viewForTo.backgroundColor = UIColor.clear
        viewForFrom.backgroundColor = UIColor.clear
        btnFrom.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnTo.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)

        /*Set Font*/
        btnFrom.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        btnTo.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        lblIconCalender.text = FontAsset.icon_calender_blank
        lblIconToCalender.text = FontAsset.icon_calender_blank
        lblIconToCalender.setForIcon()
        lblIconCalender.setForIcon()
        
        lblIconCalender.font = FontHelper.assetFont(size: 14)
        lblIconToCalender.font = FontHelper.assetFont(size: 14)
        
        btnReset.setTitle(FontAsset.icon_refresh, for: .normal)
        btnMenu.setupBackButton()
        btnReset.setUpTopBarButton()
        btnReset.setTitleColor(.themeTitleColor, for: .normal)
        btnReset.setTitleColor(.themeTitleColor, for: .selected)

        btnShare.setTitle("   " + "TXT_SHARE_REFERRAL_CODE".localizedCapitalized + "   ", for: .normal)
        btnShare.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnShare.backgroundColor = UIColor.themeButtonBackgroundColor
        btnShare.titleLabel?.font  = FontHelper.font(size: FontSize.regular, type: FontType.Bold)

        lblReferralMsg.text = "TXT_SHARE_REFERRAL_MSG".localized
        lblReferralMsg.textColor = UIColor.themeTextColor
        lblReferralMsg.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
    }

    func setupLayout() {
        viewForFilterBackground.setRound(withBorderColor: UIColor.clear, andCornerRadious: 20, borderWidth: 1.0)
        navigationView.navigationShadow()
        btnShare.setRound(withBorderColor: UIColor.clear, andCornerRadious: 25.0, borderWidth: 1.0)
    }

    //MARK:- Button action method
    @IBAction func onClickFromTo(_ sender: UIButton) {
        if sender.tag == 10 {
            let datePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_FROM_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
            datePickerDialog.setMaxDate(maxdate: Date())
            if !strToDate.isEmpty() {
                let maxDate = strToDate.toDate(format: DateFormat.DATE_DD_MM_YYYY)
                datePickerDialog.setMaxDate(maxdate: maxDate)
            }

            datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                datePickerDialog.removeFromSuperview()
            }
            
            datePickerDialog.onClickRightButton = { [unowned self, unowned datePickerDialog] selectedDate in
                self.strFromDate = selectedDate.toString(withFormat: DateFormat.DATE_DD_MM_YYYY)
                self.btnFrom.setTitle(String(format: "%@",self.strFromDate), for: .normal)
                datePickerDialog.removeFromSuperview()
            }
        } else {
            if btnFrom.titleLabel?.text == "TXT_FROM".localized {
                let alertController = UIAlertController(title: "TXT_WARNING".localized,
                                                        message: "MSG_INVALID_DATE_WARNING".localized,
                                                        preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "TXT_OK".localized, style: .default)
                alertController.addAction(yesAction)
                present(alertController, animated: true, completion: nil)
            } else {
                let datePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_TO_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
                let minidate = strFromDate.toDate(format: DateFormat.DATE_DD_MM_YYYY)
                datePickerDialog.setMaxDate(maxdate: Date())
                datePickerDialog.setMinDate(mindate: minidate)
                datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                    datePickerDialog.removeFromSuperview()
                }
                datePickerDialog.onClickRightButton = { [unowned self, unowned datePickerDialog] selectedDate in
                    self.strToDate = selectedDate.toString(withFormat: DateFormat.DATE_DD_MM_YYYY)
                    self.btnTo.setTitle(String(format: "%@",self.strToDate), for: .normal)
                    datePickerDialog.removeFromSuperview()
                }
            }
        }
    }

    @IBAction func onClickBtnShare(_ sender: Any) {

        let myString = "MSG_SHARE_REFERRAL".localized + CurrentTrip.shared.user.referralCode


        let textToShare = [ myString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.navigationController?.present(activityViewController, animated: true, completion: nil)
     }

    @IBAction func onClickBtnResetFilter(_ sender: UIButton) {
        strToDate = ""
        strFromDate = ""
        wsGetHistory(startDate: strFromDate, endDate: strToDate)
    }

    @IBAction func onClickBtnApplyFilter(_ sender: UIButton) {
        if strFromDate.isEmpty() || strToDate.isEmpty() {
            Utility.showToast(message: "VALIDATION_MSG_PLEASE_SELECT_DATE_FIRST".localized);
        } else {
            wsGetHistory(startDate: strFromDate, endDate: strToDate);
        }
    }

    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVc = segue.destination as? HistoryDetailVC {
            destinationVc.tripID = sender as! String
        }
    }

    //MARK:- User Define Function
    func updateUI(isUpdated: Bool = false) {
        emptyView.isHidden = isUpdated
        tableView.isHidden = !isUpdated
        btnFrom.setTitle("TXT_FROM".localizedCapitalized, for: .normal)
        btnTo.setTitle("TXT_TO".localizedCapitalized, for: .normal)
    }
}

//MARK - Web Service

extension JETamigoVC {
    func wsGetHistory(startDate: String,endDate: String) {
        Utility.showLoading()
        let dictParam: [String: String] =
            [PARAMS.TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.START_DATE : startDate,
             PARAMS.END_DATE : endDate]

        let alamoFire = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_JETAMIGO_LIST,
                                     methodName: AlamofireHelper.POST_METHOD,
                                     paramData: dictParam) { [unowned self] response, error in
            if error != nil {
                Utility.hideLoading()
            } else {
                Utility.hideLoading()
                self.arrForHistory.removeAll()
                if Parser.isSuccess(response: response) {
                    let responseModel = JETAmigoResponse(fromDictionary: response)
                    let historyOrderList: [JETAmigoReferral] = responseModel.refferals
                    if historyOrderList.count > 0 {
                        let sortedArray = historyOrderList.sorted{ $0.date > $1.date }
                        for data in sortedArray {
                            self.arrForHistory.append(data)
                        }
                        self.updateUI(isUpdated: true)
                    } else {
                        self.updateUI(isUpdated: false)
                    }
                } else {
                    self.updateUI(isUpdated: false)
                }
                DispatchQueue.main.async { [unowned self] in
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//MARK - Table view delegate
extension JETamigoVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JETamigoCell
        cell.setHistoryData(data: arrForHistory[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func onClickBtnMenu(_ sender: Any) {
        let navigationVC = revealViewController()?.mainViewController as? UINavigationController
        navigationVC?.popToRootViewController(animated: true)
    }
}
