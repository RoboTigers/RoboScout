//
//  ViewExistingReportViewController.swift
//  RoboScout
//
//  Created by Sharon Kass on 3/6/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//

import UIKit

class ViewExistingReportViewController: UIViewController {
    
    var reportToView : Report!
    
    @IBOutlet weak var teamNumber: UILabel!
    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var matchNumber: UILabel!
    @IBOutlet weak var scoutName: UILabel!
    @IBOutlet weak var autonomous: UILabel!
    @IBOutlet weak var autonomousDetails: UILabel!
    @IBOutlet weak var portcullisDetails: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Now load up the report \(reportToView)")
        teamNumber.text = reportToView.team?.teamNumber
        event.text = reportToView.event
        matchNumber.text = reportToView.matchNumber
        scoutName.text = reportToView.scout?.scoutName
        
        var autonomousDetailStr: String = ""
        if (reportToView.hasAutonomous == 1) {
            autonomous.text = "Yes"
            if (reportToView.autoReachedDefense == 1) {
                autonomousDetailStr += " Reached"
            }
            if (reportToView.autoCrossedDefense == 1) {
                autonomousDetailStr += " Crossed"
            }
            if (reportToView.autoScoredLow == 1) {
                autonomousDetailStr += " ScoredLow"
            }
            if (reportToView.autoScoredHigh == 1) {
                autonomousDetailStr += " ScoredHigh"
            }
        } else {
            autonomous.text = "No"
        }
        autonomousDetails.text = autonomousDetailStr
        
        var defenseDetailStr: String = ""
        if (reportToView.facedPortcullis == 1) {
            defenseDetailStr += " Faced,  "
            let speed = reportToView.speedPortcullis!.integerValue
            switch (speed) {
            case 0: defenseDetailStr += "Slow "
            case 1: defenseDetailStr += "Medium "
            case 2: defenseDetailStr += "Fast "
            default: break
            }
        } else {
           
            defenseDetailStr += " Not Faced"
        }
        
        defenseDetailStr += " \(reportToView.numCrossesPortcullis!) crosses"
        portcullisDetails.text = defenseDetailStr
        
        defenseDetailStr = ""
        
        
        self.title = "\(reportToView.event!) Match \(reportToView.matchNumber!) (\(reportToView.scout!.scoutName!))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
