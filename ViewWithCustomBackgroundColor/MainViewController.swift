//
//  ViewController.swift
//  ViewWithCustomBackgroundColor
//
//  Created by Bober on 06/06/2020.
//  Copyright © 2020 AntonBu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func settingsTapped() {
        performSegue(withIdentifier: "settingsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "settingsSegue" else { return }
        let destinationVC = segue.destination as! SettingsViewController
        destinationVC.backgroundColor = view.backgroundColor
        destinationVC.delegate = self
    }
}

extension MainViewController: SettingsViewControllerDelegate {
    func setColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
