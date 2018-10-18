//
//  PassageInstructionViewController.swift
//  Arobotherapy
//
//  Created by Dan Schultz on 10/9/18.
//  Copyright © 2018 Bad Idea Factory. All rights reserved.
//

import UIKit

class PassageInstructionViewController: UIViewController, InterviewProtocol {
    
    // MARK: Properties
    var interviewModelController:InterviewModelController = InterviewModelController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var interviewProtocolViewController = segue.destination as? InterviewProtocol {
            interviewProtocolViewController.interviewModelController = interviewModelController
        }
    }
    
}
