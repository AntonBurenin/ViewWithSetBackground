//
//  SettingsViewController.swift
//  CustomColorView
//
//  Created by Bober on 22/05/2020.
//  Copyright © 2020 AntonBu. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func setColor(_ color: UIColor)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var customView: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet var sliders: [UISlider]!
    @IBOutlet var componentLabels: [UILabel]!
    @IBOutlet var componentTextFields: [UITextField]!
    
    var backgroundColor: UIColor!
    var delegate: SettingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStartState()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func sliderChanged() {
        setTextFields()
        updateLabelsAndColor()
    }
    
    @IBAction func doneButtonPressed() {
        delegate.setColor(getColor())
        dismiss(animated: true)
    }
}

// MARK: - Private methods
extension SettingsViewController {
    private func getColor() -> UIColor {
        return UIColor(red: CGFloat(redSlider.value),
                       green: CGFloat(greenSlider.value),
                       blue: CGFloat(blueSlider.value),
                       alpha: 1)
    }
    
    private func string(value: Float) -> String {
        return String(format: "%.2f", value)
    }
    
    private func setLabels() {
        for (componentLabel, slider) in zip(componentLabels, sliders) {
            componentLabel.text = string(value: slider.value)
        }
    }
    
    private func setTextFields() {
        for (componentTextField, slider) in zip(componentTextFields, sliders) {
            componentTextField.text = string(value: slider.value)
            componentTextField.delegate = self
        }
    }
    
    private func setSliders() {
        let colors = [UIColor.red, UIColor.green, UIColor.blue]
        for (slider, color) in zip(sliders, colors) {
            slider.minimumTrackTintColor = color
        }
        
        guard let colorComponents = backgroundColor.cgColor.components else {return}
        for (slider, component) in zip(sliders, colorComponents) {
            slider.value = Float(component)
        }
    }
    
    private func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(hideKeybord))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        for textField in componentTextFields {
            textField.inputAccessoryView = toolbar
        }
    }
    
    @objc private func hideKeybord() {
        view.endEditing(true)
        
    }
    
    private func updateLabelsAndColor() {
        setLabels()
        customView.backgroundColor = getColor()
    }
    
    private func setStartState() {
        setSliders()
        setTextFields()
        createToolbar()
        customView.layer.cornerRadius = 10
        updateLabelsAndColor()
    }
}

// MARK: - UIAlertController
extension SettingsViewController {
    private func showAlert(with title: String,
                           and message: String,
                           for textField: UITextField) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField.text = self.string(value: self.sliders[textField.tag].value)
            textField.becomeFirstResponder()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - TextFieldDelegate
extension SettingsViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard
            let text = textField.text,
            let value = Float(text),
            value <= 1,
            value >= 0
        else {
                showAlert(with: "Warning!", and: "Введите значение от 0 до 1", for: textField)
                return
        }
        sliders[textField.tag].value = value
        textField.text = string(value: sliders[textField.tag].value)    //на случай если введено больше 2 знаков после запятой
        updateLabelsAndColor()
    }
}
