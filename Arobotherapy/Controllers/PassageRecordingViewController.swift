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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(interviewModelController.chosenPassage)
        print(interviewModelController.chosenPassage!.text)
        passageTextView.text = interviewModelController.chosenPassage!.text
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var interviewProtocolViewController = segue.destination as? InterviewProtocol {
            interviewProtocolViewController.interviewModelController = interviewModelController
        }
    }

}
