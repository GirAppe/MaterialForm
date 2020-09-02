//
//  ViewController.swift
//  SampleTVApp
//
//  Created by Przemysław Wośko on 02/09/2020.
//  Copyright © 2020 MakeAWishFoundation. All rights reserved.
//

import UIKit
import MaterialForm

class ViewController: UIViewController {

    @IBOutlet weak var exampleField: MaterialUITextField!
    @IBOutlet weak var examplePasswordFiedl: MaterialUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        exampleField.style = MaterialUITextField.Style.rounded { it in
            it.backgroundColor = .green
            it.cornerRadius = 20
            it.defaultPlaceholderColor = .blue
        }
    }


}

