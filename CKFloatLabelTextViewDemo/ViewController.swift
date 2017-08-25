//
//  ViewController.swift
//  CKFloatLabelTextViewDemo
//
//  Created by Carlos A. on 8/19/17.
//  Copyright © 2017 Carlos A. King. All rights reserved.
//

import UIKit
import CKFloatLabelTextView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .blue
        setupTextView()
    }
    
    
    func setupTextView() {
        
        // iOS 7 misaligned text bugfix (http://stackoverflow.com/a/19706526/814861)
        self.automaticallyAdjustsScrollViewInsets = false
        
        let textView = CKFloatLabelTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.placeholder = "Placeholder text for TextView1"
        textView.floatLabelActiveColor = UIColor.orange
        textView.floatLabelPassiveColor = UIColor.lightGray
        textView.textAlignment = .right
        textView.layer.borderColor = UIColor.black.cgColor
        textView.font = UIFont.systemFont(ofSize: 19.0)
        textView.floatLabel?.font = UIFont.systemFont(ofSize: 12.0)
        self.view.addSubview(textView)
        
        // Horizontal
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[textView]-10-|", options: .alignAllLastBaseline, metrics: nil, views: ["textView" : textView]))
        // Vertical
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[textView(100)]", options: [], metrics: nil, views: ["textView" : textView]))

        
        /*
        var textView2 = CKFloatLabelTextView()
        textView2.translatesAutoresizingMaskIntoConstraints = false
        textView2.placeholder = "Placeholder text for TextView2"
        textView2.floatLabelActiveColor = UIColor.orangeColor()
        textView2.floatLabelPassiveColor = UIColor.lightGrayColor()
        textView2.layer.borderColor = UIColor.blackColor().CGColor
        textView2.font = UIFont.systemFontOfSize(19.0)
        textView2.floatLabel.font = UIFont.systemFontOfSize(12.0)
        self.view.addSubview(textView2)
        // Horizontal
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[textView2]-10-|", options: NSLayoutFormatAlignAllBaseline, metrics: nil, views: NSDictionaryOfVariableBindings(textView2)))
        // Vertical
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[textView2(100)]-200-|", options: [], metrics: nil, views: NSDictionaryOfVariableBindings(textView, textView2)))
         */
    }


}

