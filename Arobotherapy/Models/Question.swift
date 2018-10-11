import Foundation
class Question {
    var id: String
    var text: String
    var audioUrl:String
    
    init(id: String, text: String, audioUrl:String ) {
        self.id = id
        self.text = text
        self.audioUrl = audioUrl
    }
}
