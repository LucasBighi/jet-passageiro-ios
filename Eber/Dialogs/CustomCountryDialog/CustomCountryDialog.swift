//
//  CustomCountryDialog.swift
//  Cabtown
//
//  Created by Elluminati on 24/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CustomCountryDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    struct Identifiers
    {
        static let  CountryDialog = "dialogForCountry"
        static let  CellForCountry = "CustomCountryCell"
        static let  reuseCellIdentifier = "cellForCountry"
    }
    //MARK:- Outlets

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableForCountry: UITableView!
    
    @IBOutlet var lblIconSearch: UILabel!
    
    @IBOutlet weak var alertView: UIView!
    //MARK:- Variables
    var coutrylist:[Country] = [];
    var filteredCountries = [Country]()
    var onCountrySelected : ((_ country:Country) -> Void)? = nil
    
    override func awakeFromNib()
    {
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        lblTitle.textColor = UIColor.themeTitleColor
        txtSearch.font = FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        lblIconSearch.text = FontAsset.icon_search
        lblIconSearch.setForIcon()
        
    }
    public static func  showCustomCountryDialog() -> CustomCountryDialog
    {
        let view = UINib(nibName: Identifiers.CountryDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomCountryDialog

        view.alertView.setShadow()
        view.alertView.setRound(withBorderColor: UIColor.lightText, andCornerRadious: 10.0, borderWidth: 0.5)
        view.tableForCountry.delegate = view;
        view.tableForCountry.dataSource = view;
        view.txtSearch.delegate = view;
        view.txtSearch.placeholder = "TXT_SEARCH_COUNTRY".localized
        view.coutrylist = CurrentTrip.shared.arrForCountries
        view.filteredCountries = CurrentTrip.shared.arrForCountries
        view.tableForCountry.register(UINib.init(nibName: Identifiers.CellForCountry, bundle: nil), forCellReuseIdentifier: Identifiers.reuseCellIdentifier)
        view.tableForCountry.tableFooterView = UIView.init()
        let frame = (UIApplication.shared.keyWindow?.frame)!;
        view.frame = frame
        UIApplication.shared.keyWindow?.addSubview(view)
        UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        return view;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let country:Country = filteredCountries[indexPath.row]
        if self.onCountrySelected != nil
        {
            self.onCountrySelected!(country)
        }
        self.removeFromSuperview();
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if filteredCountries.count > 0
        {
            return filteredCountries.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:Identifiers.reuseCellIdentifier, for: indexPath) as! CustomCountryCell;
        
        let country:Country = filteredCountries[indexPath.row]
        cell.lblCountryName.text = country.countryName
        cell.lblCountryPhoneCode.text = country.countryPhoneCode
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    @IBAction func onClickBtnClose(_ sender: Any)
    {
        self.removeFromSuperview();
    }
    @IBAction func searching(_ sender: Any) {
        let text = txtSearch.text!.lowercased()
        if text.isEmpty
        {
            filteredCountries.removeAll()
            filteredCountries.append(contentsOf: coutrylist)
        }
        else
        {
            filteredCountries.removeAll()
            for country in coutrylist
            {
                guard let name = country.countryName else
                {
                    return
                }
                if  name.lowercased().hasPrefix(text)
                {
                    filteredCountries.append(country)
                }
            }
        }
        tableForCountry.reloadData()
    }
}

class CustomCountryCell:UITableViewCell
{
    @IBOutlet weak var lblCountryPhoneCode: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!

    deinit {
        printE("\(self) \(#function)")
    }

    override func awakeFromNib() {
        lblCountryPhoneCode.textColor = UIColor.themeTextColor
        lblCountryName.textColor = UIColor.themeLightTextColor
        lblCountryPhoneCode.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblCountryName.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
    }
}
