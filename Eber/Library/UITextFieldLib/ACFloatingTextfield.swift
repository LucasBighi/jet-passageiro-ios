//
//  ACFloatingTextfield.swift
//  ACFloatingTextField
//
//  Created by Er Abhishek Chandani on 31/07/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

@IBDesignable
@objc open class ACFloatingTextfield: UITextField {

    fileprivate var bottomLineView : UIView?
    fileprivate var labelPlaceholder : UILabel?
    fileprivate var labelErrorPlaceholder : UILabel = UILabel()
    fileprivate var showingError : Bool = false
    
    fileprivate var bottomLineViewHeight : NSLayoutConstraint?
    fileprivate var placeholderLabelHeight : NSLayoutConstraint?
    fileprivate var errorLabelHieght : NSLayoutConstraint?

     /// Disable Floating Label when true.
     @IBInspectable open var disableFloatingLabel : Bool = true
    
     /// Shake Bottom line when Showing Error ?
    @IBInspectable open var shakeLineWithError : Bool = false
    @IBInspectable open var isPasswordTextField : Bool = false
    let rightButton  = UIButton(type: .custom)
    
    //ADJUST RECT
    @IBInspectable var leftTextPedding: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var rightTextPedding: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    fileprivate func newBounds(_ bounds: CGRect) -> CGRect {
        
        var newBounds = bounds
        if UIApplication.shared.isProtectedDataAvailable
        {
            newBounds.origin.x = -CGFloat(leftTextPedding)
        newBounds.size.width = (bounds.width +  CGFloat(rightTextPedding))
        }
        else
        {
            newBounds.origin.x = CGFloat(leftTextPedding)
            newBounds.size.width = (bounds.width -  CGFloat(rightTextPedding))
            
        }
        return newBounds
    }
    
     /// Change Bottom Line Color.
    @IBInspectable open var lineColor : UIColor = UIColor.themeLightDividerColor {
        didSet{
            self.floatTheLabel()
        }
    }
    @IBInspectable open var normalTextColor : UIColor = UIColor.themeLightTextColor {
        didSet{
            self.floatTheLabel()
        }
    }
     /// Change line color when Editing in textfield
    @IBInspectable open var selectedLineColor : UIColor = UIColor.themeDividerColor
        {
        didSet{
            self.floatTheLabel()
        }
    }
    
     /// Change placeholder color.
    @IBInspectable open var placeHolderColor : UIColor = UIColor.themeLightTextColor {
        didSet{
            self.floatTheLabel()
        }
    }
    
     /// Change placeholder color while editing.
    @IBInspectable open var selectedPlaceHolderColor : UIColor =  UIColor.themeTextColor{
        didSet{
            self.floatTheLabel()
        }
    }
    
     /// Change Error Text color.
    @IBInspectable open var errorTextColor : UIColor = UIColor.themeErrorTextColor{
        didSet{
            self.labelErrorPlaceholder.textColor = UIColor.themeErrorTextColor
            self.floatTheLabel()
        }
    }

     /// Change Error Line color.
    @IBInspectable open var errorLineColor : UIColor = UIColor.themeErrorTextColor{
        didSet{
            self.floatTheLabel()
        }
    }
    
    //MARK:- Set Text
    override open var text:String?  {
        didSet {
            if showingError {
                self.hideErrorPlaceHolder()
            }
            floatTheLabel()
        }
    }
    
    override open var placeholder: String? {
        willSet {
            if newValue != "" {
                self.labelPlaceholder?.text = newValue
            }
        }
    }
    
    open var errorText : String? {
        willSet {
            self.labelErrorPlaceholder.text = newValue
        }
    }
    
