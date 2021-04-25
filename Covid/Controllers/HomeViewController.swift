//
//  HomeViewController.swift
//  Covid
//
//  Created by Jaafar Barek on 24/04/2021.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusDate: UILabel!
    @IBOutlet weak var riskLabel: UILabel!
    
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var activeButton: UIButton!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationView: UIView!
    var timer: Timer!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    var isActive = false {
        didSet {
            setActiveState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        
        if let isActiveDefault = UserDefaults.standard.value(forKey: "isActive") as? Bool {
            self.isActive = isActiveDefault
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        setActiveState()
    }
    
    func setActiveState() {
        if isActive {
            onActiveEnabled()
        } else {
            onActiveDisabled()
        }
    }
    
    func onActiveEnabled() {
//        if let quarintineDate = UserDefaults.standard.value(forKey: "activationDate") as? Date {
//            var dayComponent    = DateComponents()
//            dayComponent.day    = 14
//            let theCalendar     = Calendar.current
//            let nextDate        = theCalendar.date(byAdding: dayComponent, to: quarintineDate)
//            print("nextDate : \(nextDate)")
//            if let nextDate = nextDate {
//                updateTimerLabel(futureDate: nextDate)
//            }
//        }
        locationView.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true)
        
        
        statusView.backgroundColor = UIColor(red: 191, green: 0, blue: 67)
        statusLabel.text = "Corona Virus Detected"
        riskLabel.text = "HIGH RISK"
        
        activeView.isHidden = true
    }
    
    @objc func UpdateTime() {
        
        if let quarintineDate = UserDefaults.standard.value(forKey: "activationDate") as? Date {
            var dayComponent    = DateComponents()
            dayComponent.day    = 14
            let theCalendar     = Calendar.current
            let nextDate        = theCalendar.date(byAdding: dayComponent, to: quarintineDate)
            print("nextDate : \(nextDate)")
            if let nextDate = nextDate {
                updateTimerLabel(futureDate: nextDate)
            }
        }
    }
    
    func updateTimerLabel(futureDate: Date) {
        let calendar = Calendar.current
        let now = Date()

        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: futureDate)


        let days = String(describing: components.day ?? 0)
        let hours = String(describing: components.hour ?? 0)
        let minutes = String(describing: components.minute ?? 0)
        let seconds = String(describing: components.second ?? 0)

//        print(components) // day: 723942 hour: 23 minute: 56 second: 0 isLeapMonth: false

        self.statusDate.text = "Quarantine till \(days) days, \(hours)h, \(minutes)m, \(seconds)s"
    }
    
    func onActiveDisabled() {
        statusView.backgroundColor = UIColor(red: 60, green: 141, blue: 85)
        statusLabel.text = "No exposures"
        statusDate.text = "Update today at: \(Date())"
        riskLabel.text = "LOW RISK"
        activeView.isHidden = false
        locationView.isHidden = true
    }

    @IBAction func onActivateButtonTap(_ sender: UIButton) {
        UserDefaults.standard.setValue(true, forKey: "isActive")
        UserDefaults.standard.setValue(Date(), forKey: "activationDate")
        
        if let location = currentLocation {
            UserDefaults.standard.setValue(location, forKey: "location")
            sendActivateRequest(location: location)
        }
        
        self.isActive = true
    }
    
    
    func sendActivateRequest(location: CLLocationCoordinate2D) {
        guard let token = UserDefaults.standard.value(forKey: "token") as? String else {
            return
        }
        let params = ["location":"\(location.latitude),\(location.longitude)"] as Dictionary<String, String>

        var request = URLRequest(url: URL(string: "\(Constants.mainURL)user/activate")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
            } catch {
                print("error")
            }
        })

        task.resume()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            
            // CLLocationCoordinate2D; You have to put the coordinate that you want to listen
            if let current =  UserDefaults.standard.value(forKey: "location") as? CLLocationCoordinate2D {
                let region = CLCircularRegion(center: current, radius: 50, identifier: "Ur ID")
                region.notifyOnExit = true
                region.notifyOnEntry = true
                manager.startMonitoring(for: region)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.currentLocation = locValue
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        // User has exited from ur region
        locationLabel.text = "ALERT! Return to your quarantine location!"
        
        
        let content = UNMutableNotificationContent()
        content.title = "WARNING"
        content.subtitle = "Return to your quarantine location!"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // User has exited from ur region
        locationLabel.text = "You're in the correct location"
    }
}
