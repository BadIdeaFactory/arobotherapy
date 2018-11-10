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
    private var questionIndex = 0
    private var version = 0
    private var currentFilename = ""
    
    var qualityTime = 0
    var recordedQuestions = [[String]]()
    var recordedPassages = [String]()
    var longestAnswers = [Int]()
    
    func preparePassageRecording() {
        let timestamp = Int(Date().timeIntervalSince1970)
        currentFilename = participantId + "_" + String(timestamp) + "_passage_" + String(recordedPassages.count)
        setupRecorder()
    }
    func prepareQuestionRecording(index: Int) {
        logTime(time: Int(audioRecorder.currentTime), index: index)
        
        let timestamp = Int(Date().timeIntervalSince1970)
        questionIndex = index
        currentFilename = participantId + "_" + String(timestamp) + "_question" + String(questionIndex) + "_" + String(recordedPassages.count)
        setupRecorder()
    }
    
    private func logTime(time: Int, index: Int) {
        if(!longestAnswers.indices.contains(questionIndex)) {
            longestAnswers.insert(0, at: questionIndex)
        }
        longestAnswers[questionIndex] = max(time, longestAnswers[questionIndex])
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
            catch {}
        }
    }
    
    func startRecording() {
        audioRecorder.record()
    }

    func stopRecording() {
        audioRecorder.stop()
    }
}
