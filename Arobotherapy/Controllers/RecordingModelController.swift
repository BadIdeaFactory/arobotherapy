//
//  RecordingModelController.swift
//  Arobotherapy
//
//  Created by Dan Schultz on 10/24/18.
//  Copyright © 2018 Bad Idea Factory. All rights reserved.
//

import Foundation
import AVFoundation

class RecordingModelController: NSObject, AVAudioRecorderDelegate {
    
    private var audioRecorder: AVAudioRecorder! = nil
    private var meterTimer: Timer! = nil
    private var currentTimeInterval: TimeInterval = 0.0
    private var recordPermission = false
    
    private var participantId: String = ""
    private var currentVersion: String = "0"
    private var currentFilename: String = ""
    
    private var interviewModel: InterviewModelController?
    
    private var questionIndex: Int = 0
    var qualityTime = 0
    var questionVersions = [Int]()
    var passageVersion = 0
    var longestAnswers = [Int]()
    
    func resetInterview() {
        questionIndex = 0
        qualityTime = 0
        questionVersions = [Int]()
        passageVersion = 0
        longestAnswers = [Int]()
    }
    
    func setInterviewModelController(interviewModel: InterviewModelController) {
        self.interviewModel = interviewModel
    }
    
    func preparePassageRecording() {
        let timestamp: String = String(Int(Date().timeIntervalSince1970))
        currentVersion = String(incrementPassageVersion())
        let passageId: String = interviewModel!.chosenPassage!.id
        currentFilename = participantId + "_passage-v" + currentVersion + "_" + passageId + "_" + timestamp
        setupRecorder()
    }
    
    func prepareQuestionRecording(index: Int) {
        logTime(time: Int(audioRecorder.currentTime), index: self.questionIndex)
        self.questionIndex = index

        let timestamp: String = String(Int(Date().timeIntervalSince1970))
        currentVersion = String(incrementQuestionVersion(index: index))
        let questionId: String = interviewModel!.chosenQuestions[index].id
        let questionIndex: String = String(index)
        
        currentFilename = participantId + "_question-" + questionIndex + "-v" + currentVersion + "_" + questionId + "_" + timestamp
        setupRecorder()
    }
    
    private func incrementQuestionVersion(index: Int) -> Int{
        if(!questionVersions.indices.contains(index)) {
            questionVersions.insert(0, at: index)
        }
        questionVersions[index] += 1
        return questionVersions[index]
    }
    
    private func incrementPassageVersion() -> Int{
        passageVersion += 1
        return passageVersion
    }
    
    private func logTime(time: Int, index: Int) {
        print(time)
        if(!longestAnswers.indices.contains(index)) {
            longestAnswers.insert(0, at: index)
        }
        longestAnswers[index] = max(time, longestAnswers[index])
        recalculateQualityTime()
    }
    
    private func recalculateQualityTime() {
        qualityTime = longestAnswers.reduce(0, +)
    }

    func checkRecordPermission() {
        if(!recordPermission) {
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.recordPermission = true
                } else {
                    self.recordPermission = false
                }
            })
        }
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func fileUrl() -> URL {
        let filename = "\(self.currentFilename).m4a"
        let filePath = documentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func changeFile(withFileName filename: String) {
        self.currentFilename = filename
        
        if audioRecorder != nil {
            setupRecorder()
        }
    }
    
    func newParticipant(participantId: String) {
        self.participantId = participantId
    }
    
    private func setupRecorder() {
        checkRecordPermission()
        if recordPermission {
            do {
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                audioRecorder = try AVAudioRecorder(url: fileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error as NSError {
                print(error.description)
            }
            
        }
    }
    
    func ensureRecordingSession() {
        
    }
    
    func startRecording() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(
                AVAudioSession.Category.playAndRecord,
                mode: AVAudioSession.Mode.default)
        }
        catch let error as NSError {
            print(error.description)
        }
        audioRecorder.record()
        print(audioRecorder.isRecording)
    }

    func stopRecording() {
        audioRecorder.stop()
    }
}
