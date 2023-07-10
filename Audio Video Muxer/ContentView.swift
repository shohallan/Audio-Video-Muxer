//
//  ContentView.swift
//  Audio Video Muxer
//
//  Created by Allan Sewell on 7/6/23.
//

import SwiftUI
import Foundation
//import SwiftFFmpeg

func BrowseFile() -> String{
	// Browse file finder code modified from: https://ourcodeworld.com/articles/read/1117/how-to-implement-a-file-and-directory-picker-in-macos-using-swift-5
	let dialog = NSOpenPanel();

	dialog.title = "Select a file";
	dialog.showsResizeIndicator = true;
	dialog.showsHiddenFiles = false;
	dialog.allowsMultipleSelection = false;
	dialog.canChooseDirectories = false;
	dialog.allowedFileTypes = ["mp4", "mkv", "webm", "mp3", "wav", "m4a", "m4v", "avi", "mov", "flac"]

	if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
		let result = dialog.url // Pathname of the file
		if (result != nil) {
			let path: String = result!.path
			return path
		}
	} else {
		// User clicked on "Cancel"
		return ""
	}
	return ""
}


func BrowseFolder() -> String{
	// Browse file finder code modified from: https://ourcodeworld.com/articles/read/1117/how-to-implement-a-file-and-directory-picker-in-macos-using-swift-5
	let dialog = NSOpenPanel()

	dialog.title = "Select a directory"
	dialog.showsResizeIndicator = true
	dialog.showsHiddenFiles = false
	dialog.allowsMultipleSelection = false
	dialog.canChooseDirectories = true
	dialog.canChooseFiles = false
	

	if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
		let result = dialog.url // Pathname of the file
		if (result != nil) {
			let path: String = result!.path
			return path
		}
	} else {
		// User clicked on "Cancel"
		return ""
	}
	return ""
}

func Mux(
	videoSource: String,
	audioSource: String,
	outputDest: String,
	outputName: String
){
//	var outputVideo: AVOutputFormat = init(
//		format: nil,
//		formatName: "mkv",
//		filename: $outputName
//	)
	do {
		var newOutName: String = outputName
		if outputName == "" {
			newOutName = "output"
		}
		var command: String = "ffmpeg -i \(videoSource) -i \(audioSource) -c copy \(outputDest)/\(newOutName).mkv"
		//print(try safeShell("/Users/allansewell/Downloads", "ls"))
		print(try safeShell("/Users/allansewell/Downloads", command))
		
		//print(try safeShell(command))
		//print(command)
	}
	catch {
		print("\(error)") //handle or silence the error here
	}
}

// Modified and sourced from: https://stackoverflow.com/a/50035059
@discardableResult // Add to suppress warnings when you don't want/need a result
func safeShell(_ launchPath: String, _ command: String) throws -> String {
	let task = Process()
	//task.executableURL = URL(filePath: launchPath)
	
	let pipe = Pipe()
	
	task.standardOutput = pipe
	task.standardError = pipe
	task.arguments = ["-c", command]
	task.executableURL = URL(filePath: "/bin/zsh") //<--updated
	task.standardInput = nil

	try task.run() //<--updated
	
	let data = pipe.fileHandleForReading.readDataToEndOfFile()
	let output = String(data: data, encoding: .utf8)!
	
	return output
}

struct ContentView: View {
	@State private var videoSource: String = ""
	@State private var audioSource: String = ""
	@State private var outputDest: String = ""
	@State private var outputName: String = ""

		
    var body: some View {
        VStack {
            Text("Audio Video Muxer")
			HStack {
				TextField("Select video source", text: $videoSource)
				Button("Browse"){
					videoSource = BrowseFile()
				}
			}
			HStack {
				TextField("Select audio source", text: $audioSource)
				Button("Browse"){
					audioSource = BrowseFile()
				}
			}
			HStack {
				TextField("Select output destination", text: $outputDest)
				Button("Browse"){
					outputDest = BrowseFolder()
				}
			}
			HStack {
				TextField("Enter output name (Default: 'output')", text: $outputName)
				Button("Mux!"){
					Mux(videoSource: videoSource, audioSource: audioSource, outputDest: outputDest, outputName: outputName)
				}
			}
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
