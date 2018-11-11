//
//  ParticipantIdViewController.swift
//  Arobotherapy
//
//  Created by Dan Schultz on 11/6/18.
//  Copyright © 2018 Bad Idea Factory. All rights reserved.
//

import UIKit

class ParticipantIdViewController: UIViewController, InterviewProtocol {

    // MARK: Properties
    var interviewModelController:InterviewModelController = InterviewModelController()
    @IBOutlet weak var participantIdField: UITextField!
    
    @IBOutlet weak var setIdButton: UIButton!
    
    // Mark: - Actions
    @IBAction func textPrimaryActionTriggered(_ sender: Any) {
        triggerNextSegue()
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        triggerNextSegue()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIdButton.layer.cornerRadius = 4

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var interviewProtocolViewController = segue.destination as? InterviewProtocol {
            interviewProtocolViewController.interviewModelController = interviewModelController
        }
    }

    func triggerNextSegue() {
        if(participantIdField.text != "") {
            interviewModelController.recordingModelController.newParticipant(participantId: participantIdField.text!)
            performSegue(withIdentifier: "participantIdViewNextSegue", sender: participantIdField)
        }
    }

}
