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
        setLabels()
        setTextFields()
        customView.backgroundColor = getColor()
    }
    
    @IBAction func doneButtonPressed() {
        delegate.setColor(getColor())
        dismiss(animated: true)
    }
    
    private func getColor() -> UIColor {
        return UIColor(red: CGFloat(redSlider.value),
                       green: CGFloat(greenSlider.value),
                       blue: CGFloat(blueSlider.value),
                       alpha: 1)
    }
    
    private func setLabels() {
        for (componentLabel, slider) in zip(componentLabels, sliders) {
            componentLabel.text = String(format: "%.2f", slider.value)
        }
    }
    
    private func setTextFields() {
        for (componentTextField, slider) in zip(componentTextFields, sliders) {
            componentTextField.text = String(format: "%.2f", slider.value)
            componentTextField.delegate = self
        }
    }
    
    private func setSlidersValue(components: [Float]) {
        for (slider, component) in zip(sliders, componentTextFields) {
            slider.value = Float(component.text ?? "0") ?? 0
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
                                         action: #selector(dismissKeybord))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        for textField in componentTextFields {
            textField.inputAccessoryView = toolbar
        }
    }
    
    @objc private func dismissKeybord() {
        view.endEditing(true)
        
    }
    
    private func setStartState() {
        setSliders()
        setLabels()
        setTextFields()
        createToolbar()
        customView.layer.cornerRadius = 10
        customView.backgroundColor = getColor()
    }
}

extension SettingsViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        sliders[textField.tag].value = Float(textField.text ?? "0") ?? 0
        setLabels()
        customView.backgroundColor = getColor()
    }
}
