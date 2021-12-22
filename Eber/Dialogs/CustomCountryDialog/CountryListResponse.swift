//
//	CountryListResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class CountryListResponse: Model {

	var countryList : [Country]!
	var success : Bool!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		countryList = [Country]()
		if let countryListArray = dictionary["country_list"] as? [[String:Any]]{
			for dic in countryListArray
            {
				if let value = Country.init(dictionary: dic)
                {
                    countryList.append(value)
                }
			}
		}
		success = (dictionary["success"] as? Bool) ?? false
	}
}
