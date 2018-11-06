//
//  ModelController.swift
//  Arobotherapy
//
//  Created by Dan Schultz on 10/17/18.
//  Copyright © 2018 Bad Idea Factory. All rights reserved.
//

import UIKit

class InterviewModelController {
    var participantId: String = ""
    var passages: [Passage] = []
    var questionBlocks: [[Question]] = []
    
    var chosenPassage:Passage?
    var chosenQuestions: [Question] = []
    
    var recordingModelController = RecordingModelController()
    
    func generateScript() {
        loadData()
        
        // Select exactly one passage
        if(passages.count > 0) {
            self.chosenPassage = passages.randomElement()!
        }
        
        // Iterate through the questions to generate the script
        var questionPool = questionBlocks
        var mayHaveMore = true
        while(mayHaveMore) {
            mayHaveMore = false;
            for (blockIndex, questionBlock) in questionPool.enumerated() {
                if(questionBlock.isEmpty) {
                    continue
                }
                let nextQuestion = questionPool[blockIndex].randomElement()!
                chosenQuestions.append(nextQuestion)
                questionPool[blockIndex] = questionPool[blockIndex]
                    .filter() { $0.id != nextQuestion.id }
                mayHaveMore = true
            }
        }
    }
    
    func loadData() {
        loadPassages()
        loadQuestions()
    }
    
    func loadPassages() {
        if(passages.count != 0) {
            return
        }

        let path = Bundle.main.resourcePath! + "/Library/Passages"
        let items = getItemsInPath(path: path)
        for item in items {
            if(item.suffix(4) != ".txt") {
                continue
            }
            let filePath = Bundle.main.resourcePath! + "/Library/Passages/" + item
            let contents = loadContentFromFile(filePath: filePath)
            let passage = Passage(id: item, text: contents)
            passages.append(passage)
        }
    }
    
    func loadQuestions() {
        if(!questionBlocks.isEmpty) {
            return
        }
        // We need to initialize the zero index since it is a special case
        questionBlocks.append([])
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! + "/Library/Questions/Text"
        let items = getItemsInPath(path: path)
        var blockCount = 0
        
        for item in items {
            let itemPath = Bundle.main.resourcePath! + "/Library/Questions/Text/" + item
            var isDir : ObjCBool = false
            if(fm.fileExists(atPath: itemPath, isDirectory: &isDir)) {
                if(isDir.boolValue) {
                    let blockItems = getItemsInPath(path: itemPath)
                    blockCount += 1
                    addItemsToQuestionBlock(index: blockCount, items: blockItems, prefix: item)
                } else {
                    addItemToQuestionBlock(index: 0, item: item)
                }
            }
        }
    }
    
    func addItemsToQuestionBlock(index: Int, items: [String], prefix: String = "" ) {
        for item in items {
            addItemToQuestionBlock(index: index, item: item, prefix: prefix)
        }
    }
    
    func addItemToQuestionBlock(index: Int, item: String, prefix: String = "" ) {
        if(item.suffix(4) != ".txt") {
            return
        }
        let itemPath = Bundle.main.resourcePath! + "/Library/Questions/Text/"
            + (prefix.isEmpty ? "" : prefix + "/")
            + item
        let contents = loadContentFromFile(filePath: itemPath)
        let audioUrl = itemPath
            .replacingOccurrences(of: "Text", with: "Audio")
            .replacingOccurrences(of: ".txt", with: ".mp3")
        let question = Question(id: item, text: contents, audioUrl: audioUrl)
        
        if(!questionBlocks.indices.contains(index)) {
            questionBlocks.insert([Question](), at: index)
        }
        questionBlocks[index].append(question)
    }
    
    func loadContentFromFile(filePath: String) -> String {
        do {
            return try String(contentsOfFile: filePath)
        } catch {
            return ""
        }
    }
    
    func getItemsInPath(path: String) -> [String] {
        let fm = FileManager.default
        do {
            let items = try fm.contentsOfDirectory(atPath: path).sorted()
            return items
        } catch {
            return []
        }
    }
}
