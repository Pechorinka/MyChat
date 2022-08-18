//
//  ViewController.swift
//  MyChat
//
//  Created by Tatyana Sidoryuk on 12.08.2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleText = K.appName
        var charIndex = 0
        titleLable.text = ""
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(charIndex), repeats: false) { timer in
                self.titleLable.text?.append(letter)
            }
            charIndex += 1
        }
    }


}

