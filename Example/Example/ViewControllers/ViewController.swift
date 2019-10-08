//
//  ViewController.swift
//  Example
//
//  Created by Andrey Ivanov on 10/8/19.
//  Copyright © 2019 AndreyIvanov. All rights reserved.
//

import UIKit
import PinLayout
import lame

final class ViewController: UIViewController {

    private let titleLabel = UILabel() --> {
        $0.text = "Mp3 Recorder"
        $0.textAlignment = .center
    }

    private let progressLabel = UILabel() --> {
        $0.text = "Progress: 0"
        $0.textAlignment = .center
    }

    private let recordButton = UIButton() --> {
        $0.setTitle("Convert", for: .normal)
        $0.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(record), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(progressLabel)
        view.addSubview(recordButton)
    }

    @objc func record(_ sender: UIButton) {
        let input = Bundle.main.path(forResource: "file_example_WAV_10MG", ofType: "wav")!
        let output = FileManager.default.temporaryFileURL(fileName: "\(UUID().uuidString).mp3")!

        AudioConverter.encodeToMp3(
            inPcmPath: input,
            outMp3Path: output.path,
            onProgress: { [unowned self] progress in
                self.progressLabel.text = "Progress: \(Int(100 * progress))"
            }, onComplete: {
                print(output.path)
                self.progressLabel.text = "Complete"
        })
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        titleLabel.pin
            .top(view.pin.safeArea + 40)
            .width(100%)
            .sizeToFit(.width)

        recordButton.pin
            .bottom(view.pin.safeArea + 50)
            .hCenter()
            .height(40)
            .width(120)

        progressLabel.pin
            .width(100%)
            .center()
            .sizeToFit(.width)
    }
}

extension FileManager {

    func temporaryFileURL(fileName: String = UUID().uuidString) -> URL? {
        return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(fileName)
    }
}

infix operator -->
// prepare class instance
func --> <T>(object: T, closure: (T) -> Void) -> T {
    closure(object)
    return object
}

