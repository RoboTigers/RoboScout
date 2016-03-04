//
//  AddNewReportViewController.swift
//  RoboScout
//
//  Created by Sharon Kass on 2/20/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//

import UIKit
import CoreData

class AddNewReportViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var eventSegment: UISegmentedControl!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var matchNumber: UITextField!
    @IBOutlet weak var autonomous: UISegmentedControl!
    @IBOutlet weak var autoReachedDefense: UISwitch!
    @IBOutlet weak var autoCrossedDefense: UISwitch!
    @IBOutlet weak var autoScoredLow: UISwitch!
    @IBOutlet weak var autoScoredHigh: UISwitch!
    @IBOutlet weak var portcullisSpeed: UISegmentedControl!
    @IBOutlet weak var chevalSpeed: UISegmentedControl!
    @IBOutlet weak var moatSpeed: UISegmentedControl!
    @IBOutlet weak var sallyPortSpeed: UISegmentedControl!
    @IBOutlet weak var drawbridgeSpeed: UISegmentedControl!
    @IBOutlet weak var rampartsSpeed: UISegmentedControl!
    @IBOutlet weak var rockWallSpeed: UISegmentedControl!
    @IBOutlet weak var roughTerrainSpeed: UISegmentedControl!
    @IBOutlet weak var lowBarSpeed: UISegmentedControl!
    
    
    @IBOutlet weak var portcullisFaced: UISwitch!
    @IBOutlet weak var chevalFaced: UISwitch!
    @IBOutlet weak var moatFaced: UISwitch!
    @IBOutlet weak var portcullisNumCrossesLabel: UILabel!
    @IBOutlet weak var chevalNumCrossesLabel: UILabel!
    @IBOutlet weak var moatNumCrossesLabel: UILabel!
    @IBOutlet weak var portcullisStepper: UIStepper!
    @IBOutlet weak var chevalStepper: UIStepper!
    @IBOutlet weak var moatStepper: UIStepper!
    
    
    @IBOutlet weak var comments: UITextView!
    @IBAction func doneAddingNewReport(sender: AnyObject) {
    }
    @IBAction func sliderValueChanged(sender: UISlider) {
        sliderLabel.text = NSString(format: "%1.1f", sender.value) as String
    }
    
    var scouts = [Scout]()
    var pickerData = [String]()
    var selectedScout : Scout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.picker.delegate = self
        self.picker.dataSource = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard")))
        
        refreshScouts()
        populateScoutNames()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        matchNumber.resignFirstResponder()
        comments.resignFirstResponder()
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        selectedScout = scouts[row]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func refreshScouts() {
        
        // Empty out teams and replace all
        // TODO: Better approach might be to add to array only if not already contained in array
        scouts.removeAll()
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // Get current year
        let yearStr = String(getCurrentYear())
        
        // Get scouts from data store
        let request = NSFetchRequest(entityName: "Scout")
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format: "year = %@", yearStr)
        var results:NSArray = NSArray()
        do {
            results = try context.executeFetchRequest(request)
        } catch _ {
            print("Error fetching scouts")
        }
        
        if results.count > 0 {
            for scout in results {
                let s = scout as! Scout
                scouts.append(s)
                if (scouts.count == 1 && selectedScout == nil) {
                    // Set selectedScout to the first scout found since that
                    // will be the default in the picker if user does not spin
                    // the picker dial. The picker control only activates if
                    // user selects something other than the initial display
                    // in the picker
                    selectedScout = s
                }
            }
            //view.reloadData()
        } else {
            print("No scouts found")
        }
    }
    
    private func getCurrentYear() -> Int {
        // Get current year
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year],  fromDate: date)
        let currentYear = components.year
        return currentYear
    }
    
    private func populateScoutNames() {
        for s: Scout in scouts {
            pickerData.append(s.scoutName!)
        }
    }

}
