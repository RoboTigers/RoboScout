//
//  AddNewTeamViewController.swift
//  RoboScout
//
//  Created by Sharon Kass on 2/5/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//

import UIKit

class AddNewTeamViewController: UIViewController {

    @IBOutlet weak var teamNumber: UITextField!
    @IBOutlet weak var teamName: UITextField!

    
    @IBAction func doneAddingNewTeam(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Team"
        // Dismiss keyboard when user taps outside of keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard")))
    }
    
    func dismissKeyboard() {
        teamName.resignFirstResponder()
        teamNumber.resignFirstResponder()
     
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
