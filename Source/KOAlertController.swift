//
//  KOAlertController.swift
//
//  Created by Oleksandr Khymych on 11.12.2017.
//  Copyright © 2017 Oleksandr Khymych. All rights reserved.
//

import Foundation
import UIKit

/// KOAlertController
open class KOAlertController : UIViewController {
    // MARK: - Enum
    private enum ContentState {
        case image
        case textField
        case imageANDtextField
    }
    // MARK: - Public property
    //Style property
    public var style: KOAlertStyle = KOAlertStyle()
    // Max length for textField
    public var maxLengthTextField: Int = 128
    // Image
    public var image: UIImage?
    // UIEdgeInsets for root alert view
    public var insets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 5, bottom: -2, right: 5)
    // UIEdgeInsets for  button view
    public var buttonContainerInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 16, bottom: 19, right: 16)
    // UIEdgeInsets for textField view
    public var textFieldContainerInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
    // UIEdgeInsets for textField view
    public var infoContainerInsets: UIEdgeInsets = UIEdgeInsets(top: 18, left: 16, bottom: 0, right: 16)
    // UIEdgeInsets for Image View
    public var imageInsets: UIEdgeInsets = UIEdgeInsets(top: 18, left: 4, bottom: 0, right: 16)
    // height button
    public var heightButton: CGFloat = 55
    // Image size
    public var imageSize: CGSize = CGSize(width: 80, height: 80)
    // Custom TextField
    public var alertTextField: AnyObject?
    // Duration animation
    public var animationDuration: TimeInterval = 0.3
    // MARK: - Private property
    // Message text
    private var _message: String?
    // position constraint
    private var _positionConstrant: NSLayoutConstraint?
    // Height scroll constraint
    private var _heightScrollConstraint: NSLayoutConstraint?
    // Content container
    private var _scrollView: UIScrollView?
    // Alert container
    private var _alertView: UIView?
    // Button container
    private var _buttonView: UIView?
    // Info container
    private var _infoView: UIView?
    // Header container optional
    private var _headerView: UIView?
    // textField container
    private var _textFieldView: UIView?
    //Image view
    private var _imageView: UIImageView?
    // OperationQueue
    private let _queue: OperationQueue = OperationQueue.main
    // Operations array
    private var _opsArray: Array<Operation> = []
    // Button Array
    private var _buttonArray: Array<UIButton> = []
    // UITextField Array
    private var _textFieldArray: Array<UITextField> = []
    // Actions array
    private var _actionArray: Array<(() -> Void)?> = []
    // MARK: - Init
    /// Init alert with title
    ///
    /// - Parameter title: String optional
    public init(_ title: String?) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        modalPresentationStyle = .overCurrentContext
    }
    /// Init alert with title and message
    ///
    /// - Parameters:
    ///   - title: String optional
    ///   - message: String optional
    public init(_ title: String?, _ message: String?) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        _message = message
        modalPresentationStyle = .overCurrentContext
    }
    /// Init alert with title and message, icon image
    ///
    /// - Parameters:
    ///   - title:  String optional
    ///   - message:  String optional
    ///   - image:  UIImage optional
    public init(_ title: String?, _ message: String?, _ image: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        _message = message
        self.image = image
        modalPresentationStyle = .overCurrentContext
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - View lifecycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        settings()
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for ops in _opsArray {
            ops.start()
        }
        _opsArray.removeAll()
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.70)
            self._positionConstrant?.constant = self.insets.bottom
            self.view.layoutIfNeeded()
        }) { (compete) in
            self._textFieldArray.first?.becomeFirstResponder()
        }
    }
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return presentingViewController?.preferredStatusBarStyle ?? UIStatusBarStyle.default
    }
    override open  func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation){
        UIView.animate(withDuration:self.animationDuration) {
            self._heightScrollConstraint?.constant = self.calculateScrollViewHeight()
            self.view.layoutIfNeeded()
        }
    }
    // MARK: - Settings
    private func settings() {
        //Background view settings
        backgroundViewSettings()
        //Create alert root view
        createAlertView()
        //Create and add horizontal button view
        createButtonView()
        //Create container view
        createContainerView()
        //Register Keyboard Notifications
        registerForKeyboardNotifications()
        // Add function in blockOperation to blockOperation Array
        _opsArray.append(BlockOperation(block: {
            self.createInfoView()
            self.createTextContent()
            guard let buttonView = self._buttonView else { return }
            self.addButtonConstraints(self._buttonArray, mainView: buttonView, height: self.heightButton)
        }))
    }
    /// Background view settings
    private func backgroundViewSettings() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
    }
    // MARK: - Create views
    /// Create UIView with background color and corner radius
    ///
    /// - Parameters:
    ///   - backgroundColor: UIColor
    ///   - cornerRadius: CGFloat
    /// - Returns: UIView
    private func createView(_ backgroundColor: UIColor,_ cornerRadius: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    /// Create alert root view
    private func createAlertView() {
        let alertView = createView(style.backgroundColor, style.cornerRadius)
        _alertView = alertView
        view.addSubview(alertView)
        let screenHeight = UIScreen.main.bounds.height
        //Add constraints
        switch style.position {
        case .center:
            _positionConstrant = view.centerYAnchor.constraint(equalTo: alertView.centerYAnchor, constant: -screenHeight)
        default:
            _positionConstrant = view.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -screenHeight)
        }
        guard let positionConstrant = _positionConstrant else { return }
        view.addConstraints([
            view.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: insets.right),
            alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            positionConstrant
            ])
    }
    /// Create and add button view
    private func createButtonView() {
        _buttonView = createView(.clear, 0)
        guard let alertView = _alertView, let buttonView = _buttonView else { return }
        alertView.addSubview(buttonView)
        var bottomPadding: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = window?.safeAreaInsets.bottom ?? 0
        }
        //Add constraints
        alertView.addConstraints([
            alertView.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: buttonContainerInsets.right),
            buttonView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: buttonContainerInsets.left),
            alertView.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: buttonContainerInsets.bottom + bottomPadding)
            ])
    }
    /// Create container view
    private func createContainerView() {
        _scrollView = UIScrollView()
        guard let scrollView = _scrollView, let alertView = _alertView, let buttonView = _buttonView else { return }
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(scrollView)
        _heightScrollConstraint = scrollView.heightAnchor.constraint(equalToConstant: 0)
        guard let heightScrollConstraint = _heightScrollConstraint else { return }
        //Add constraints
        alertView.addConstraints([
            alertView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: alertView.topAnchor),
            buttonView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: buttonContainerInsets.top),
            heightScrollConstraint
            ])
    }
    /// Create info view
    private func createInfoView() {
        // Add infoView to scrollView
        _infoView = createView(.clear, 0)
        guard let scrollView = _scrollView, let infoView = _infoView else { return }
        scrollView.addSubview(infoView)
        // Create textFieldView and add to scrollView if array not empty
        if _textFieldArray.count > 0 {
            _textFieldView = createView(.clear, 0)
            if let textFieldView = _textFieldView {
                scrollView.addSubview(textFieldView)
            }
        }
        // If image not nil, create imageView and add to scrollView
        if let _image = image {
            _imageView = UIImageView(image: _image)
            guard let imageView = _imageView else { return }
            imageView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(imageView)
        }
        // If image not nil and textFieldView not nil add constraints
        if let _ = image, let _ = _textFieldView {
            scrollView.addConstraints(createConstraintsForScrollView(.imageANDtextField))
            return
        }
        // If image not nil and textFieldView nil add constraints
        if let _ = image, _textFieldView == nil {
            scrollView.addConstraints(createConstraintsForScrollView(.image))
            return
        }
        // If image nil and textFieldView not nil add constraints
        if let _ = _textFieldView, image == nil {
            scrollView.addConstraints(createConstraintsForScrollView(.textField))
            return
        }
        // If image nil and textFieldView nil add constraints
        if image == nil && _textFieldView == nil {
            addConstraintsTo(infoView, scrollView, insets: infoContainerInsets)
            scrollView.centerXAnchor.constraint(equalTo: infoView.centerXAnchor).isActive = true
        }
    }
    // MARK: - Create Labels
    /// Create label
    ///
    /// - Parameters:
    ///   - text: String
    ///   - textColor: UIColor
    ///   - font: UIFont
    /// - Returns: UILabel
    private func createLabel(_ text: String, _ textColor: UIColor,_ font: UIFont ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    /// Create text content
    private func createTextContent() {
        var array: Array<UIView> = []
        // Add headerView
        if let headerView = _headerView {
            addHeaderView()
            array.append(headerView)
        }
        // Add title label
        if let _title = title {
            let label = createLabel(_title, style.titleColor, style.titleFont)
            guard let infoView = _infoView else { return }
            infoView.addSubview(label)
            array.append(label)
        }
        // Add textFeildView
        if let textFieldView = _textFieldView, _textFieldArray.count > 0 {
            for (index, view) in _textFieldArray.enumerated() {
                textFieldView.addSubview(view)
                var constrantsArray:Array<NSLayoutConstraint> = []
                //right and left
                constrantsArray.append(textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
                constrantsArray.append(view.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor))
                constrantsArray.append(view.heightAnchor.constraint(equalToConstant: view.bounds.height))
                // Top and bottom constraints
                if _textFieldArray.count == 1 {
                    constrantsArray.append(textFieldView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
                }
                if index == 0 {
                    constrantsArray.append(view.topAnchor.constraint(equalTo: textFieldView.topAnchor))
                } else {
                    //Last item
                    if index == _textFieldArray.count - 1 {
                        constrantsArray.append(textFieldView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
                    }
                    let prevLabel = _textFieldArray[index - 1]
                    constrantsArray.append(view.topAnchor.constraint(equalTo: prevLabel.bottomAnchor, constant: 2))
                    let firstItem = _textFieldArray[0]
                    constrantsArray.append(view.widthAnchor.constraint(equalTo: firstItem.widthAnchor))
                }
                textFieldView.addConstraints(constrantsArray)
            }
        }
        // Message Label
        if let _message = _message, let infoView = _infoView {
            let label = createLabel(_message, style.messageColor, style.messageFont)
            infoView.addSubview(label)
            array.append(label)
        }
        guard let infoView = _infoView, array.count > 0 else { return }
        addIndividualItemConstraints(array, mainView: infoView, insideInset: 2)
        _heightScrollConstraint?.constant = calculateScrollViewHeight()
    }
    /// Add header view
    private func addHeaderView() {
        guard let infoView = _infoView else { return }
        if let _height = _headerView?.frame.height {
            _headerView?.heightAnchor.constraint(equalToConstant: _height).isActive = true
        }
        _headerView?.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(_headerView!)
    }
    /// Calculate scrollView height
    ///
    /// - Returns: CGFloat
    private func calculateScrollViewHeight() -> CGFloat {
        guard let alertView = _alertView, let infoView = _infoView else { return 0 }
        alertView.layoutIfNeeded()
        var scrollHeight = infoView.bounds.height + infoView.frame.origin.y
        if _textFieldArray.count > 0 {
            guard let textFieldView = _textFieldView else { return 0 }
            scrollHeight += textFieldView.bounds.height + 20
        }
        var safeAreaInsets: UIEdgeInsets = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            safeAreaInsets = window?.safeAreaInsets ?? UIEdgeInsets.zero
        }
        let notScrollHeight = heightButton + buttonContainerInsets.bottom + buttonContainerInsets.top + insets.top + insets.bottom
        let maxHeight = UIScreen.main.bounds.height - (notScrollHeight + safeAreaInsets.bottom + safeAreaInsets.top)
        return scrollHeight > maxHeight ? maxHeight : scrollHeight
    }
    // MARK: - Add constraints
    /// Create constraints for scrollView with state
    ///
    /// - Parameter state: ContentState
    /// - Returns: Array<NSLayoutConstraint>
    private func createConstraintsForScrollView(_ state: ContentState) -> [NSLayoutConstraint] {
        guard let scrollView = _scrollView, let infoView = _infoView else { return [] }
        switch state {
        case .image:
            guard let imageView = _imageView else { return [] }
            return [imageView.heightAnchor.constraint(equalToConstant: imageSize.height),
                    imageView.widthAnchor.constraint(equalToConstant: imageSize.width),
                    scrollView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: infoContainerInsets.right),
                    imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: infoContainerInsets.top),
                    imageView.leadingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: imageInsets.left),
                    infoView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: infoContainerInsets.left),
                    infoView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: infoContainerInsets.top),
                    scrollView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor),
                    scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor),
                    scrollView.centerXAnchor.constraint(equalTo: infoView.centerXAnchor, constant: (imageSize.width + imageInsets.left) / 2)]
        case .textField:
            guard let textFieldView = _textFieldView else { return [] }
            return [infoView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: infoContainerInsets.top),
                    infoView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: infoContainerInsets.left),
                    scrollView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: infoContainerInsets.right),
                    scrollView.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: textFieldContainerInsets.right),
                    textFieldView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: textFieldContainerInsets.left),
                    textFieldView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: textFieldContainerInsets.top),
                    scrollView.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor),
                    scrollView.centerXAnchor.constraint(equalTo: textFieldView.centerXAnchor)]
        case .imageANDtextField:
            guard let textFieldView = _textFieldView, let imageView = _imageView else { return [] }
            return [
                imageView.heightAnchor.constraint(equalToConstant: imageSize.height),
                imageView.widthAnchor.constraint(equalToConstant: imageSize.width),
                scrollView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: imageInsets.right),
                imageView.topAnchor.constraint(equalTo: infoView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: imageInsets.left),
                textFieldView.topAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant:textFieldContainerInsets.top),
                infoView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: infoContainerInsets.top),
                infoView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: infoContainerInsets.left),
                imageView.leadingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: imageInsets.left),
                textFieldView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: textFieldContainerInsets.top),
                scrollView.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: textFieldContainerInsets.right),
                textFieldView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: textFieldContainerInsets.left),
                scrollView.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor),
                scrollView.centerXAnchor.constraint(equalTo: infoView.centerXAnchor, constant: (imageSize.width + imageInsets.left) / 2)]
        }
    }
    /// Add constrans with insets
    ///
    /// - Parameters:
    ///   - view: UIView
    ///   - mainView: UIView
    private func addConstraintsTo(_ view: UIView,_ mainView: UIView, insets: UIEdgeInsets) {
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
    private func addIndividualItemConstraints(_ items: [UIView], mainView: UIView, insideInset: CGFloat) {
        for (index, view) in items.enumerated() {
            var constrantsArray:Array<NSLayoutConstraint> = []
            //right and left
            constrantsArray.append(mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
            constrantsArray.append(view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor))
            // Top and bottom constraints
            if items.count == 1 {
                constrantsArray.append(mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
            }
            if index == 0 {
                constrantsArray.append(view.topAnchor.constraint(equalTo: mainView.topAnchor))
            } else {
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
    private func addButtonConstraints(_ buttons: [UIButton], mainView: UIView, height: CGFloat) {
        if buttons.count > 2 {
            addVerticalConstraints(buttons, mainView: mainView, height: height)
        } else {
            addHorizontalConstraints(buttons, mainView: mainView, height: height)
        }
    }
    /// Add horizontal constraints to buttons
    ///
    /// - Parameters:
    ///   - buttons: Array<UIButton>
    ///   - mainView: UIView
    ///   - height: CGFloat
    private func addHorizontalConstraints(_ buttons: [UIButton], mainView: UIView, height: CGFloat) {
        for (index, button) in buttons.enumerated() {
            var constrantsArray:Array<NSLayoutConstraint> = []
            //Top and bottom constraints
            constrantsArray.append(button.topAnchor.constraint(equalTo: mainView.topAnchor))
            constrantsArray.append(button.bottomAnchor.constraint(equalTo: mainView.bottomAnchor))
            constrantsArray.append(button.heightAnchor.constraint(equalToConstant: height))
            //right and left
            if buttons.count == 1 {
                constrantsArray.append(mainView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 0))
            }
            if index == 0 {
                constrantsArray.append(button.leadingAnchor.constraint(equalTo:mainView.leadingAnchor, constant: 0))
            } else {
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
    private func addVerticalConstraints(_ buttons: [UIButton], mainView: UIView, height: CGFloat) {
        for (index, button) in buttons.enumerated() {
            var constrantsArray:Array<NSLayoutConstraint> = []
            //right and left
            constrantsArray.append(mainView.trailingAnchor.constraint(equalTo: button.trailingAnchor))
            constrantsArray.append(button.leadingAnchor.constraint(equalTo: mainView.leadingAnchor))
            constrantsArray.append(button.heightAnchor.constraint(equalToConstant: height))
            // Top and bottom constraints
            if buttons.count == 1 {
                constrantsArray.append(mainView.bottomAnchor.constraint(equalTo: button.bottomAnchor))
            }
            if index == 0 {
                constrantsArray.append(button.topAnchor.constraint(equalTo: mainView.topAnchor))
            } else {
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
    // MARK: - Helper methods
    /// Hidden keyboard
    ///
    /// - Parameters:
    ///   - touches: Set<UIToucxh>
    ///   - event: UIEvent
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    // MARK: - Public methods
    /// Add HeaderView
    ///
    /// - Parameter view: UIView
    public func addHeaderView(_ view: UIView) {
        self._headerView = view
    }
    /// Add KOTextField
    ///
    /// - Parameter textField: KOTextField
    public func addTextField(_ textField: @escaping (UITextField) -> Void) {
        _opsArray.append(BlockOperation(block: {
            if let tempTextField = self.alertTextField as? UITextField {
                let textF = tempTextField.createCopy()
                textF.translatesAutoresizingMaskIntoConstraints = false
                textF.delegate = self
                self._textFieldArray.append(textF)
                textField(textF)
            } else {
                let textF = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
                textF.translatesAutoresizingMaskIntoConstraints = false
                textF.delegate = self
                self._textFieldArray.append(textF)
                textField(textF)
            }
        }))
    }
    /// Add action
    ///
    /// - Parameters:
    ///   - action: KOAlertButton
    ///   - handler: Void
    public func addAction(_ action: KOAlertButton, handler: @escaping () -> Void) {
        _opsArray.append(BlockOperation(block: {
            guard let buttonView = self._buttonView else { return }
            let button = UIButton(frame: CGRect.zero)
            button.setTitle(action.title, for: .normal)
            button.setTitleColor(action.titleColor, for: .normal)
            button.setTitleColor(action.titleColor.withAlphaComponent(0.25), for: .highlighted)
            button.titleLabel?.font = action.font
            button.backgroundColor = action.backgroundColor
            button.layer.borderColor = action.borderColor.cgColor
            button.layer.borderWidth = action.borderWidth
            button.layer.cornerRadius = action.cornerRadius
            button.addTarget(self, action: #selector(self.action(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            buttonView.addSubview(button)
            self._buttonArray.append(button)
        }))
        _actionArray.append(handler)
    }
    // MARK: - Private Methods
    /// Dismis self with index
    ///
    /// - Parameter index: Int
    private func dismis(_ index: Int) {
        UIView.animate(withDuration: 0.35, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self._positionConstrant?.constant = -UIScreen.main.bounds.height
            self.view.layoutIfNeeded()
        }) { (comp) in
            DispatchQueue.main.async {
                self.dismiss(animated: false) {
                    self._actionArray[index]?()
                }
            }
        }
    }
    /// Handler action
    @objc private func action(_ sender: UIButton) {
        view.endEditing(true)
        for (index, button) in _buttonArray.enumerated() {
            if button == sender {
                dismis(index)
            }
        }
    }
    // MARK: - Notifications
    // Call this method somewhere in your view controller setup code.
    @objc private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // Called when the UIKeyboardDidShowNotification is sent.
    @objc private func keyboardWasShown(_ notification: Notification) {
        guard var info = notification.userInfo, let alertView = _alertView else { return }
        guard let _frame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let kbSize = _frame.size
        UIView.animate(withDuration: info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            var bottomInset = kbSize.height + self.insets.bottom
            switch self.style.position {
            case .center:
                let bY = alertView.frame.height + alertView.frame.origin.y
                let screenHeight = UIScreen.main.bounds.height
                if (screenHeight - bottomInset) > bY{
                    bottomInset = 0
                }else{
                    bottomInset = bY - (screenHeight - bottomInset)
                }
                self._positionConstrant?.constant = bottomInset
            default:
                self._positionConstrant?.constant = bottomInset
            }
            self.view.layoutIfNeeded()
        }
    }
    // Called when the UIKeyboardWillHideNotification is sent
    @objc private func keyboardWillBeHidden(_ notification: Notification) {
        var info = notification.userInfo!
        UIView.animate(withDuration: info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            self._positionConstrant?.constant = self.insets.bottom
            self.view.layoutIfNeeded()
        }
    }
}
// MARK: - UITextFieldDelegate
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
