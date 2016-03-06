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
    @IBOutlet weak var chevalDeFriseDetails: UILabel!
    @IBOutlet weak var moatDetails: UILabel!
    @IBOutlet weak var sallyPortDetails: UILabel!
    @IBOutlet weak var drawbridgeDetails: UILabel!
    @IBOutlet weak var rampartsDetails: UILabel!
    @IBOutlet weak var rockWallDetails: UILabel!
    @IBOutlet weak var roughTerrainDetails: UILabel!
    @IBOutlet weak var lowBarDetails: UILabel!
    

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
        
        portcullisDetails.text = createDefenseDetailsString(reportToView.facedPortcullis!, speed: reportToView.speedPortcullis!.integerValue, crosses: reportToView.numCrossesPortcullis!)
        
        chevalDeFriseDetails.text = createDefenseDetailsString(reportToView.facedCheval!, speed: reportToView.speedChevalDeFrise!.integerValue, crosses: reportToView.numCrossesCheval!)
        
        moatDetails.text = createDefenseDetailsString(reportToView.facedMoat!, speed: reportToView.speedMoat!.integerValue, crosses: reportToView.numCrossesMoat!)
        
        sallyPortDetails.text = createDefenseDetailsString(reportToView.facedSallyPort!, speed: reportToView.speedSallyPort!.integerValue, crosses: reportToView.numCrossesSallyPort!)
        
        drawbridgeDetails.text = createDefenseDetailsString(reportToView.facedDrawbridge!, speed: reportToView.speedDrawbridge!.integerValue, crosses: reportToView.numCrossesDrawbridge!)
        
        rampartsDetails.text = createDefenseDetailsString(reportToView.facedRamparts!, speed: reportToView.speedRamparts!.integerValue, crosses: reportToView.numCrossesRamparts!)
        
        rockWallDetails.text = createDefenseDetailsString(reportToView.facedRockWall!, speed: reportToView.speedRockWall!.integerValue, crosses: reportToView.numCrossesRockWall!)
        
        roughTerrainDetails.text = createDefenseDetailsString(reportToView.facedRoughTerrain!, speed: reportToView.speedRoughTerrain!.integerValue, crosses: reportToView.numCrossesRoughTerrain!)
        
        lowBarDetails.text = createDefenseDetailsString(reportToView.facedLowBar!, speed: reportToView.speedLowBar!.integerValue, crosses: reportToView.numCrossesLowBar!)
        
        
        self.title = "\(reportToView.event!) Match \(reportToView.matchNumber!) (\(reportToView.scout!.scoutName!))"
    }
    
    func createDefenseDetailsString(faced: NSNumber, speed: Int, crosses: NSNumber) -> String {
        var details: String = ""
        
        if (faced == 1) {
            details += " Faced,  "
            switch (speed) {
            case 0: details += "Slow "
            case 1: details += "Medium "
            case 2: details += "Fast "
            default: break
            }
        } else {
            
            details += " Not Faced"
        }
        
        details += " \(crosses) crosses"
        
        return details
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
