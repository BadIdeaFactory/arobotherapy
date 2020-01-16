# Arobotherapy

This project is an iOS based automated interviewer developed as part of a study on depression.  The participant is asked a series of questions and their answers are recorded on the iOS device.

## Building the project
In order to compile this application you must populate the Library directory with the questions and passages.

The Library directory should be placed in `Arobotherapy/Library` and should contain a `Passages` and `Questions` directory.

### Passages Directory
The Passages directory must contain a series of `.txt` files (e.g. `passage_1.txt`) which will contain the passage to be rendered on screen in the passage section.

### Questions Directory
The Questions directory will contain two subdirectories: `Audio` and `Text`, which will in turn contain mirrored `block` directories (e.g. `block_01`, `block_02`).

Block directories in the Audio folder should contain `.mp3` files (e.g. `question_1.mp3`).

Block directories in the Text folder should contain `.txt` files (e.g. `question_1.txt`).

For every block directory in the Audio folder there should be one in the Text folder.  For every mp3 file in an Audio block there should be an identically named (aside from the extension) txt file in the Text block.

### Example Library
For example, this would be a correctly populated library:

```
- Library
| - Passages
| | - passage_1.txt
| - Audio
| | - block_01
| | | - question_1.mp3
| | - block_02
| | | - question_2.mp3
| | | - question_3.mp3
| - Text
| | - block_01
| | | - question_1.txt
| | - block_02
| | | - question_2.txt
| | | - question_3.txt
```

## About the app
### Participant Id
Before the interview begins, the interviewer must enter a participant ID.  This ID is used to name the recorded answers.

### Interview Structure
The interview takes place in two parts.  First the participant is asked to read a pre-written passage, followed by the interview questions.

### Answer Storage
Answers are recorded and versioned (e.g. if the user goes "back" and re-answers a question both are stored.)

Accessing answers involves using the "Files" app on iOS.