//
//  InterviewViewController.swift
//  Arobotherapy
//
//  Created by Dan Schultz on 10/10/18.
//  Copyright © 2018 Bad Idea Factory. All rights reserved.
//

import UIKit
import SwiftySound

class InterviewViewController: UIViewController, InterviewProtocol {

    // MARK: Properties
    var interviewModelController:InterviewModelController = InterviewModelController()
    var currentQuestionIndex = 0
    @IBOutlet weak var interviewBackButton: UIButton!
    @IBOutlet weak var interviewNextButton: UIButton!
    @IBOutlet weak var interviewTextLabel: UILabel!
    
    var sound: Sound?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentQuestionIndex = -1
        renderNextQuestion()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        interviewModelController.recordingModelController.stopRecording()
    }
    
    // MARK: - Actions
    @IBAction func nextButtonPressed(_ sender: Any) {
        if(isInterviewFinished()) {
            triggerNextSegue()
        } else {
            renderNextQuestion()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        renderPreviousQuestion()
    }
    
    @IBAction func repeatButtonPressed(_ sender: Any) {
        repeatCurrentQuestion()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var interviewProtocolViewController = segue.destination as? InterviewProtocol {
            interviewProtocolViewController.interviewModelController = interviewModelController
        }
    }
    
    func renderNextQuestion() {
        currentQuestionIndex += 1
        if(currentQuestionIndex >= interviewModelController.chosenQuestions.count) {
            return triggerNextSegue()
        }
        let nextQuestion = interviewModelController.chosenQuestions[currentQuestionIndex]
        renderQuestion(question: nextQuestion)

    }
    
    func renderPreviousQuestion() {
        currentQuestionIndex -= 1
        if(currentQuestionIndex < 0) {
            return triggerBackSegue()
        }
        let nextQuestion = interviewModelController.chosenQuestions[currentQuestionIndex]
        renderQuestion(question: nextQuestion)
    }

    func repeatCurrentQuestion() {
        let currentQuestion = interviewModelController.chosenQuestions[currentQuestionIndex]
        playQuestionAudio(question: currentQuestion)
    }

    func playQuestionAudio(question: Question) {
        if let audioUrl = URL(string: question.audioUrl) {
            sound = Sound(url: audioUrl)
            sound?.play(completion: audioFinished)
        }
    }
    
    func audioFinished(didItWork: Bool) {
        interviewModelController.recordingModelController.startRecording()
    }
    
    func renderQuestion(question: Question) {
        interviewTextLabel.text = question.text
        interviewModelController.recordingModelController.prepareQuestionRecording(index: currentQuestionIndex)
        
        // TODO: This 300 second timer should be configurable
        if(interviewModelController.recordingModelController.qualityTime < 300) {
            playQuestionAudio(question: question)
        } else {
            triggerNextSegue()
        }
    }
    
    func triggerNextSegue() {
        performSegue(withIdentifier: "interviewFinishedSegue", sender: interviewNextButton)
    }
    
    func triggerBackSegue() {
        performSegue(withIdentifier: "interviewBackSegue", sender: interviewNextButton)
    }
    
    func isInterviewFinished() -> Bool {
        return false
    }

}
