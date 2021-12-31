//
//  ViewController.swift
//  PillBoxView
//
//  Created by Jacob Trentini on 12/30/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pill = PillBoxViewManager()
        
        pill.show(title: "Refreshing Data", vcView: self.view)
        
        // some time later...
        pill.didFinishTask = true
    }
}