    //MARK:- UITtextfield Draw Method Override
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        self.upadteTextField(frame: CGRect(x:self.frame.minX, y:self.frame.minY, width:rect.width, height:rect.height));
    }

    // MARK:- Loading From NIB
    override open func awakeFromNib() {
        super.awakeFromNib()
         self.initialize()
    }
    
    // MARK:- Intialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }

    // MARK:- Text Rect Management
   

    //MARK:- UITextfield Becomes First Responder
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.textFieldDidBeginEditing()
        return result
    }
    
    //MARK:- UITextfield Resigns Responder
    override open func resignFirstResponder() -> Bool {
        let result =  super.resignFirstResponder()
        self.textFieldDidEndEditing()
        return result
    }

    //MARK:- Show Error Label
    public func showError() {
        showingError = true;
        self.showErrorPlaceHolder();
    }
    public func hideError() {
        showingError = false;
        self.hideErrorPlaceHolder();
        floatTheLabel()
    }

    public func showErrorWithText(errorText : String) {
        self.errorText = errorText;
        self.labelErrorPlaceholder.text = self.errorText
        showingError = true;
        self.showErrorPlaceHolder();
    }
    public func addPasswordWatcher() {
        rightButton.addTarget(self, action: #selector(toggleShowHide), for: .touchUpInside)
        rightButton.setTitle(FontAsset.icon_hide_password, for: .normal)
        rightButton.setSimpleIconButton()
        rightButton.titleLabel?.font = FontHelper.assetFont(size: 25)
        if rightView == nil
        {
            
            rightView = rightButton
            rightButton.frame = CGRect(x:0, y:0, width:30, height:30)
        }
        rightViewMode = .always
        
        isSecureTextEntry = true
    }

}

