//
//  DetailsViewController.swift
//  Beacon
//
//  Created by Rahul Garg on 20/02/16.
//  Copyright © 2016 Rahul Garg. All rights reserved.
//

import Foundation
import UIKit
class DetailsViewController: UIViewController {
    
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var lightLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    @IBOutlet weak var majorLbl: UILabel!
    @IBOutlet weak var minorLbl: UILabel!

    @IBOutlet weak var txLbl: UILabel!
    @IBOutlet weak var rangeLbl: UILabel!
    @IBOutlet weak var accelerometerLbl: UILabel!
    
    @IBOutlet weak var hardwareLbl: UILabel!
    @IBOutlet weak var firmwareLbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    
    @IBOutlet weak var advIntervalLbl: UILabel!
    @IBOutlet weak var rssiLbl: UILabel!
    
    var beacon: SBKBeacon!
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SBKBeaconManager.sharedInstance().delegate = self
        
        self.refreshData()
        
        
    }
    

    /*override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(gotBeacon(_:)), name: "beaconNotification", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "beaconNotification", object: nil)
    }
    
    
    //MARK: NSNotificationCenter Observer Selector Method
    func gotBeacon(sender: NSNotification) {
        let beacon = sender.object as! SBKBeacon

        refreshData()
    }*/
    
    
    //MARK: Helper Method
    func refreshData() {
        //for temprature
        if let temp = beacon!.temperature {
            tempLbl.text = "\(String(temp)) °C"
        } else {
            tempLbl.text = "NA"
        }
        
        //for brightness
        if let lux = beacon!.light {
            lightLbl.text = "\(String(lux)) lux"
        } else {
            lightLbl.text = "NA"
        }
        
        //for distance
        distanceLbl.text = String(format: "%.2f", String(beacon!.accuracy)) + " m"
        
        //for Major and Minor Values
        if let x = beacon.beaconID {
            majorLbl.text = String(x.major.integerValue)
            minorLbl.text = String(x.minor.integerValue)
        } else {
            majorLbl.text = "N/A"
            minorLbl.text = "N/A"
        }
        
        //for text
        txLbl.text = SBKUnitConvertHelper.transmitPowerToString(beacon as SBKBeacon)
        
        //for proximity
        let cellText: String!
        
        let proximity = beacon!.proximity
        switch proximity {
        case .Unknown:
            cellText = "Unknown"
            break
            
        case .Far:
            cellText = "Far"
            break
            
        case .Near:
            cellText = "Near"
            break
            
        case .Immediate:
            cellText = "Very Close"
            break
        }
        
        rangeLbl.text = String(cellText)
        
        //for Accelerometer
        if let movement = beacon!.moving {
            if movement == 0 {
                accelerometerLbl.text = "Stable"
            } else {
                accelerometerLbl.text = "Moving"
            }
            
        } else {
            accelerometerLbl.text = "NA"
        }
        
        hardwareLbl.text = beacon.hardwareModelName
        firmwareLbl.text = beacon.firmwareVersion
        modelLbl.text = beacon.hardwareModelName
        
        advIntervalLbl.text = String(beacon.secureBroadcastInterval.rawValue)
        rssiLbl.text = String(Int(beacon.rssi))
        
        beacon.flashLightWithCommand(1, repeat: 5, completion: nil)
    }
    
    
    //MARK: IBAction Method
    @IBAction func dismissBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension DetailsViewController: SBKBeaconManagerDelegate {
    func beaconManager(beaconManager: SBKBeaconManager!, scanDidFinishWithBeacons beacons: [AnyObject]!) {
        self.refreshData()
    }
}

