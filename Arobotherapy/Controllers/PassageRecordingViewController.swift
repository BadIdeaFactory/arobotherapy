//
//  PassageRecordingViewController.swift
//  Arobotherapy
//
//  Created by Dan Schultz on 10/10/18.
//  Copyright © 2018 Bad Idea Factory. All rights reserved.
//

import UIKit

class PassageRecordingViewController: UIViewController, InterviewProtocol {
    var interviewModelController:InterviewModelController = InterviewModelController()
    
    // MARK: Properties
    @IBOutlet weak var passageTextView: UITextView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius = 4
        continueButton.layer.cornerRadius = 4
        passageTextView.text = interviewModelController.chosenPassage!.text
        interviewModelController.recordingModelController.preparePassageRecording()
        interviewModelController.recordingModelController.startRecording()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        interviewModelController.recordingModelController.stopRecording()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var interviewProtocolViewController = segue.destination as? InterviewProtocol {
            interviewProtocolViewController.interviewModelController = interviewModelController
        }
    }

}
