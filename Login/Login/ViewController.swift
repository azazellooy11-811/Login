//
//  ViewController.swift
//  Login
//
//  Created by Азалия Халилова on 09.04.2023.
//

import UIKit
import RegexBuilder

class ViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var envelopImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailUnderLine: UIView!
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordUnderLine: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    //MARK: - Properties
    var isLogin = true
    
    private let activeColor = UIColor.red
    private var email: String = "" {
        didSet {
            loginButton.isUserInteractionEnabled = !(email.isEmpty || password.isEmpty)
            loginButton.backgroundColor = !(email.isEmpty || password.isEmpty) ? UIColor(named: "myColor") : .gray
        }
    }
    private var password: String = "" {
        didSet {
            loginButton.isUserInteractionEnabled = !(email.isEmpty || password.isEmpty)
            loginButton.backgroundColor = !(email.isEmpty || password.isEmpty) ? UIColor(named: "myColor") : .gray
        }
    }
    private let mockEmail: String = "abc@gmail.com"
    private let mockPassword: String = "123456"
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLoginButton()
        noAccountLabel.isHidden = !isLogin
        signupButton.isHidden = !isLogin
        emailTextField.delegate = self
        passwordTextField.delegate = self
        //emailTextField.becomeFirstResponder()
    }
    
    //MARK: - IBActions
  
    @IBAction func loginButtonAction(_ sender: UIButton) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if email.isEmpty {
            makeErrorField(textField: emailTextField)
        }
        if password.isEmpty {
            makeErrorField(textField: passwordTextField)
        }
        
        if isLogin {
            if KeychainManager.checkUser(with: email, password: password) {
                performSegue(withIdentifier: "goToHomePage", sender: sender)
            } else {
                let alert = UIAlertController(title: "Error".localized,
                                              message: "Wrong e-mail or password".localized,
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "OK".localized, style: .default)
                alert.addAction(action)
                present(alert, animated: true)
            }
        } else {
            if KeychainManager.save(email: email, password: password) {
                performSegue(withIdentifier: "goToHomePage", sender: sender)
            } else {
                debugPrint("Error with saving e p")
            }
        }
    }
    
    @IBAction func signupButtonAction(_ sender: Any) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
        viewController.isLogin = false
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Private methods
    private func setupLoginButton() {
        loginButton.layer.shadowColor = UIColor.purple.cgColor
        loginButton.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        loginButton.layer.shadowOpacity = 0.7
        loginButton.layer.shadowRadius = 5
        
        loginButton.isUserInteractionEnabled = false
        loginButton.backgroundColor = .gray
        
        loginButton.setTitle(isLogin ? "Login" : "Register", for: .normal)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        !text.isEmpty else { return }
        
        switch textField {
        case emailTextField:
            let isValidEmail = check(email: text)
            
            if isValidEmail {
                email = text
                envelopImageView.tintColor = UIColor(named: "myColor")
                emailUnderLine.backgroundColor = UIColor(named: "myColor")
            } else {
                email = ""
                makeErrorField(textField: textField)
            }
        case passwordTextField:
            let isValidPassword = check(password: text)
            
            if isValidPassword {
                password = text
                lockImageView.tintColor = UIColor(named: "myColor")
                passwordUnderLine.backgroundColor = UIColor(named: "myColor")
            } else {
                password = ""
                makeErrorField(textField: textField)
            }
        default:
            print("default")
        }
    }
    
    private func check(email: String) -> Bool {
        let regex = Regex {
            OneOrMore {
                CharacterClass(
                    .anyOf("._%+-"),
                    ("A"..."Z"),
                    ("0"..."9"),
                    ("a"..."z")
                )
            }
            "@"
            OneOrMore {
                CharacterClass(
                    .anyOf(".-"),
                    ("A"..."Z"),
                    ("a"..."z"),
                    ("0"..."9")
                )
            }
            "."
            Repeat(2...64) {
                CharacterClass(
                    ("A"..."Z"),
                    ("a"..."z")
                )
            }
        }
        return email.contains(regex)
    }
    
    private func check(password: String) -> Bool {
        return password.count >= 4
    }
    
    private func makeErrorField(textField: UITextField) {
        switch textField {
        case emailTextField:
            envelopImageView.tintColor = activeColor
            emailUnderLine.backgroundColor = activeColor
        case passwordTextField:
            lockImageView.tintColor = activeColor
            passwordUnderLine.backgroundColor = activeColor
        default:
            print("d")
        }
    }
}
