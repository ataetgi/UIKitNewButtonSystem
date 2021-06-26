//
//  ViewController.swift
//  UIKitNewButtonSystem
//
//  Created by Ata Etgi on 25.06.2021.
//

import UIKit

class ViewController: UIViewController { 
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()
    
    // MARK: - Sign In Button

    let signInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Sign In"
        config.cornerStyle = .capsule
        config.buttonSize = .large
        let btn = UIButton(configuration: config, primaryAction: nil)
        return btn
    }()
    
    lazy var cartStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(stepperTapped), for: .valueChanged)
        return stepper
    }()
    
    @objc func stepperTapped() {
        addToCartButton.setNeedsUpdateConfiguration()
    }
    
    // MARK: - Add to Cart Button

    lazy var addToCartButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title = "Add To Cart"
        config.image = UIImage(systemName: "cart.badge.plus")
        config.imagePlacement = .trailing
        let btn = UIButton(configuration: config, primaryAction: nil)
        btn.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.isCartBusy.toggle()
        }), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Check Out Button ( Activity Indicator )

    let checkOutButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.image = UIImage(systemName: "cart.fill")
        config.title = "Check Out"
        config.background.backgroundColor = .systemBlue
        
        let btn = UIButton(configuration: config, primaryAction: nil)
        return btn
    }()
    
    var isCartBusy = false {
        didSet {
            checkOutButton.setNeedsUpdateConfiguration()
        }
    }
    
    // MARK: - Toggle Button
    var toggleState = false
    
    //UIAction Setup
    lazy var stockToggleAction = UIAction(title: "In Stock Only") { [weak self] _ in
        guard let self = self else { return }
        print("Do some toggle job here.")
        self.toggleState.toggle()
    }
    
    // The button
    lazy var toggleButton: UIButton = {
        let button = UIButton(primaryAction: stockToggleAction)
        button.changesSelectionAsPrimaryAction = true // make toggle button
        button.isSelected = toggleState
        return button
    }()
    
    // MARK: - Pop-up Button
    let colorClosure = { (action: UIAction) in
        print("Do some work")
        print(action.title) // do color change job
    }
    
    lazy var popupButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.menu = UIMenu(children: [
            UIAction(title: "Bondi Blue", handler: colorClosure),
            UIAction(title: "Flower Power", state: .on, handler: colorClosure),
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true // now its a pop-up button
        return button
    }()
    
    // MARK: - Single Selection Menu/ Pull Down Button
    
    let sortClosure = { (action: UIAction) in
        print("Do sort work")
    }
    
    let refreshClosure = { (action: UIAction) in
        print("Do refresh work")
    }
    
    let accountClosure = { (action: UIAction) in
        print("Do account work")
    }
    
    // The sort menu
    lazy var sortMenu = UIMenu(title: "Sort by", options: .singleSelection, children: [
        UIAction(title: "Title", handler: sortClosure),
        UIAction(title: "Date", handler: sortClosure),
        UIAction(title: "Size", handler: sortClosure)
    ])
    
    // The top menu
    lazy var topMenu = UIMenu(children: [
        UIAction(title: "Refresh", handler: refreshClosure),
        UIAction(title: "Account", handler: accountClosure),
        sortMenu
    ])
    
    lazy var sortSelectionButton = UIBarButtonItem(title: "Selection", primaryAction: nil, menu: topMenu)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        setupCardButtonUpdateHandler()
        setupCheckOutButtonUpdateHandler()
        
//        accessPopupButtonProperties()
    
        checkOutButton.preferredBehavioralStyle = .pad // change behavior style
        
        navigationItem.rightBarButtonItem = sortSelectionButton
        //        accessSortSelectionButtonProperties()
    }
    
    fileprivate func setupCardButtonUpdateHandler() {
        addToCartButton.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            config?.image = button.isHighlighted
            ? UIImage(systemName: "cart.fill.badge.plus")
            : UIImage(systemName: "cart.badge.plus")
            config?.subtitle = "\(Int(self.cartStepper.value))"
            button.configuration = config
        }
    }
    
    fileprivate func setupCheckOutButtonUpdateHandler() {
        checkOutButton.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            config?.showsActivityIndicator = isCartBusy
            button.configuration = config
        }
    }
    
    fileprivate func accessPopupButtonProperties() {
        // Update to the currently set one
        print(popupButton.menu?.selectedElements.first?.title ?? "") // get currenty set
        
        // Update the selection
        (popupButton.menu?.children[0] as? UIAction)?.state = .on
    }
    
    fileprivate func accessSortSelectionButtonProperties() {
        // Update to the currently set one
        print(sortSelectionButton.menu?.selectedElements.first as Any) // get currenty set
        
        // Update the selection
        (sortSelectionButton.menu?.children[0] as? UIAction)?.state = .on
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .systemBackground

        title = "New UIKit Buttons"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        popupButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(cartStepper)
        stackView.addArrangedSubview(addToCartButton)
        stackView.addArrangedSubview(checkOutButton)
        stackView.addArrangedSubview(toggleButton)
        stackView.addArrangedSubview(popupButton)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 100),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -100),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            signInButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }
    
}

