//
//  ViewController.swift
//  Login
//
//  Created by Азалия Халилова on 09.04.2023.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var emailUnderLine: UIView!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var passwordUnderLine: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureButton()
    }
    
    //MARK: - IBActions
  
    @IBAction func loginButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func signupButtonAction(_ sender: Any) {
    }
    
    //MARK: - Methods
    private func configureButton() {
        loginButton.layer.shadowColor = UIColor.purple.cgColor
        loginButton.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        loginButton.layer.shadowOpacity = 0.7
        loginButton.layer.shadowRadius = 5
    }
}

