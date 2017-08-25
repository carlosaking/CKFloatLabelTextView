//
//  CKFloatLabelTextView.swift
//  CKFloatLabelTextViewDemo
//
//  Created by Carlos A. on 8/19/17.
//  Copyright © 2017 Carlos A. King. All rights reserved.
//

import Foundation
import UIKit

let CK_FLOAT_LABEL_VERTICAL_INSET_OFFSET = 8.0

@objc public enum CKFloatLabelAnimationType : Int {
    case show = 0
    case hide
}

public class UIFloatLabelTextView: UITextView {
    
    /**
     A placeholder for UITextView
     */
    
    public var placeholder: String = ""
    /**
     * The  color for the placeholder.
     *
     * Defaults to @c lightGrayColor.
     */
    public dynamic var placeholderTextColor: UIColor?
    /**
     A UILabel that @a floats above the contents of the UITextField
     */
    public var floatLabel: UILabel?
    /**
     * The font for @c floatLabel.
     *
     * Defaults to Helvetica Neue Bold 12.0f.
     */
    public dynamic var floatLabelFont: UIFont?
    /**
     * The inactive color for the floatLabel.
     *
     * Defaults to @c lightGrayColor.
     */
    public dynamic var floatLabelPassiveColor: UIColor?
    /**
     The inactive color for the floatLabel.
     *
     * Defaults to @c blueColor.
     */
    public dynamic var floatLabelActiveColor: UIColor?
    /**
     * The duration for all animations.
     * This @c NSNumber value is converted to a @c CGFloat.
     *
     * Defaults to 0.5 seconds.
     */
    public dynamic var floatLabelAnimationDuration: NSNumber?
    /**
     * Disables the option to @a paste in the @c UIMenuController.
     * This @c NSNumber value is converted to a @c BOOL.
     */
    public dynamic var pastingEnabled: NSNumber?
    /**
     * Disables the option to @a copy in the @c UIMenuController.
     * This @c NSNumber value is converted to a @c BOOL.
     */
    public dynamic var copyingEnabled: NSNumber?
    /**
     * Disables the option to @a cut in the @c UIMenuController.
     * This @c NSNumber value is converted to a @c BOOL.
     */
    public dynamic var cuttingEnabled: NSNumber?
    /**
     * Disables the option to @a select in the @c UIMenuController.
     * This @c NSNumber value is converted to a @c BOOL.
     */
    public dynamic var selectEnabled: NSNumber?
    /**
     * Disables the option to @a select-all in the @c UIMenuController.
     * This @c NSNumber value is converted to a @c BOOL.
     */
    public dynamic var selectAllEnabled: NSNumber?
    
    /**
     Toggles the float label using an animation
     @param animationType The desired animation (and final state) for the float label.
     */
    public func toggleFloatLabel(_ animationType: CKFloatLabelAnimationType) {
    }
    
    
    public init() {
    }
    
