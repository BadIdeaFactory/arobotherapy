//
//  ModelController.swift
//  Arobotherapy
//
//  Created by Dan Schultz on 10/17/18.
//  Copyright © 2018 Bad Idea Factory. All rights reserved.
//

import UIKit

class InterviewModelController {
    var passages: [Passage] = []
    var questions: [Question] = []
    
    func generateScript() {
        loadData()
    }
    
    func loadData() {
        loadPassages()
        loadQuestions()
    }
    
    func loadPassages() {
        if(passages.count != 0) {
            return
        }

        let fm = FileManager.default
        let path = Bundle.main.resourcePath! + "/Library/Passages"
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                let filepath = Bundle.main.resourcePath! + "/Library/Passages/" + item
                let contents = try String(contentsOfFile: filepath)
                let passage = Passage(id: item, text: contents)
                passages.append(passage)
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
    
    func loadQuestions() {
        if(questions.count != 0) {
            return
        }

        let fm = FileManager.default
        let path = Bundle.main.resourcePath! + "/Library/Questions/Text"
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                let filepath = Bundle.main.resourcePath! + "/Library/Questions/Text/" + item
                let contents = try String(contentsOfFile: filepath)
                let audioUrl = Bundle.main.resourcePath! + "/Library/Questions/Audio/" + item.replacingOccurrences(of: ".txt", with: ".mp3")
                let question = Question(id: item, text: contents, audioUrl: audioUrl)
                questions.append(question)
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
}
