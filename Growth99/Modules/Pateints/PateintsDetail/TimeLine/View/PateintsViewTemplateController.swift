//
//  PateintsViewTemplateController.swift
//  Growth99
//
//  Created by Nitin Auti on 04/07/23.
//

import UIKit

class PateintsViewTemplateController: UIViewController, UITextViewDelegate{

    var htmlString: String?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var popUpview: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.popUpview.addBottomShadow(color: .gray, redius: 12, opacity: 0.5)
        textView.delegate = self
        textView.attributedText = htmlString?.htmlToAttributedString

    }

    @IBAction func close(){
        self.dismiss(animated: true)
    }

}

