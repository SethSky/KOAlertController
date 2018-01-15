//
//  KOAlertController.swift
//
//  Created by Oleksandr Khymych on 11.12.2017.
//  Copyright © 2017 Oleksandr Khymych. All rights reserved.
//

import Foundation
import UIKit

/// KOAlertController
open class KOAlertController : UIViewController{
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Enum -
    //––––––––––––––––––––––––––––––––––––––––
    private enum ContentState {
        case image
        case textField
        case imageANDtextField
    }
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Public property -
    //––––––––––––––––––––––––––––––––––––––––
    //Style property
    public var style                    : KOAlertStyle = KOAlertStyle()
    // Max length for textField
    public var maxLengthTextField       : Int = 40
    // Image
    public var image                    : UIImage?
    // UIEdgeInsets for root alert view
    public var insets                   : UIEdgeInsets = UIEdgeInsets(top: 20, left: 5, bottom: -2, right: 5)
    // UIEdgeInsets for  button view
    public var buttonContainerInsets    : UIEdgeInsets = UIEdgeInsets(top: 20, left: 16, bottom: 19, right: 16)
    // UIEdgeInsets for textField view
    public var textFieldContainerInsets : UIEdgeInsets = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
    // UIEdgeInsets for textField view
    public var infoContainerInsets      : UIEdgeInsets = UIEdgeInsets(top: 18, left: 16, bottom: 0, right: 16)
    // UIEdgeInsets for Image View
    public var imageInsets              : UIEdgeInsets = UIEdgeInsets(top: 18, left: 4, bottom: 0, right: 16)
    // height button
    public var heightButton             : CGFloat = 55
    // Image size
    public var imageSize                : CGSize = CGSize(width: 80, height: 80)
    // Custom TextField
    public var alertTextField           : AnyObject!
    // Duration animation
    public var animationDuration        : TimeInterval = 0.3
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Private property -
    //––––––––––––––––––––––––––––––––––––––––
    // Message text
    private var message                 : String?
    // position constraint
    private var positionConstrant       : NSLayoutConstraint!
    // Height scroll constraint
    private var heightScrollConstraint  : NSLayoutConstraint!
    // Content container
    private var scrollView              : UIScrollView!
    // Alert container
    private var alertView               : UIView!
    // Button container
    private var buttonView              : UIView!
    // Info container
    private var infoView                : UIView!
    // Header container optional
    private var headerView              : UIView?
    // textField container
    private var textFieldView           : UIView!
    //Image view
    private var imageView               : UIImageView!
    // OperationQueue
    private let queue                   : OperationQueue = OperationQueue.main
    // Operations array
    private var opsArray                : Array<Operation> = []
    // Button Array
    private var buttonArray             : Array<UIButton> = []
    // UITextField Array
    fileprivate var textFieldArray      : Array<UITextField> = []
    // Actions array
    private var actionArray             : Array<(()->())?> = []
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Init -
    //––––––––––––––––––––––––––––––––––––––––
    /// Init alert with title
    ///
    /// - Parameter title: String optional
    public init(_ title:String?) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.modalPresentationStyle = .overCurrentContext
    }
    /// Init alert with title and message
    ///
    /// - Parameters:
    ///   - title: String optional
    ///   - message: String optional
    public init(_ title:String?,_ message:String?) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.message = message
        self.modalPresentationStyle = .overCurrentContext
    }
    /// Init alert with title and message, icon image
    ///
    /// - Parameters:
    ///   - title:  String optional
    ///   - message:  String optional
    ///   - image:  UIImage optional
    public init(_ title:String?,_ message:String?,_ image:UIImage?) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.message = message
        self.image = image
        self.modalPresentationStyle = .overCurrentContext
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - View lifecycle -
    //––––––––––––––––––––––––––––––––––––––––
    override open func viewDidLoad() {
        super.viewDidLoad()
        settings()
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for ops in opsArray {
            ops.start()
        }
        opsArray.removeAll()
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.70)
            self.positionConstrant.constant = self.insets.bottom
            self.view.layoutIfNeeded()
        }) { (compete) in
            self.textFieldArray.first?.becomeFirstResponder()
        }
    }
    override open var preferredStatusBarStyle: UIStatusBarStyle{
        return self.presentingViewController?.preferredStatusBarStyle ?? UIStatusBarStyle.default
    }
    override open  func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation){
        UIView.animate(withDuration:self.animationDuration) {
            self.heightScrollConstraint.constant = self.calculateScrollViewHeight()
            self.view.layoutIfNeeded()
        }
    }
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Settings -
    //––––––––––––––––––––––––––––––––––––––––
    private func settings(){
        //Background view settings
        self.backgroundViewSettings()
        //Create alert root view
        self.createAlertView()
        //Create and add horizontal button view
        self.createButtonView()
        //Create container view
        self.createContainerView()
        //Register Keyboard Notifications
        registerForKeyboardNotifications()
        // Add function in blockOperation to blockOperation Array
        self.opsArray.append(BlockOperation(block: {
            self.createInfoView()
            self.createTextContent()
            self.addButtonConstraints(self.buttonArray, mainView: self.buttonView, height: self.heightButton)
        }))
    }
    /// Background view settings
    private func backgroundViewSettings(){
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
    }
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Create views -
    //––––––––––––––––––––––––––––––––––––––––
    /// Create UIView with background color and corner radius
    ///
    /// - Parameters:
    ///   - backgroundColor: UIColor
    ///   - cornerRadius: CGFloat
    /// - Returns: UIView
    private func createView(_ backgroundColor:UIColor,_ cornerRadius:CGFloat)->UIView{
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    /// Create alert root view
    private func createAlertView(){
        self.alertView = self.createView(style.backgroundColor, style.cornerRadius)
        self.view.addSubview(self.alertView)
        let screenHeight = UIScreen.main.bounds.height
        //Add constraints
        switch style.position {
        case .center:
            self.positionConstrant =  self.view.centerYAnchor.constraint(equalTo: alertView.centerYAnchor, constant: -screenHeight)
        default:
            self.positionConstrant = self.view.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -screenHeight)
        }
        self.view.addConstraints([
            self.view.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: self.insets.right),
            self.alertView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.insets.left),
            self.positionConstrant
            ])
    }
    /// Create and add button view
    private func createButtonView(){
        self.buttonView = self.createView(.clear, 0)
        self.alertView.addSubview(self.buttonView)
        //Add constraints
        self.alertView.addConstraints([
            self.alertView.trailingAnchor.constraint(equalTo: self.buttonView.trailingAnchor, constant: buttonContainerInsets.right),
            self.buttonView.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor, constant: buttonContainerInsets.left),
            self.alertView.bottomAnchor.constraint(equalTo: self.buttonView.bottomAnchor, constant: buttonContainerInsets.bottom)])
    }
    /// Create container view
    private func createContainerView(){
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.alertView.addSubview(scrollView)
        self.heightScrollConstraint = scrollView.heightAnchor.constraint(equalToConstant: 0)
        //Add constraints
        self.alertView.addConstraints([
            self.alertView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo:  self.alertView.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.alertView.topAnchor),
            self.buttonView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: buttonContainerInsets.top),
            self.heightScrollConstraint])
    }
    /// Create info view
    private func createInfoView(){
        // Add infoView to scrollView
        self.infoView = self.createView(.clear, 0)
        self.scrollView.addSubview(self.infoView)
        // Create textFieldView and add to scrollView if array not empty
        if self.textFieldArray.count > 0 {
            self.textFieldView = self.createView(.clear, 0)
            self.scrollView.addSubview(self.textFieldView)
        }
        // If image not nil, create imageView and add to scrollView
        if image != nil{
            imageView = UIImageView(image: image)
            imageView?.translatesAutoresizingMaskIntoConstraints = false
            self.scrollView.addSubview(imageView!)
        }
        // If image not nil and textFieldView not nil add constraints
        if self.image != nil && self.textFieldView != nil{
            self.scrollView.addConstraints(self.createConstraintsForScrollView(.imageANDtextField))
            return
        }
        // If image not nil and textFieldView nil add constraints
        if self.image != nil && self.textFieldView == nil{
            self.scrollView.addConstraints(self.createConstraintsForScrollView(.image))
            return
        }
        // If image nil and textFieldView not nil add constraints
        if self.image == nil && self.textFieldView != nil{
            self.scrollView.addConstraints(self.createConstraintsForScrollView(.textField))
            return
        }
        // If image nil and textFieldView nil add constraints
        if self.image == nil && self.textFieldView == nil{
            self.addConstraintsTo(self.infoView , self.scrollView, insets:infoContainerInsets)
            self.scrollView.centerXAnchor.constraint(equalTo: self.infoView.centerXAnchor).isActive = true
        }
    }
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Create Labels -
    //––––––––––––––––––––––––––––––––––––––––
    /// Create label
    ///
    /// - Parameters:
    ///   - text: String
    ///   - textColor: UIColor
    ///   - font: UIFont
    /// - Returns: UILabel
    private func createLabel(_ text:String, _ textColor:UIColor,_ font:UIFont ) -> UILabel{
        let label           = UILabel()
        label.text          = text
        label.textColor     = textColor
        label.font          = font
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    /// Create text content
    private func createTextContent(){
        var array:Array<UIView> = []
        // Add headerView
        if headerView != nil{
            self.addHeaderView()
            array.append(headerView!)
        }
        // Add title label
        if self.title != nil{
            let label = createLabel(self.title!, self.style.titleColor, self.style.titleFont)
            self.infoView.addSubview(label)
            array.append(label)
        }
        // Add textFeildView
        if self.textFieldView != nil && self.textFieldArray.count > 0{
            for (index, view) in self.textFieldArray.enumerated() {
                self.textFieldView.addSubview(view)
                var constrantsArray:Array<NSLayoutConstraint> = []
                //right and left
                constrantsArray.append(textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
                constrantsArray.append(view.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor))
                constrantsArray.append(view.heightAnchor.constraint(equalToConstant: view.bounds.height))
                // Top and bottom constraints
                if textFieldArray.count == 1{
                    constrantsArray.append(textFieldView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
                }
                if index == 0{
                    constrantsArray.append(view.topAnchor.constraint(equalTo: textFieldView.topAnchor))
                }else{
                    //Last item
                    if index == textFieldArray.count - 1 {
                        constrantsArray.append(textFieldView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
                    }
                    let prevLabel = textFieldArray[index - 1]
                    constrantsArray.append(view.topAnchor.constraint(equalTo: prevLabel.bottomAnchor, constant: 2))
                    let firstItem = textFieldArray[0]
                    constrantsArray.append(view.widthAnchor.constraint(equalTo: firstItem.widthAnchor))
                }
                textFieldView.addConstraints(constrantsArray)
            }
        }
        // Message Label
        if self.message != nil{
            let label = self.createLabel(self.message!, self.style.messageColor, self.style.messageFont)
            self.infoView.addSubview(label)
            array.append(label)
        }
        guard array.count != 0 else {
            return
        }
        self.addIndividualItemConstraints(array, mainView: self.infoView, insideInset:2)
        self.heightScrollConstraint.constant = self.calculateScrollViewHeight()
    }
    /// Add header view
    private func addHeaderView(){
        headerView?.heightAnchor.constraint(equalToConstant: (headerView?.frame.height)!).isActive = true
        headerView!.translatesAutoresizingMaskIntoConstraints = false
        self.infoView.addSubview(headerView!)
    }
    /// Calculate scrollView height
    ///
    /// - Returns: CGFloat
    private func calculateScrollViewHeight()->CGFloat{
        self.alertView.layoutIfNeeded()
        var scrollHeight = infoView.bounds.height + infoView.frame.origin.y
        if self.textFieldArray.count > 0{
            scrollHeight += textFieldView.bounds.height + 20
        }
        let notScrollHeight = heightButton + buttonContainerInsets.bottom + buttonContainerInsets.top + insets.top + insets.bottom
        let maxHeight = UIScreen.main.bounds.height - notScrollHeight
        return scrollHeight > maxHeight ? maxHeight : scrollHeight
    }
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Add constraints -
    //––––––––––––––––––––––––––––––––––––––––
    /// Create constraints for scrollView with state
    ///
    /// - Parameter state: ContentState
    /// - Returns: Array<NSLayoutConstraint>
    private func createConstraintsForScrollView(_ state:ContentState)-> [NSLayoutConstraint]{
        switch state {
        case .image:
            return [imageView.heightAnchor.constraint(equalToConstant:self.imageSize.height),
                    imageView.widthAnchor.constraint(equalToConstant: self.imageSize.width),
                    self.scrollView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: infoContainerInsets.right),
                    imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: infoContainerInsets.top),
                    imageView.leadingAnchor.constraint(equalTo: self.infoView.trailingAnchor, constant: imageInsets.left),
                    self.infoView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: infoContainerInsets.left),
                    self.infoView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: infoContainerInsets.top),
                    self.scrollView.bottomAnchor.constraint(equalTo: self.infoView.bottomAnchor),
                    self.scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor),
                    self.scrollView.centerXAnchor.constraint(equalTo: self.infoView.centerXAnchor, constant: (self.imageSize.width+imageInsets.left)/2)]
        case .textField:
            return [self.infoView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: infoContainerInsets.top),
                    self.infoView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: infoContainerInsets.left),
                    self.scrollView.trailingAnchor.constraint(equalTo: self.infoView.trailingAnchor, constant:infoContainerInsets.right),
                    self.scrollView.trailingAnchor.constraint(equalTo: self.textFieldView.trailingAnchor, constant: textFieldContainerInsets.right),
                    self.textFieldView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: textFieldContainerInsets.left),
                    self.textFieldView.topAnchor.constraint(equalTo: self.infoView.bottomAnchor, constant:textFieldContainerInsets.top),
                    self.scrollView.bottomAnchor.constraint(equalTo: self.textFieldView.bottomAnchor),
                    self.scrollView.centerXAnchor.constraint(equalTo: self.textFieldView.centerXAnchor)]
        case .imageANDtextField:
            return [
                imageView.heightAnchor.constraint(equalToConstant:self.imageSize.height),
                imageView.widthAnchor.constraint(equalToConstant: self.imageSize.width),
                self.scrollView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: imageInsets.right),
                imageView.topAnchor.constraint(equalTo: self.infoView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: self.infoView.trailingAnchor, constant: imageInsets.left),
                self.textFieldView.topAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant:textFieldContainerInsets.top),
                self.infoView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: infoContainerInsets.top),
                self.infoView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: infoContainerInsets.left),
                imageView.leadingAnchor.constraint(equalTo: self.infoView.trailingAnchor, constant: imageInsets.left),
                self.textFieldView.topAnchor.constraint(equalTo: self.infoView.bottomAnchor, constant:textFieldContainerInsets.top),
                self.scrollView.trailingAnchor.constraint(equalTo: self.textFieldView.trailingAnchor, constant: textFieldContainerInsets.right),
                self.textFieldView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: textFieldContainerInsets.left),
                self.scrollView.bottomAnchor.constraint(equalTo: self.textFieldView.bottomAnchor),
                self.scrollView.centerXAnchor.constraint(equalTo: self.infoView.centerXAnchor, constant: (self.imageSize.width+imageInsets.left)/2)]
        }
    }
    /// Add constrans with insets
    ///
    /// - Parameters:
    ///   - view: UIView
    ///   - mainView: UIView
    private func addConstraintsTo(_ view:UIView,_ mainView:UIView, insets:UIEdgeInsets){
        mainView.addConstraints([
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:insets.right),
            view.topAnchor.constraint(equalTo: mainView.topAnchor, constant:insets.top),
            view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant:insets.left),
            view.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant:insets.bottom)
            ])
    }
    /// Add individual item constraints
    ///
    /// - Parameters:
    ///   - items: Array<UIView>
    ///   - mainView: UIView
    ///   - insideInset: CGFloat
    private func addIndividualItemConstraints(_ items: [UIView], mainView: UIView, insideInset:CGFloat) {
        for (index, view) in items.enumerated() {
            var constrantsArray:Array<NSLayoutConstraint> = []
            //right and left
            constrantsArray.append(mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
            constrantsArray.append(view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor))
            // Top and bottom constraints
            if items.count == 1{
                constrantsArray.append(mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
            }
            if index == 0{
                constrantsArray.append(view.topAnchor.constraint(equalTo: mainView.topAnchor))
            }else{
                if index == items.count - 1 {
                    constrantsArray.append(mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
                }
                let prevLabel = items[index - 1]
                constrantsArray.append(view.topAnchor.constraint(equalTo: prevLabel.bottomAnchor, constant: insideInset))
                let firstItem = items[0]
                constrantsArray.append(view.widthAnchor.constraint(equalTo: firstItem.widthAnchor))
            }
            mainView.addConstraints(constrantsArray)
        }
    }
    /// Add constraints to items and root view(For Buttons)
    ///
    /// - Parameters:
    ///   - buttons: Array<UIButton>
    ///   - mainView: UIView
    ///   - height: CGFloat
    private func addButtonConstraints(_ buttons:[UIButton], mainView:UIView, height:CGFloat){
        if buttons.count > 2{
            addVerticalConstraints(buttons, mainView: mainView, height: height)
        }else{
            addHorizontalConstraints(buttons, mainView: mainView, height: height)
        }
    }
    /// Add horizontal constraints to buttons
    ///
    /// - Parameters:
    ///   - buttons: Array<UIButton>
    ///   - mainView: UIView
    ///   - height: CGFloat
    private func addHorizontalConstraints(_ buttons:[UIButton], mainView:UIView, height:CGFloat){
        for (index, button) in buttons.enumerated() {
            var constrantsArray:Array<NSLayoutConstraint> = []
            //Top and bottom constraints
            constrantsArray.append(button.topAnchor.constraint(equalTo: mainView.topAnchor))
            constrantsArray.append(button.bottomAnchor.constraint(equalTo: mainView.bottomAnchor))
            constrantsArray.append(button.heightAnchor.constraint(equalToConstant: height))
            //right and left
            if buttons.count == 1{
                constrantsArray.append(mainView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 0))
            }
            if index == 0{
                constrantsArray.append(button.leadingAnchor.constraint(equalTo:mainView.leadingAnchor, constant: 0))
            }else{
                //Last button
                if index == buttons.count - 1 {
                    constrantsArray.append(mainView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 0))
                }
                let prevButton = buttons[index - 1]
                constrantsArray.append(button.leadingAnchor.constraint(equalTo: prevButton.trailingAnchor, constant: 11))
                let firstItem = buttons[0]
                constrantsArray.append(button.widthAnchor.constraint(equalTo: firstItem.widthAnchor))
            }
            mainView.addConstraints(constrantsArray)
        }
    }
    /// Add vertical constraints to buttons
    ///
    /// - Parameters:
    ///   - buttons: Array<UIButton>
    ///   - mainView: UIView
    ///   - height: CGFloat
    private func addVerticalConstraints(_ buttons:[UIButton], mainView:UIView, height:CGFloat){
        for (index, button) in buttons.enumerated() {
            var constrantsArray:Array<NSLayoutConstraint> = []
            //right and left
            constrantsArray.append(mainView.trailingAnchor.constraint(equalTo: button.trailingAnchor))
            constrantsArray.append(button.leadingAnchor.constraint(equalTo: mainView.leadingAnchor))
            constrantsArray.append(button.heightAnchor.constraint(equalToConstant: height))
            // Top and bottom constraints
            if buttons.count == 1{
                constrantsArray.append(mainView.bottomAnchor.constraint(equalTo: button.bottomAnchor))
            }
            if index == 0{
                constrantsArray.append(button.topAnchor.constraint(equalTo: mainView.topAnchor))
            }else{
                //Last Label
                if index == buttons.count - 1 {
                    constrantsArray.append(mainView.bottomAnchor.constraint(greaterThanOrEqualTo: button.bottomAnchor))
                }
                let prevButton = buttons[index - 1]
                constrantsArray.append(button.topAnchor.constraint(equalTo: prevButton.bottomAnchor, constant: 11))
                let firstButton = buttons[0]
                constrantsArray.append(button.widthAnchor.constraint(equalTo: firstButton.widthAnchor))
            }
            mainView.addConstraints(constrantsArray)
        }
    }
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Helper methods -
    //––––––––––––––––––––––––––––––––––––––––
    /// Hidden keyboard
    ///
    /// - Parameters:
    ///   - touches: Set<UIToucxh>
    ///   - event: UIEvent
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Public methods -
    //––––––––––––––––––––––––––––––––––––––––
    /// Add HeaderView
    ///
    /// - Parameter view: UIView
    public func addHeaderView(_ view:UIView){
        self.headerView = view
    }
    /// Add KOTextField
    ///
    /// - Parameter textField: KOTextField
    public func addTextField(textField: @escaping (UITextField)->()){
        opsArray.append(BlockOperation(block: {
            if self.alertTextField == nil{
                unowned let textF = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
                textF.translatesAutoresizingMaskIntoConstraints = false
                textF.delegate = self
                self.textFieldArray.append(textF)
                textField(textF)
            }else{
                if let tempTextField = self.alertTextField as? UITextField{
                    unowned let textF = tempTextField.createCopy()
                    textF.translatesAutoresizingMaskIntoConstraints = false
                    textF.delegate = self
                    self.textFieldArray.append(textF)
                    textField(textF)
                }
            }
        }))
    }
    /// Add action
    ///
    /// - Parameters:
    ///   - action: KOAlertButton
    ///   - handler: Void
    public func addAction(_ action:KOAlertButton, handler:@escaping()->()){
        opsArray.append(BlockOperation(block: {
            let button = UIButton(frame: CGRect.zero)
            button.setTitle(action.title, for: .normal)
            button.setTitleColor(action.titleColor, for: .normal)
            button.setTitleColor(action.titleColor.withAlphaComponent(0.25), for: .highlighted)
            button.titleLabel?.font           = action.font
            button.backgroundColor            = action.backgroundColor
            button.layer.borderColor          = action.borderColor.cgColor
            button.layer.borderWidth          = action.borderWidth
            button.layer.cornerRadius         = action.cornerRadius
            button.addTarget(self, action: #selector(self.action(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            self.buttonView.addSubview(button)
            self.buttonArray.append(button)
        }))
        actionArray.append(handler)
    }
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Private Methods -
    //––––––––––––––––––––––––––––––––––––––––
    /// Dismis self with index
    ///
    /// - Parameter index: Int
    private func dismis(_ index:Int){
        UIView.animate(withDuration: 0.35, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.positionConstrant.constant = -UIScreen.main.bounds.height
            self.view.layoutIfNeeded()
        }) { (comp) in
            DispatchQueue.main.async {
                self.dismiss(animated: false){
                    self.actionArray[index]?()
                }
            }
        }
    }
    /// Handler action
    @objc private func action(_ sender:UIButton){
        self.view.endEditing(true)
        for (index, button) in buttonArray.enumerated(){
            if button == sender{
                dismis(index)
            }
        }
    }
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Notifications -
    //––––––––––––––––––––––––––––––––––––––––
    // Call this method somewhere in your view controller setup code.
    @objc private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    // Called when the UIKeyboardDidShowNotification is sent.
    @objc private func keyboardWasShown(_ notification: Notification) {
        var info = notification.userInfo!
        let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as! CGRect).size
        UIView.animate(withDuration: info[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            var bottomInset = kbSize.height + self.insets.bottom
            switch self.style.position {
            case .center:
                let bY = self.alertView.frame.height + self.alertView.frame.origin.y
                let screenHeight = UIScreen.main.bounds.height
                if (screenHeight - bottomInset) > bY{
                    bottomInset = 0
                }else{
                    bottomInset = bY - (screenHeight - bottomInset)
                }
                self.positionConstrant.constant = bottomInset
            default:
                self.positionConstrant.constant = bottomInset
            }
            self.view.layoutIfNeeded()
        }
    }
    // Called when the UIKeyboardWillHideNotification is sent
    @objc private func keyboardWillBeHidden(_ notification: Notification) {
        var info = notification.userInfo!
        UIView.animate(withDuration: info[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            self.positionConstrant.constant = self.insets.bottom
            self.view.layoutIfNeeded()
        }
    }
}
//––––––––––––––––––––––––––––––––––––––––
//MARK: - UITextFieldDelegate -
//––––––––––––––––––––––––––––––––––––––––
extension KOAlertController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let oldLength = textField.text!.count
        let replacementLength = string.count
        let rangeLength = range.length
        let newLength = oldLength - rangeLength + replacementLength
        return  newLength <= maxLengthTextField
    }
}
extension UITextField {
    func createCopy() -> UITextField {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archivedData) as! UITextField
    }
}
