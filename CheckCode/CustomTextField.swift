//
//  CustomTextField.swift
//  CheckCode
//
//  Created by Rafaela Galdino on 20/07/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    private var line = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        keyboardType = .numberPad
        textAlignment = .center
        contentVerticalAlignment = .center
        font = UIFont.systemFont(ofSize: 40)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        addLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addLine() {
        line.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        line.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        line.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        line.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= 1
    }
}

