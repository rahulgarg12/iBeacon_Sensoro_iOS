//
//  CollectionViewController.swift
//  Beacon
//
//  Created by Rahul Garg on 10/04/16.
//  Copyright © 2016 Rahul Garg. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UIViewController {
    //CollectionView
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    let collectionViewIdentifier = "collectionViewCell"
    let detailedViewControllerIdentifier = "detailsViewController"
    
    var beacon: SBKBeacon? = SBKBeacon()
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(gotBeacon(_:)), name: "beaconNotification", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {        
        SBKBeaconManager.sharedInstance().delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "beaconNotification", object: nil)
    }
    
    
    //MARK: NSNotificationCenter Observer Selector Method
    func gotBeacon(sender: NSNotification) {
        beacon = sender.object as? SBKBeacon
        
        collectionView.reloadData()
    }
    
    
    //MARK: IBAction Methods
    
    @IBAction func showDetailedInfoVC(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewControllerWithIdentifier(detailedViewControllerIdentifier) as! DetailsViewController
        
        detailsViewController.beacon = beacon
        
        self.presentViewController(detailsViewController, animated: true, completion: nil)
    }

    
    @IBAction func dismissView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}




extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionViewIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        //for temperature
        if indexPath.row == 0 {
            cell.headingLbl.text = "Temperature"
            
            if let temp = beacon!.temperature {
                cell.valueLbl.text = "\(String(temp)) °C"
            } else {
                cell.valueLbl.text = "NA"
            }
            
        }
        
        //for light intensity
        if indexPath.row == 1 {
            cell.headingLbl.text = "Light"
            
            if let lux = beacon!.light {
                cell.valueLbl.text = "\(String(lux)) lux"
            } else {
                cell.valueLbl.text = "NA"
            }
        }
        
        if indexPath.row == 2 {
            cell.headingLbl.text = "Accelerometer"

            if let movement = beacon!.moving {
                if movement == 0 {
                    cell.valueLbl.text = "Stable"
                } else {
                    cell.valueLbl.text = "Moving"
                }
                
            } else {
                cell.valueLbl.text = "NA"
            }
        }
        
        if indexPath.row == 3 {
            cell.headingLbl.text = "Distance"
            cell.valueLbl.text = String(format: "%.4f", String(beacon!.accuracy)) + " m"
        }
        
        if indexPath.row == 4 {
            cell.headingLbl.text = "Proximity"
            
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
            
            cell.valueLbl.text = "Status: \(cellText)"
        }
        
        if indexPath.row == 5 {
            cell.headingLbl.text = "Range"
            if beacon!.inRange == false {
                cell.valueLbl.text = "Status: Not in Range"
            } else {
                cell.valueLbl.text = "Status: In Range"
            }
            
        }
        
        if indexPath.row == 6 {
            cell.headingLbl.text = "Battery"
            
            if let batteryLevel = beacon!.batteryLevel {
                let batteryPercentage = Float(batteryLevel) * 100
                cell.valueLbl.text = "\(String(Int(batteryPercentage))) %"
            } else {
                cell.valueLbl.text = "NA"
            }
        }
        
        if indexPath.row == 7 {
            cell.headingLbl.text = "RSSi"
            
            cell.valueLbl.text = String(Int(beacon!.rssi))
        }
        
        return cell
    }
}

extension CollectionViewController: SBKBeaconManagerDelegate {
    func beaconManager(beaconManager: SBKBeaconManager!, scanDidFinishWithBeacons beacons: [AnyObject]!) {
        self.collectionView.reloadItemsAtIndexPaths(self.collectionView.indexPathsForVisibleItems())
    }
}
