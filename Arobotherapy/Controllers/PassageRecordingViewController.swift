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
    var currentPassageIndex = 0
    @IBOutlet weak var passageTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius = 4
        continueButton.layer.cornerRadius = 4
        currentPassageIndex = -1
        renderNextPassage()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passageTextView.setContentOffset(.zero, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        interviewModelController.recordingModelController.stopRecording()
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        renderNextPassage()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        renderPreviousPassage()
    }
    
    func renderNextPassage() {
        currentPassageIndex += 1
        
        if(currentPassageIndex >= interviewModelController.chosenPassages.count) {
            return triggerNextSegue()
        }
        let nextPassage = interviewModelController.chosenPassages[currentPassageIndex]
        renderPassage(passage: nextPassage)
    }
    
    func renderPreviousPassage() {
        currentPassageIndex -= 1
        
        if(currentPassageIndex < 0) {
            return triggerBackSegue()
        }
        
        let nextPassage = interviewModelController.chosenPassages[currentPassageIndex]
        renderPassage(passage: nextPassage)
    }
    
    func renderPassage(passage: Passage) {
        interviewModelController.recordingModelController.preparePassageRecording(index: currentPassageIndex)
        interviewModelController.recordingModelController.startRecording()
        passageTextView.text = passage.text
        passageTextView.setContentOffset(.zero, animated: true)
    }
    
    func triggerNextSegue() {
        performSegue(withIdentifier: "passagesFinishedSegue", sender: continueButton)
    }
    
    func triggerBackSegue() {
        performSegue(withIdentifier: "passageBackSegue", sender: backButton)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var interviewProtocolViewController = segue.destination as? InterviewProtocol {
            interviewProtocolViewController.interviewModelController = interviewModelController
        }
    }

}
