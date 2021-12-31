//
//  ViewController.swift
//  PillBoxView
//
//  Created by Jacob Trentini on 12/30/21.
//

import UIKit

class ViewController: UIViewController {
    let pill = PillBoxViewManager()
    
    @IBOutlet weak var taskOutcomeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var showPillboxViewButton:      UIButton!
    @IBAction func showPillboxViewAction(_ sender: UIButton) {
        pill.show(title: "Refreshing Data", vcView: self.view)
        
        showPillboxViewButton      .isEnabled = false
        finishedTaskButton         .isEnabled = true
    }
    
    
    @IBOutlet weak var finishedTaskButton:      UIButton!
    @IBAction func finishedTaskAction(_ sender: UIButton) {
        pill.didFinishTask = taskOutcomeSegmentedControl.selectedSegmentIndex == 0
        
        showPillboxViewButton      .isEnabled = true
        finishedTaskButton         .isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPillboxViewButton      .isEnabled = true
        finishedTaskButton         .isEnabled = false
    }
}
