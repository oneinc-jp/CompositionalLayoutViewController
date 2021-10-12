//
//  ViewController.swift
//  CompositionalLayoutViewController
//
//  Created by Akira on 05/21/2021.
//  Copyright (c) 2021 Akira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func presentViewController(_ sender: Any) {
        navigationController?.pushViewController(SampleViewController(), animated: true)
    }
}
