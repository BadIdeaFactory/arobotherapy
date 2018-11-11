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

    @IBOutlet weak var okButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.layer.cornerRadius = 4

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var interviewProtocolViewController = segue.destination as? InterviewProtocol {
            interviewProtocolViewController.interviewModelController = interviewModelController
        }
    }
    
}
