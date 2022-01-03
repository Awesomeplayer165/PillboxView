//
//  ViewController.swift
//  PillboxView
//
//  Created by Awesomeplayer165 on 01/02/2022.
//  Copyright (c) 2022 Awesomeplayer165. All rights reserved.
//

import UIKit
import PillboxView

class ViewController: UIViewController {
    let pill = PillboxView()
    
    @IBOutlet weak var taskOutcomeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var showPillboxViewButton:      UIButton!
    @IBAction func showPillboxViewAction(_ sender: UIButton) {
        pill.showTask(message: "Refreshing Data", vcView: self.view)
        
        showPillboxViewButton.isEnabled = false
        finishedTaskButton   .isEnabled = true
        
        let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle")!.withTintColor(.systemRed))
        imageView.frame = CGRect(x: 50, y: 100, width: 25, height: 25)
        view.addSubview(imageView)
    }
    
    
    @IBOutlet weak var finishedTaskButton:      UIButton!
    @IBAction func finishedTaskAction(_ sender: UIButton) {
        self.showPillboxViewButton.isEnabled = true
        self.finishedTaskButton   .isEnabled = false
        
        pill.completedTask(state: taskOutcomeSegmentedControl.selectedSegmentIndex == 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPillboxViewButton.isEnabled = true
        finishedTaskButton   .isEnabled = false
    }
}
