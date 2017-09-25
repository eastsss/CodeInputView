//
//  CodeInputView.swift
//  CodeInputView
//
//  Created by Anatoliy Radchenko on 25/07/2017.
//  Copyright © 2017 Anatoliy Radchenko. All rights reserved.
//

import UIKit

public protocol CodeInputViewDelegate: class {
    func codeInputViewSubmitted(code: String)
}

final public class CodeInputView: UIView {
    public weak var delegate: CodeInputViewDelegate?
    
    public var codeLength: Int = 4 {
        didSet {
            redraw()
        }
    }
    
    public var code: String = "" {
        didSet {
            redraw()
        }
    }
    
    public var placeholderSymbol: String = "-" {
        didSet {
            redraw()
        }
    }
    
    public var kerning: CGFloat = 20 {
        didSet {
            redraw()
        }
    }
    
    public var textColor: UIColor = UIColor.black {
        didSet {
            label.textColor = textColor
            redraw()
        }
    }
    
    public var font: UIFont = UIFont.boldSystemFont(ofSize: 40) {
        didSet {
            label.font = font
            redraw()
        }
    }
    
    fileprivate let label = UILabel()
    fileprivate var _keyboardType: UIKeyboardType = .numberPad
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = bounds
    }
    
    override public var intrinsicContentSize: CGSize {
        return label.intrinsicContentSize
    }
    
    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        becomeFirstResponder()
    }
    
    public func clearInput() {
        code = ""
        redraw()
    }
}

// MARK: UIKeyInput
extension CodeInputView: UIKeyInput {
    public var keyboardType: UIKeyboardType {
        get {
            return _keyboardType
        }
        set {
            _keyboardType = newValue
        }
    }
    
    public var hasText: Bool {
        return !code.isEmpty
    }
    
    public func insertText(_ text: String) {
        guard code.characters.count < codeLength else {
            return
        }
        
        code.append(text)
        redraw()
        
        if code.characters.count == codeLength {
            delegate?.codeInputViewSubmitted(code: code)
        }
    }
    
    public func deleteBackward() {
        guard !code.isEmpty else {
            return
        }
        
        code.remove(at: code.index(before: code.endIndex))
        redraw()
    }
}

// MARK: Supporting methods
private extension CodeInputView {
    func configure() {
        label.font = font
        label.textColor = textColor
        label.textAlignment = .center
        addSubview(label)
        
        redraw()
    }
    
    func redraw() {
        var result = code
        
        let add = codeLength - code.characters.count
        if add > 0 {
            let pad = String().padding(
                toLength: add,
                withPad: placeholderSymbol,
                startingAt: 0
            )
            result.append(pad)
        }
        
        let attributedResult = NSMutableAttributedString(string: result)
        attributedResult.addAttribute(
            NSAttributedStringKey.kern,
            value: kerning,
            // swiftlint:disable:next legacy_constructor
            range: NSMakeRange(0, result.characters.count - 1)
        )
        
        label.attributedText = attributedResult
        invalidateIntrinsicContentSize()
    }
}
