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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Now load up the report \(reportToView)")
        teamNumber.text = reportToView.team?.teamNumber
        event.text = reportToView.event
        matchNumber.text = reportToView.matchNumber
        scoutName.text = reportToView.scout?.scoutName
        
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
