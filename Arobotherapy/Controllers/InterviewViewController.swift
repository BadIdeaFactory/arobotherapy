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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentQuestionIndex = -1
        renderNextQuestion()
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
    
    func playQuestionAudio(question: Question) {
        Sound.stopAll()
        if let audioUrl = URL(string: question.audioUrl) {
            Sound.play(url: audioUrl)
        }
    }
    
    func renderQuestion(question: Question) {
        interviewTextLabel.text = question.text
        playQuestionAudio(question: question)
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
