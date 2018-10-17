//
//  ViewController.swift
//  Arobotherapy
//
//  Created by Dan Schultz on 10/9/18.
//  Copyright © 2018 Bad Idea Factory. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    // MARK: Properties
    var interviewModelController:InterviewModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interviewModelController.generateScript()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: Actions
}

