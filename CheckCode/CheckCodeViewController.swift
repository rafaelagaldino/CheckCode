//
//  ViewController.swift
//  CheckCode
//
//  Created by Rafaela Galdino on 17/07/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CheckCodeViewController: UIViewController {
    private var container = UIView()
    private var line = UIView()
    private var message = UILabel()
    private var firstDigitTextField = CustomTextField()
    private var secondDigitTextField = CustomTextField()
    private var thirdDigitTextField = CustomTextField()
    private var fourthDigitTextField = CustomTextField()
    private var fifthDigitTextField = CustomTextField()
    private var sixthDigitTextField = CustomTextField()
    private var stackView = UIStackView()
    private var verifyButton = UIButton()

    var digitTextFields: [UITextField] = []
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "Verify Login"
        
        digitTextFields = [firstDigitTextField, secondDigitTextField, thirdDigitTextField, fourthDigitTextField, fifthDigitTextField, sixthDigitTextField]
        addContainer()
        addLine()
        addLabel()
        addStackView()
        addTextFields()
        addButton()
        
        let responders: [(digitTextField: UITextField, potentialNextResponder: UITextField?)] = [
            (firstDigitTextField, secondDigitTextField),
            (secondDigitTextField, thirdDigitTextField),
            (thirdDigitTextField, fourthDigitTextField),
            (fourthDigitTextField, fifthDigitTextField),
            (fifthDigitTextField, sixthDigitTextField),
            (sixthDigitTextField, nil)
        ]
        
        for (digitTextField, potentialNextResponder) in responders {
            if let nextResponder = potentialNextResponder {
                digitTextField.rx.controlEvent(.editingChanged)
                    .asObservable()
                    .subscribe(onNext: { nextResponder.becomeFirstResponder() })
                    .disposed(by: disposeBag)
            } else {
                digitTextField.rx.controlEvent(.editingChanged)
                    .asObservable()
                    .subscribe(onNext: { digitTextField.resignFirstResponder() })
                    .disposed(by: disposeBag)
            }
        }
        
        for digitTextField in digitTextFields {
            digitTextField.rx.controlEvent(.editingDidBegin)
                .asObservable()
                .subscribe(onNext: { [unowned self] _ in
                    digitTextField.text = ""
                    self.enableButton(button: self.verifyButton, enabled: false)
                })
                .disposed(by: disposeBag)
        }
        
        let digitObservables = digitTextFields.map { $0.rx.text.map { $0 ?? "" } }
        
        Observable.combineLatest(digitObservables)
            .subscribe(onNext: { [unowned self] in
                var enabled = true
                for textField in $0 {
                    if textField.count < 1 {
                        enabled = false
                    }
                }
                self.enableButton(button: self.verifyButton, enabled: enabled)
            })
            .disposed(by: disposeBag)
    }

    func addContainer() {
        container.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func addLine() {
        line.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        container.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        line.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
        line.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20).isActive = true
        line.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    func addLabel() {
        message.numberOfLines = 0
        message.text = "Check your email and enter your code"
        message.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        message.font = UIFont(name: "ArialMT", size: 16)
        container.addSubview(message)
        message.translatesAutoresizingMaskIntoConstraints = false
        message.topAnchor.constraint(equalTo: line.topAnchor, constant: 50).isActive = true
        message.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
    }
    
    func addStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.spacing = 7
        stackView.distribution = .fillEqually
        container.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: message.topAnchor, constant: 60).isActive = true
        stackView.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true
    }
    
    func addTextFields() {
        stackView.addArrangedSubview(firstDigitTextField)
        stackView.addArrangedSubview(secondDigitTextField)
        stackView.addArrangedSubview(thirdDigitTextField)
        stackView.addArrangedSubview(fourthDigitTextField)
        stackView.addArrangedSubview(fifthDigitTextField)
        stackView.addArrangedSubview(sixthDigitTextField)
    }
    
    func addButton() {
        verifyButton.setTitle("Verify", for: .normal)
        verifyButton.setTitleColor(.black, for: .normal)
        verifyButton.isEnabled = false
        verifyButton.alpha = 0.25
        container.addSubview(verifyButton)
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        verifyButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50).isActive = true
        verifyButton.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true
    }
    
    func enableButton(button: UIButton, enabled: Bool) {
        button.isEnabled = enabled
        button.alpha = enabled ? 1.0 : 0.25
    }
}