    public init(frame: CGRect) {
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public class CKFloatLabelTextView: UIFloatLabelTextView {
    
    public var storedTextColor: UIColor?
    public var storedText: String = ""
    public var clearTextFieldButton: UIButton?
    public var xOrigin: CGFloat = 0.0
    public var horizontalPadding: CGFloat = 0.0
    
    // MARK: - Initialization
    
    override public init() {
        super.init()
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        
    }
    
    // MARK: - Breakdown
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
        
        setupMenuController()
    }
    
    // MARK: - Setup
    func setup() {
        // Build textField
        setupTextView()
        // Build floatLabel
        setupFloatLabel()
        // Enable default UIMenuController options
        setupMenuController()
        // Add listeners to observe textView changes
        setupNotifications()
    }
    
    func setupTextView() {
        // TextView Padding
        horizontalPadding = 5.0
        contentInset = UIEdgeInsetsMake(CGFloat(CK_FLOAT_LABEL_VERTICAL_INSET_OFFSET), 0.0, 0.0, 0.0)
        // Text Alignment
        textAlignment = .left
        // Text Color
        storedTextColor = .black
        // Placeholder Color
        placeholderTextColor = .lightGray
    }
    
    func setupFloatLabel() {
        // floatLabel
        floatLabel = UILabel()
        floatLabel?.textColor = .black
        floatLabel?.textAlignment = .left
        floatLabel?.font = .boldSystemFont(ofSize: 12.0)
        floatLabel?.alpha = 0.0
        floatLabel?.center = CGPoint(x: xOrigin, y: 0.0)
        addSubview(floatLabel!)
        // colors
        floatLabelPassiveColor = .lightGray
        floatLabelActiveColor = .blue
        // animationDuration
        floatLabelAnimationDuration = 0.25
    }
    
    func setupMenuController() {
        pastingEnabled = true
        copyingEnabled = true
        cuttingEnabled = true
        selectEnabled = true
        selectAllEnabled = true
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidBeginEditing), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidEndEditing), name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
    }
    
    // MARK: - Animation
    override public func toggleFloatLabel(_ animationType: CKFloatLabelAnimationType) {
        
        // Placeholder
        placeholder = (animationType == .show) ? "" : (floatLabel?.text)!
        
        // Reference textAlignment to reset origin of textView and floatLabel
        updateTextAlignment()
        
        // Common animation parameters
        let easingOptions: UIViewAnimationOptions = (animationType == .show) ? .curveEaseOut : .curveEaseIn
        let combinedOptions: UIViewAnimationOptions = [.beginFromCurrentState, easingOptions]
       
        let animationBlock: ((_: Void) -> Void)? = {() -> Void in
            self.toggleFloatLabelProperties(animationType)
        }
        
        // Toggle floatLabel visibility via UIView animation
        UIView.animate(withDuration: TimeInterval(CFloat(floatLabelAnimationDuration!)), delay: 0.0, options: combinedOptions, animations: animationBlock!) { _ in }
    }
    
    // MARK: - Helpers
    func toggleFloatLabelProperties(_ animationType: CKFloatLabelAnimationType) {
        
        floatLabel?.alpha = (animationType == .show) ? 1.0 : 0.0
        let yOrigin: CGFloat = CGFloat((animationType == .show) ? -CK_FLOAT_LABEL_VERTICAL_INSET_OFFSET : 0.0)
        floatLabel?.frame = CGRect(x: xOrigin, y: yOrigin, width: (floatLabel?.frame.width)!, height: (floatLabel?.frame.height)!)
    }
    
    func updateRectForTextFieldGeneratedViaAutoLayout() {
        // Do not shift the frame if textField is pre-populated
        if text.characters.count != 0 {
            floatLabel?.frame = CGRect(x: xOrigin, y: 0.0, width: (floatLabel?.frame.width)!, height: (floatLabel?.frame.height)!)
        }
    }
    
    // MARK: - Notifications
    func textDidBeginEditing(_ notification: Notification) {
        if (text == placeholder) {
            text = nil
            textColor = storedTextColor
        }
    }
    
    func textDidEndEditing(_ notification: Notification) {
        if text.characters.count != 0 {
            text = placeholder
            textColor = placeholderTextColor
        }
    }
    
    func textDidChange(_ notification: Notification) {
        if text.characters.count == 0 {
            storedText = text
            if floatLabel?.alpha != 0.0 {
                toggleFloatLabel(.show)
            }
        } else {
            if ((floatLabel?.alpha) != nil) {
                toggleFloatLabel(.hide)
            }
            storedText = ""
        }
    }
    
    // MARK: - UITextView (Override)
    @nonobjc func setText(_ text: String?) {
        super.text = text
        // When textField is pre-populated, show non-animated version of floatLabel
        if text!.characters.count == 0 && storedText.characters.count != 0 && !(text == placeholder) {
            toggleFloatLabelProperties(.show)
            floatLabel?.textColor = floatLabelPassiveColor
            textColor = storedTextColor
        }
    }
    
    @nonobjc func setTextColor(_ color: UIColor?) {
        super.textColor = textColor
        if !(storedTextColor != nil) {
            storedTextColor = self.textColor
        }
    }
    
    func updateTextAlignment() {
        
        let textAlignment: NSTextAlignment = self.textAlignment
        floatLabel?.textAlignment = textAlignment
        switch textAlignment {
        case .right:
            xOrigin = frame.width - (floatLabel?.frame.width)! - horizontalPadding
        case .center:
            xOrigin = frame.width / 2.0 - (floatLabel?.frame.width)! / 2.0
        default:
            // NSTextAlignmentLeft, NSTextAlignmentJustified, NSTextAlignmentNatural
            xOrigin = horizontalPadding
        }
        
    }
    
    // MARK: - UIView (Override)
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateTextAlignment()
        if !isFirstResponder && text!.characters.count != 0 {
            toggleFloatLabelProperties(.hide)
        }
    }
    
    // MARK: - UIResponder (Override)
    public override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        floatLabel?.textColor = floatLabelActiveColor
        storedText = text
        updateRectForTextFieldGeneratedViaAutoLayout()
        return true
    }
    
    public override func resignFirstResponder() -> Bool {
        if floatLabel?.text?.characters.count == 0 {
            floatLabel?.textColor = floatLabelPassiveColor
        }
        super.resignFirstResponder()
        return true
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(self.paste) {
            // Toggle Pasting
            return ((pastingEnabled) != nil) ? true : false
        } else if action == #selector(self.copy(_:)) {
            // Toggle Copying
            return ((copyingEnabled) != nil) ? true : false
        } else if action == #selector(self.cut) {
            // Toggle Cutting
            return ((cuttingEnabled) != nil) ? true : false
        } else if action == #selector(self.select) {
            // Toggle Select
            return ((selectEnabled) != nil) ? true : false
        } else if action == #selector(self.selectAll) {
            // Toggle Select All
            return ((selectAllEnabled) != nil) ? true : false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    // MARK: - Custom Synthesizers
    @nonobjc func setPlaceholder(_ placeholder: String) {
        self.placeholder = placeholder
        floatLabel?.text = self.placeholder
        if text!.characters.count != 0 {
            text = self.placeholder
            textColor = placeholderTextColor
        }
        floatLabel?.sizeToFit()
    }
    
}