fileprivate extension ACFloatingTextfield {
    
    //MARK:- ACFLoating Initialzation.
    func initialize() -> Void {
        
        self.clipsToBounds = false
        self.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        /// Adding Bottom Line
        addBottomLine()
        
        /// Placeholder Label Configuration.
        addFloatingLabel()
        
        /// Error Placeholder Label Configuration.
        addErrorPlaceholderLabel()
        /// Checking Floatibility
        if self.text != nil && self.text != "" {
            self.floatTheLabel()
        }
        
        if isPasswordTextField
        {
            addPasswordWatcher()
        }
        

    }
    
    
    
    @objc func toggleShowHide(button: UIButton) {
        toggle()
    }
    
    func toggle()
    {
        isSecureTextEntry = !isSecureTextEntry
        if isSecureTextEntry {
            rightButton.setTitle(FontAsset.icon_hide_password, for: .normal)
            
        } else {
            rightButton.setTitle(FontAsset.icon_show_password, for: .normal)
            
        }
    }
    //MARK:- ADD Bottom Line
    func addBottomLine(){
        
        if bottomLineView?.superview != nil {
            return
        }
        //Bottom Line UIView Configuration.
        bottomLineView = UIView()
        bottomLineView?.backgroundColor = lineColor
        bottomLineView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomLineView!)
        
        let leadingConstraint = NSLayoutConstraint.init(item: bottomLineView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint.init(item: bottomLineView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint.init(item: bottomLineView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        bottomLineViewHeight = NSLayoutConstraint.init(item: bottomLineView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1.5)
        
        self.addConstraints([leadingConstraint,trailingConstraint,bottomConstraint])
        bottomLineView?.addConstraint(bottomLineViewHeight!)
    
        self.addTarget(self, action: #selector(self.textfieldEditingChanged), for: .editingChanged)
    }
    
    @objc func textfieldEditingChanged(){
        if showingError {
            hideError()
        }
    }
        
    //MARK:- ADD Floating Label
    func addFloatingLabel(){
        
        if labelPlaceholder?.superview != nil {
            return
        }
        
        var placeholderText : String? = labelPlaceholder?.text
        if self.placeholder != nil && self.placeholder != "" {
            placeholderText = self.placeholder!
        }
        labelPlaceholder = UILabel()
        labelPlaceholder?.text = placeholderText
        labelPlaceholder?.textAlignment = self.textAlignment
        labelPlaceholder?.textColor = placeHolderColor
        labelPlaceholder?.font = FontHelper.font(size: FontSize.small, type: .Regular)
        labelPlaceholder?.isHidden = true
        labelPlaceholder?.sizeToFit()
        labelPlaceholder?.translatesAutoresizingMaskIntoConstraints = false

        //self.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")

        if labelPlaceholder != nil {
            self.addSubview(labelPlaceholder!)
        }
        let leadingConstraint :NSLayoutConstraint!
        if (self.leftView != nil)
        {
            leadingConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .leading, relatedBy: .equal, toItem: self.leftView!, attribute: .trailing, multiplier: 1, constant: 0)
        }
        else
        {
            leadingConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        }
         let trailingConstraint :NSLayoutConstraint!
        
        if (self.rightView != nil)
        {
            trailingConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .trailing, relatedBy: .equal, toItem: self.rightView!, attribute: .trailing, multiplier: 1, constant: 0)
            
        }
        else
        {

        trailingConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 10)
        }
        let topConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        placeholderLabelHeight = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15)
        
        self.addConstraints([leadingConstraint,trailingConstraint,topConstraint])
        labelPlaceholder?.addConstraint(placeholderLabelHeight!)
    }
    
    func addErrorPlaceholderLabel() -> Void {

        if self.labelErrorPlaceholder.superview != nil{
            return
        }
        
        labelErrorPlaceholder.text = self.errorText
        labelErrorPlaceholder.textAlignment = self.textAlignment
        labelErrorPlaceholder.textColor = errorTextColor
        labelErrorPlaceholder.font = FontHelper.font(size: FontSize.small, type: .Regular)
        labelErrorPlaceholder.sizeToFit()
        labelErrorPlaceholder.frame = CGRect.zero
       
        self.addSubview(labelErrorPlaceholder)
errorLabelHieght = NSLayoutConstraint.init(item: labelErrorPlaceholder, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        /*let trailingConstraint = NSLayoutConstraint.init(item: labelErrorPlaceholder!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint.init(item: labelErrorPlaceholder!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        

        //self.addConstraints([trailingConstraint,topConstraint])*/
        //labelErrorPlaceholder.addConstraint(errorLabelHieght!)

    }
    
    func showErrorPlaceHolder() {
        
        bottomLineViewHeight?.constant = 2;
        if self.errorText != nil && self.errorText != ""
        {
            errorLabelHieght?.constant = 15;
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {() -> Void in
                self.bottomLineView?.backgroundColor = self.errorLineColor;
                self.textColor = self.normalTextColor;
                
                self.labelErrorPlaceholder.frame = CGRect(x : (self.labelErrorPlaceholder.frame.origin.x), y : (self.bottomLineView?.frame.maxY)! + 5, width : self.frame.size.width, height : (self.errorLabelHieght?.constant)!)
                self.layoutIfNeeded()
                
            }, completion: {(finished: Bool) -> Void in
            })
        }else{
            errorLabelHieght?.constant = 0;
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {() -> Void in
                self.bottomLineView?.backgroundColor = self.errorLineColor;
                
                self.labelErrorPlaceholder.frame = CGRect(x : (self.labelErrorPlaceholder.frame.origin.x), y : 35, width : self.frame.size.width, height : (self.errorLabelHieght?.constant)!)
                self.layoutIfNeeded()
            }, completion: {(finished: Bool) -> Void in
            })
        }
        
        if shakeLineWithError {
            bottomLineView?.shake()
        }
        
    }
    
    
   
    func hideErrorPlaceHolder(){
        showingError = false;
        
        if errorText == nil || errorText == "" {
            return
        }
        
        errorLabelHieght?.constant = 0;
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.labelErrorPlaceholder.frame = CGRect.zero
            self.layoutIfNeeded()
        }, completion: nil)

    }

    //MARK:- Float & Resign
    func floatTheLabel() -> Void {
        DispatchQueue.main.async { /*[unowned self] in*/
            if self.text == "" && self.isFirstResponder {
                self.floatPlaceHolder(selected: true)
            }else if self.text == "" && !self.isFirstResponder {
                self.resignPlaceholder()
            }else if self.text != "" && !self.isFirstResponder  {
                self.floatPlaceHolder(selected: false)
            }else if self.text != "" && self.isFirstResponder {
                self.floatPlaceHolder(selected: true)
            }
        }
    }
    
    //MARK:- Upadate and Manage Subviews
    func upadteTextField(frame:CGRect) -> Void {
        self.frame = frame;
        self.initialize()
    }
    
    //MARK:- Float UITextfield Placeholder Label
    func floatPlaceHolder(selected:Bool) -> Void {
        
        labelPlaceholder?.isHidden = false
        if selected {
            
            bottomLineView?.backgroundColor = showingError ? self.errorLineColor : self.selectedLineColor;
            self.textColor = showingError ? self.normalTextColor : self.selectedPlaceHolderColor;
            labelPlaceholder?.textColor = showingError ? self.normalTextColor :self.selectedPlaceHolderColor;
            bottomLineViewHeight?.constant = 2;
            //self.setValue(self.selectedPlaceHolderColor, forKeyPath: "_placeholderLabel.textColor")

        } else {
            bottomLineView?.backgroundColor = showingError ? self.errorLineColor : self.selectedLineColor;
            bottomLineViewHeight?.constant = 1.5;
            self.labelPlaceholder?.textColor = showingError ? self.normalTextColor : self.placeHolderColor
            self.textColor = showingError ? self.normalTextColor : self.selectedPlaceHolderColor;
            //self.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")
        }

        if disableFloatingLabel == true {
            labelPlaceholder?.isHidden = true
            return
        }

        if placeholderLabelHeight?.constant == 15 {
            return
        }

        placeholderLabelHeight?.constant = 15;
        labelPlaceholder?.font = UIFont(name: (self.font?.fontName)!, size: 12)

        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }

    //MARK:- Resign the Placeholder
    func resignPlaceholder() -> Void
    {
        //self.setValue(self.placeHolderColor, forKeyPath: "_placeholderLabel.textColor")

        bottomLineView?.backgroundColor = showingError ? self.errorLineColor : self.lineColor;
        bottomLineViewHeight?.constant = 1.5;
        self.textColor = showingError ? self.normalTextColor :  self.placeHolderColor
        if disableFloatingLabel
        {
            labelPlaceholder?.isHidden = true
            self.labelPlaceholder?.textColor = showingError ? self.normalTextColor : self.placeHolderColor;
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
            })
            return
        }
        placeholderLabelHeight?.constant = self.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.labelPlaceholder?.font = self.font
            self.labelPlaceholder?.textColor = self.showingError ? self.normalTextColor : self.placeHolderColor
            self.layoutIfNeeded()
        }) { (finished) in
            self.labelPlaceholder?.isHidden = true
            self.placeholder = self.labelPlaceholder?.text
            self.labelPlaceholder?.textColor = self.showingError ? self.normalTextColor : self.placeHolderColor
        }
    }
    
    //MARK:- UITextField Begin Editing.
    func textFieldDidBeginEditing() -> Void {
        if showingError {
            self.hideErrorPlaceHolder()
        }
        if !self.disableFloatingLabel {
            self.placeholder = ""
        }
        self.floatTheLabel()
        self.layoutSubviews()
    }
    
    //MARK:- UITextField Begin Editing.
    func textFieldDidEndEditing() -> Void {
        self.floatTheLabel()
    }
}

//MARK:- Shake
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}


extension UITextView {
    
    private class PlaceholderLabel: UILabel { }
    
    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            label.textColor = UIColor.themeLightTextColor
            addSubview(label)
            return label
        }
    }
    
    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            let width = frame.width - textContainer.lineFragmentPadding * 2
            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)
            
            textStorage.delegate = self
        }
    }
    
}


extension UITextView: NSTextStorageDelegate{
    
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
}
