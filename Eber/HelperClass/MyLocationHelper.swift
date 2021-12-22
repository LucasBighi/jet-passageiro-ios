import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces




class LocationManager: NSObject, CLLocationManagerDelegate
{
    
    var blockCompletion: ((CLLocation?, _ error: Error?)->())?
    var autoUpdate:Bool = false

    lazy var locationManager: CLLocationManager! =
        {
            let location = CLLocationManager()
            location.delegate = self
            location.activityType = .automotiveNavigation // .automotiveNavigation will stop the updates when the device is not moving
            location.distanceFilter = 5
            location.desiredAccuracy = 5
            location.requestWhenInUseAuthorization();
            location.startUpdatingLocation()
            return location
    }()
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    let geocoder = CLGeocoder()
    //MARK: Core Location delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        self.locationManager.stopUpdatingLocation()
        self.blockCompletion?(nil, error)
        // self.blockCompletion(manager.location, nil)
    }
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let currentLocation = locations.last {
            CurrentTrip.shared.currentCoordinate = currentLocation.coordinate
            self.blockCompletion?(locations.last, nil)
            if autoUpdate == false {
                self.locationManager.stopUpdatingLocation()
            }
            if self.blockCompletion != nil && autoUpdate {
                self.blockCompletion?(locations.last, nil)
            }
            return
        }
        else {
            if self.blockCompletion != nil && autoUpdate {
                self.blockCompletion?(nil, nil)
            }
        }
        if autoUpdate == false {
            self.locationManager.stopUpdatingLocation()
        }
        
    }
    //MARK: My LocationManager API
    func currentLocation(blockCompletion:@escaping (CLLocation?, Error?)->Void) {
        self.blockCompletion = blockCompletion;
        self.locationManager.startUpdatingLocation()
    }
    func currentUpdatingLocation(blockCompletion:@escaping (CLLocation?, Error?)->Void) {
        self.blockCompletion = blockCompletion;
        self.locationManager.startUpdatingLocation()
    }
    
    //MARK: - Get Lat Long From Goole API
    
    func getAddressFromLatitudeLongitude(latitude:Double,longitude:Double, completion: @escaping (String,[Double])->Void)
    {
        print(arrForLanguages[preferenceHelper.getLanguage()].code)
        print("JD GEO CODE API CALLED - location to address")
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        if coordinate.isValidCoordinate()
        {
            let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
            
            aGMSGeocoder.reverseGeocodeCoordinate(coordinate) { (gmsReverseGeocodeResponse, error) in
                if error == nil {
                    if let gmsAddress: GMSAddress = gmsReverseGeocodeResponse?.firstResult() {
                        let latitude = gmsAddress.coordinate.latitude
                        let longitude = gmsAddress.coordinate.longitude
                        var address: String = ""
                        for line in  gmsAddress.lines ?? [] {
                            address += line + " "
                        }
                        completion(address,[latitude,longitude])
                    } else {
                        completion("",[0.0,0.0])
                    }
                }
                else {
                    completion("",[0.0,0.0])
                }
            }
        }
        else {
            completion("",[0.0,0.0])
        }
    }

    func getLatLongFromAddress(address:String) -> [Double]
    {
        if address.isEmpty()
        {
            return [0.0,0.0]
        }
        else
        {
            let strURL:String = "\(Google.GEOCODE_URL)\(Google.ADDRESS)=\(address)&\(Google.KEY)=\(preferenceHelper.getGoogleKey())&language=\(arrForLanguages[preferenceHelper.getLanguage()].code)"
            print("geocode url = \(strURL)")
            let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            
            guard let url = URL(string: urlStr)
                else
            {
                return [0.0,0.0]
            }
            
            do{
                print("JD GEO CODE API CALLED - address to location")
                let data = try Data(contentsOf: url)
                let jsonObject:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                if ((jsonObject[Google.STATUS] as! String) == Google.OK)
                {
                    let resultObject:[String:Any] = ((jsonObject[Google.RESULTS] as! NSArray)[0] as! [String:Any])
                    
                    let geometryObject:[String:Any] = resultObject[Google.GEOMETRY] as! [String:Any];
                    
                    let latitude = ((geometryObject[Google.LOCATION] as! [String:Any])[Google.LAT] as? Double) ?? 0.0
                    
                    let longitude =
                        ((geometryObject[Google.LOCATION] as! [String:Any])[Google.LNG] as? Double) ?? 0.0
                    return [latitude,longitude]
                }
                return [0.0,0.0]
            }
            catch _ as NSError
            {
                return [0.0,0.0]
            }
        }
    }

    func fetchCityAndCountry(location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ())
    {
        if geocoder.isGeocoding {
            geocoder.cancelGeocode()
        }

        if #available(iOS 11.0, *) {
            geocoder.reverseGeocodeLocation(location, preferredLocale: Locale.init(identifier: "en_US_POSIX"))
            { placemarks, error in

                if (error == nil) {
                    if CurrentTrip.shared.currentCountryCode.isEmpty()
                    {
                        CurrentTrip.shared.currentCountryCode = (placemarks?.first?.isoCountryCode)
                            ?? ""
                    }
                    completion(placemarks?.first?.locality,
                               placemarks?.first?.country,
                               error)


                } else{
                    if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                        if CurrentTrip.shared.currentCountryCode.isEmpty()
                        {
                            CurrentTrip.shared.currentCountryCode = countryCode

                        }
                        completion(placemarks?.first?.locality,
                                   Locale.current.countryName(from: countryCode),
                                   nil)
                    }
                    else{
                        completion(placemarks?.first?.locality,
                                   placemarks?.first?.country,
                                   error)

                    }
                }

            }
        } else {
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                
                if CurrentTrip.shared.currentCountryCode.isEmpty()
                {
                    CurrentTrip.shared.currentCountryCode = (placemarks?.first?.isoCountryCode)
                        ?? ""
                }
                
                completion(placemarks?.first?.locality,
                           placemarks?.first?.country,
                           error)
            }
        }
        
        
    }
    
    func checkForLocationPermission()
    {
        
    }
    
    func googlePlacesResult(input: String, completion: @escaping (_ result: [(title:String,subTitle:String,address:String, placeid:String)]) -> Void)
    {
        if !input.isEmpty()
        {
            var token: GMSAutocompleteSessionToken!

            if let currentToken = GoogleAutoCompleteToken.shared.token {
                if GoogleAutoCompleteToken.shared.isExpired() {
                    GoogleAutoCompleteToken.shared.token = GMSAutocompleteSessionToken.init()
                    GoogleAutoCompleteToken.shared.milliseconds = Date().millisecondsSince1970
                    token = GoogleAutoCompleteToken.shared.token!
                    debugPrint("\(#function) GMS Token Re-Generated - \(token) at \(GoogleAutoCompleteToken.shared.milliseconds)")
                } else {
                    token = currentToken
                    debugPrint("\(#function) GMS Token Re-Used - \(token)")
                }

            } else {
                GoogleAutoCompleteToken.shared.token = GMSAutocompleteSessionToken.init()
                GoogleAutoCompleteToken.shared.milliseconds = Date().millisecondsSince1970
                token = GoogleAutoCompleteToken.shared.token!
                debugPrint("\(#function) GMS Token Generated - \(token) at \(GoogleAutoCompleteToken.shared.milliseconds)")
            }

            // Create a type filter.
            let filter = GMSAutocompleteFilter()
            filter.country = CurrentTrip.shared.currentCountryCode
            filter.type = .noFilter
            let placeClient = GMSPlacesClient.shared()

            placeClient.findAutocompletePredictions(fromQuery: input,
                                                    filter: filter,
                                                    sessionToken: token) { results, error in
                var myAddressArray :[(title:String,subTitle:String,address:String,placeid:String)] = []
                if let error = error
                {
                    printE("Autocomplete error: \(error)")
                    completion(myAddressArray)
                    return
                }
                if let results = results {
                    myAddressArray = []
                    for result in results
                    {

                        let mainString = (result.attributedPrimaryText.string)

                        let subString = (result.attributedSecondaryText?.string) ?? ""

                        let detailString = result.attributedFullText.string
                        let placeId = result.placeID

                        let myAddress:(title:String,subTitle:String,address:String,placeid:String) = (mainString,subString,detailString,placeId)

                        myAddressArray.append(myAddress)
                    }

                    completion(myAddressArray)

                }
                completion(myAddressArray)
            }
        }
    }
    
    func getTimeAndDistance(sourceCoordinate:CLLocationCoordinate2D,destCoordinate:CLLocationCoordinate2D) -> (time:String,distance:String)
    {
        var timeAndDistance:(time:String, distance:String)
        timeAndDistance.time = "0";
        timeAndDistance.distance = "0";
        

        if sourceCoordinate.isValidCoordinate() && destCoordinate.isValidCoordinate() {

            if sourceCoordinate.isEqual(destCoordinate) {
                return timeAndDistance
            }

            print("JD DISTANCE MATXI API CALLED")
            let pickup_latitude:String = sourceCoordinate.latitude.toString(places: 6)
            let pickup_longitude:String = sourceCoordinate.longitude.toString(places: 6)
            let destination_latitude:String = destCoordinate.latitude.toString(places: 6)
            let destination_longitude:String = destCoordinate.longitude.toString(places: 6)

            //            let strUrl:String = Google.TIME_DISTANCE_URL + "\(pickup_latitude),\(pickup_longitude)&destinations=\(destination_latitude),\(destination_longitude)&key=\(preferenceHelper.getGoogleKey())&language=\(arrForLanguages[preferenceHelper.getLanguage()].code)"

            let strUrl = "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=\(destination_latitude),\(destination_longitude)&origins=\(pickup_latitude),\(pickup_longitude)&units=metric&key=\(preferenceHelper.getGoogleKey())&language=\(arrForLanguages[preferenceHelper.getLanguage()].code)"

            print("distance matrix url = \(strUrl)")

            if let url:URL = URL.init(string: strUrl)
            {
                let parseData = parseJSON(inputData: getJSON(urlToRequest: url))

                let googleRsponse: GoogleDistanceMatrixResponse = GoogleDistanceMatrixResponse(dictionary:parseData)!
                if ((googleRsponse.status?.compare("OK")) == ComparisonResult.orderedSame)
                {
                    timeAndDistance.time = String((googleRsponse.rows?[0].elements?[0].duration?.value) ?? 0)
                    timeAndDistance.distance = String((googleRsponse.rows?[0].elements?[0].distance?.value) ?? 0)

                }
            }

        }

        return timeAndDistance
    }
    
    func getJSON(urlToRequest:URL) -> Data
    {
        var content:Data?
        do
        {
            content = try Data(contentsOf:urlToRequest)
        }
        catch let error
        {
            printE(error)
        }
        return content ?? Data.init()
    }
    
    func parseJSON(inputData:Data) -> NSDictionary{
        var dictData: NSDictionary = NSDictionary.init()
        if inputData.count > 0
        {
            do
            {
              if let data = (try JSONSerialization.jsonObject(with: inputData, options: .mutableContainers)) as? NSDictionary
              {
                dictData = data
              }
            }
            catch
            {
                print("Response not proper")
            }
           
        }
        return dictData
    }
    
    func requestUserLocation() -> Bool
    {
        //when status is not determined this method runs to request location access
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizedToRequestLocation() {
            
            //have accuracy set to best for navigation - accuracy is not guaranteed it 'does it's best'
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            
            //find out current location, using this one time request location will start the location services and then stop once have the location within the desired accuracy -
            locationManager.requestLocation()
            return true
        }
        else
        {
            //show alert for no location permission
            if CLLocationManager.authorizationStatus() != .notDetermined
            {
                showAlertNoLocation()
            }
            
            return false
        }
    }
    
    func showAlertNoLocation()
    {
        
        
        let dialogForLocation  = CustomAlertDialog.showCustomAlertDialog(title: "TXT_LOCATION_SERVICE".localized, message: "ALERT_MSG_LOCATION_SERVICE_NOT_AVAILABLE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
        
        dialogForLocation.onClickLeftButton =
            { [/*unowned self,*/ unowned dialogForLocation] in
                dialogForLocation.removeFromSuperview();
        }
        dialogForLocation.onClickRightButton =
            { [/*unowned self,*/ unowned dialogForLocation] in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    dialogForLocation.removeFromSuperview();
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl)
                {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            
                        })
                    } else
                    {
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
                dialogForLocation.removeFromSuperview();
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if !CLLocationManager.authorizedToRequestLocation()
        {
            if CLLocationManager.authorizationStatus() != .notDetermined
            {
                showAlertNoLocation()
            }
            
        }
    }
}

extension CLLocationManager {
    static func authorizedToRequestLocation() -> Bool {
        return CLLocationManager.locationServicesEnabled() &&
            (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
    }
}

public class GoogleAutoCompleteToken
{
    static let shared = GoogleAutoCompleteToken()
    var token:GMSAutocompleteSessionToken? = nil
    var milliseconds: Double = 0
    private init()
    {

    }
    func isExpired() -> Bool{
        let difference = (Date().millisecondsSince1970 - self.milliseconds)
        return difference > (180000)

    }
}

extension CLLocationCoordinate2D {
    func isValidCoordinate() -> Bool {
        if self.latitude == 0.0 && self.longitude == 0.0 {
            return false
        }
        return CLLocationCoordinate2DIsValid(self)
    }

    func isEqual(_ coord: CLLocationCoordinate2D) -> Bool {
            return self.latitude == coord.latitude && self.longitude == coord.longitude
    }

}

extension Locale {

    func countryName(from countryCode: String) -> String? {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return countryCode
        }
    }

}
