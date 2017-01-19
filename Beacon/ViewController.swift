//
//  ViewController.swift
//  Beacon
//
//  Created by Rahul Garg on 20/02/16.
//  Copyright © 2016 Rahul Garg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let custmCellIdentifier = "viewCustomCell"
    
    let collectionViewIdentifier = "CollectionView"
    
    var myBeacons: NSMutableArray?
    //var beacon: SBKBeacon?
    
    var ifMoving = false

    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myBeacons = NSMutableArray()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        SBKBeaconManager.sharedInstance().delegate = self
    }

    
    //MARK: IBAction Method Implementation
    @IBAction func refresh(sender: UIButton?) {
        self.myBeacons = NSMutableArray()
        let array =  SBKBeaconManager.sharedInstance().beaconsInRange() as NSArray
        
        for (_, beacon) in array.enumerate() {
            self.myBeacons!.addObject(beacon)
        }
        
        self.tableView.reloadData()
    }
    
    
    //MARK: UITableView Helper Method
    func postNotification(beacon: SBKBeacon) {
        NSNotificationCenter.defaultCenter().postNotificationName("beaconNotification", object: beacon)//, userInfo: beacon as AnyObject as? [NSObject : AnyObject] )
    }
    
    func showAlertView(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBeacons!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(custmCellIdentifier) as! ViewCustomCell
        
        cell.selectionStyle = .None
        
        let beacon = myBeacons![indexPath.row] as? SBKBeacon
        
        //for temperature
        cell.tempLbl.text = String(beacon!.temperature) + "°C"
        
        //for light intensity
        if let lux = beacon!.light {
            cell.lightLbl.text = String(lux) + " lux"
        } else {
            cell.lightLbl.text = "NA"
        }
        
        //for RSSI
        cell.rssiLbl.text = String(Int(beacon!.rssi))
        
        //for distance
        cell.distanceLbl.text = String(format: "%.3f", beacon!.accuracy) + " m"
        
        //for text label
        cell.txLbl.text = SBKUnitConvertHelper.transmitPowerToString(beacon)
        
        //for proximity image
        if((beacon!.inRange) != false) {
            if(beacon!.proximity != CLProximity.Unknown) {
                cell.rangeImageView.image = UIImage(named: "dot_green")
            } else {
                cell.rangeImageView.image = UIImage(named: "dot_yellow")
            }
        }
        else {
            cell.rangeImageView.image = UIImage(named: "dot_red")
        }
        
        if((beacon!.moving) != nil) {
            
        }
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let collectionViewController = storyboard.instantiateViewControllerWithIdentifier(collectionViewIdentifier) as! CollectionViewController
         
         //collectionViewController.beacon = myBeacons![indexPath.row] as? SBKBeacon
         
         self.presentViewController(collectionViewController,
                                    animated: true,
                                    completion: nil)
        
        let beacon = myBeacons![indexPath.row] as? SBKBeacon
        self.postNotification(beacon!)
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectZero)
        return footerView
    }
}

extension ViewController: SBKBeaconManagerDelegate {
    func beaconManager(beaconManager: SBKBeaconManager!, didRangeNewBeacon beacon: SBKBeacon!) {
        print("Enter new beacon")

        myBeacons?.addObject(beacon)
        
        let alertMessage = "A new beacon is found"
        showAlertView(alertMessage)
        
        self.tableView.beginUpdates()
        let indexPaths = NSIndexPath(forRow: myBeacons!.count - 1,
                                     inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPaths],
                                              withRowAnimation: .Fade)
        self.tableView.endUpdates()
    }
    
    func beaconManager(beaconManager: SBKBeaconManager!, beaconDidGone beacon: SBKBeacon!) {
        print("Beacon Left")
        
        myBeacons?.removeObject(beacon)
        
        let alertMessage = "Beacon is out of range"
        showAlertView(alertMessage)
        
        if (myBeacons!.count < self.tableView.numberOfRowsInSection(0)) {
            self.tableView.beginUpdates()
            let indexPaths = NSIndexPath(forRow: myBeacons!.count,
                                         inSection: 0)
            self.tableView.deleteRowsAtIndexPaths([indexPaths],
                                                  withRowAnimation:.Fade)
            self.tableView.endUpdates()
        }
    }
    
    func beaconManager(beaconManager: SBKBeaconManager!, scanDidFinishWithBeacons beacons: [AnyObject]!) {
        /*self.tableView.reloadRowsAtIndexPaths(self.tableView.indexPathsForVisibleRows!,
                                              withRowAnimation: UITableViewRowAnimation.None)*/
        self.tableView.reloadData()
    }
    
    func beaconManager(beaconManager: SBKBeaconManager!,
                       didDetermineState state: SBKRegionState,
                                         forRegion region: SBKBeaconID!) {
        let notification = UILocalNotification()
        
        switch (state) {
        case SBKRegionState.Enter:
                let message = "Enter new beacon with ID: \(region)"
                notification.alertBody = message as String
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                
            break
        
        case SBKRegionState.Leave:
                let message =  "Beacon left with ID: \(region)"
                notification.alertBody = message as String
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                
            break
        
        case SBKRegionState.Unknown:
            
            break
            
        }
    }
}

extension ViewController: SBKBeaconDelegate {
    func sensoroBeacon(beacon: SBKBeacon!, didUpdateAccelerometerCount accelerometerCount: NSNumber!) {
        
    }
    
    func sensoroBeacon(beacon: SBKBeacon!, didUpdateMovingState isMoving: NSNumber!) {
        print(isMoving)
        ifMoving = true
        
        tableView.reloadData()
    }
}
