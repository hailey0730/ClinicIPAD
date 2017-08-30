//
//  FormViewController.swift
//  ClinicIPAD
//
//  Created by AsiaMac on 24/8/2017.
//  Copyright © 2017年 AsiaMac. All rights reserved.
//

import Foundation
import UIKit
//import Firebase


class FormViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 90.0, target: self, selector: #selector(self.timeToMoveOn), userInfo: nil, repeats: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //========================================
    
    @objc private func timeToMoveOn() {
        self.performSegue(withIdentifier: "formBackHome", sender: self)
        
    }
}
