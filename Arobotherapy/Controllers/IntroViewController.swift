//
//  ViewController.swift
//  Arobotherapy
//
//  Created by Dan Schultz on 10/9/18.
//  Copyright © 2018 Bad Idea Factory. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, InterviewProtocol {

    // MARK: Properties
    var interviewModelController:InterviewModelController = InterviewModelController()
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.layer.cornerRadius = 4
        interviewModelController.generateScript()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var interviewProtocolViewController = segue.destination as? InterviewProtocol {
            interviewProtocolViewController.interviewModelController = interviewModelController
        }
    }
}

