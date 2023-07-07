//
//  ContentView.swift
//  Audio Video Muxer
//
//  Created by Allan Sewell on 7/6/23.
//

import SwiftUI

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
