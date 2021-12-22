import Foundation

public class Country: ModelNSObj
{
	public var countryPhoneCode : String!
	public var countryName : String!
	public var countryCode : String!
	public var phoneNumberLength : Int!
    public var phoneNumberMinLength : Int!
    public var countryFlag : String!

    
    
    
    
    public class func modelsFromDictionaryArray() -> [Country]
    {
        var models:[Country] = []
        
        guard let path = Bundle.main.path(forResource: "country_list", ofType: "json") else
        {
            return  []
            
        }
        let url = URL(fileURLWithPath: path)
        
        do {
            
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            //printE(json)
            
            guard let array = json as? [Any] else
            {
                return []
            }
            for country in array
            {
               models.append(Country(dictionary: country as! [String:Any])!)
           }
        }
        catch {
            printE(error)
        }
        
        return models
    }

    required public init?(dictionary: [String:Any])
    {
        countryPhoneCode = (dictionary["countryphonecode"] as? String) ?? "+55"
		countryName = (dictionary["countryname"] as? String) ?? "Brazil"
		countryCode = (dictionary["country_code"] as? String) ?? "BR"
		phoneNumberMinLength = (dictionary["phone_number_min_length"] as? Int) ?? 10
        phoneNumberLength = (dictionary["phone_number_length"] as? Int) ?? 11
        countryFlag = (dictionary["country_flag"] as? String) ?? "🇧🇷"
    }
}
