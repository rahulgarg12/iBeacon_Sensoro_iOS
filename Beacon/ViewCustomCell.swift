//
//  ViewCustomCell.swift
//  Beacon
//
//  Created by Rahul Garg on 20/02/16.
//  Copyright © 2016 Rahul Garg. All rights reserved.
//

import Foundation
import UIKit

class ViewCustomCell: UITableViewCell {
    @IBOutlet weak var rssiLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var lightLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var txLbl: UILabel!
    @IBOutlet weak var rangeImageView: UIImageView!
}