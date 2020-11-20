//
//  ContentView.swift
//  Example
//
//  Created by Andrey on 20.11.2020.
//

import SwiftUI
import lame

struct ContentView: View {

    @State var progress = ""

    var body: some View {
        VStack {
            Button("convert") {
                convert()
            }.padding()
            Text(progress)
                .padding()
        }
    }

    private func convert() {
        let input = Bundle.main.path(forResource: "file_example_WAV_10MG", ofType: "wav")!
        let output = FileManager.default.temporaryFileURL(fileName: "\(UUID().uuidString).mp3")!

        AudioConverter.encodeToMp3(
            inPcmPath: input,
            outMp3Path: output.path,
            onProgress: {
                progress = "Progress: \(Int(100 * $0))"
            }, onComplete: {
                print(output.path)
                progress = "Complete"
            })
    }
}


extension FileManager {

    func temporaryFileURL(fileName: String = UUID().uuidString) -> URL? {
        return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(fileName)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
