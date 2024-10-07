//
//  ViewController 2.swift
//  Wasap
//
//  Created by 김상준 on 10/7/24.
//


import UIKit

class ViewController: UIViewController {
    
    private let wifiConnectView = WifiConnectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view  = wifiConnectView
    }
}
