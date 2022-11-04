//
//  LoginViewController.swift
//  MessengerApp
//
//  Created by Fatih Bilgin on 31.10.2022.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import JGProgressHUD

private let buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
private let buttonHeight = textFieldHeight
private let buttonHorizontalMargin = (textFieldHorizontalMargin / 2)
private let buttonImageDimension: CGFloat = 18
private let buttonVerticalMargin = (buttonHeight - buttonImageDimension) / 2
private let buttonWidth = (textFieldHorizontalMargin / 2) + buttonImageDimension
private let critterViewFrame = CGRect(x: 0, y: 0, width: 160, height: 160)
private let textFieldHeight: CGFloat = 37
private let textFieldHorizontalMargin: CGFloat = 16.5
private let textFieldSpacing: CGFloat = 22
private let textFieldTopMargin: CGFloat = 38.8
private let textFieldWidth: CGFloat = 206

final class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    private let critterView = CritterView(frame: critterViewFrame)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = createTextField(text: "Email")
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        //textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = createTextField(text: "Şifre")
        textField.isSecureTextEntry = true
        textField.rightView = showHidePasswordButton
        showHidePasswordButton.isHidden = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        //textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Giriş Yap", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let facebookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.attributedTitle = "Henüz kayıt olmadın mı ?"
        button.configuration?.titleAlignment = .center
        button.configuration?.attributedSubtitle = "Kayıt Ol"
        button.configuration?.attributedSubtitle?.font = .systemFont(ofSize: 16, weight: .bold)
        button.configuration?.baseForegroundColor = .text
        return button
    }()
    
    private lazy var showHidePasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: buttonVerticalMargin, leading: 0, bottom: buttonVerticalMargin, trailing: buttonHorizontalMargin)
        button.frame = buttonFrame
        button.tintColor = .text
        button.setImage(#imageLiteral(resourceName: "Password-show"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "Password-hide"), for: .selected)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        return button
    }()
    
    /*private let notificationCenter: NotificationCenter = .default
     
     deinit {
     notificationCenter.removeObserver(self)
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    // MARK: - Private
    private func setUpView() {
        view.backgroundColor = .dark
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        facebookLoginButton.delegate = self
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        registerButton.addTarget(self,
                                 action: #selector(didTapRegister),
                                 for: .touchUpInside)
        //Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(critterView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(facebookLoginButton)
        scrollView.addSubview(registerButton)
        
        setUpGestures()
        //setUpNotification()
        
        debug_setUpDebugUI()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        
        critterView.frame = CGRect(x: (scrollView.width-size)/2 - 10,
                                   y: 20,
                                   width: size * (3/2),
                                   height: size * (3/2))
        
        emailTextField.frame = CGRect(x: 60,
                                      y: critterView.bottom+10,
                                      width: scrollView.width-120,
                                      height: 42)
        
        passwordTextField.frame = CGRect(x: 60,
                                         y: emailTextField.bottom+10,
                                         width: scrollView.width-120,
                                         height: 42)
        
        loginButton.frame = CGRect(x: 60,
                                   y: passwordTextField.bottom+50,
                                   width: scrollView.width-120,
                                   height: 42)
        
        facebookLoginButton.frame = CGRect(x: 60,
                                           y: loginButton.bottom+30,
                                           width: scrollView.width-120,
                                           height: 42)
        
        registerButton.frame = CGRect(x: 60,
                                      y: facebookLoginButton.bottom+30,
                                      width: scrollView.width-120,
                                      height: 42)
        //registerButton.frame.origin.y = loginButton.bottom+20
    }
    
    private func fractionComplete(for textField: UITextField) -> Float {
        guard let text = textField.text, let font = textField.font else { return 0 }
        let textFieldWidth = textField.bounds.width - (2 * textFieldHorizontalMargin)
        return min(Float(text.size(withAttributes: [NSAttributedString.Key.font : font]).width / textFieldWidth), 1)
    }
    
    private func stopHeadRotation() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        critterView.stopHeadRotation()
        passwordDidResignAsFirstResponder()
    }
    
    private func passwordDidResignAsFirstResponder() {
        critterView.isPeeking = false
        critterView.isShy = false
        showHidePasswordButton.isHidden = true
        showHidePasswordButton.isSelected = false
        passwordTextField.isSecureTextEntry = true
    }
    
    private func createTextField(text: String) -> UITextField {
        let view = UITextField(frame: CGRect(x: 0, y: 0, width: textFieldWidth, height: textFieldHeight))
        view.backgroundColor = .white
        view.layer.cornerRadius = 4.07
        view.tintColor = .dark
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.spellCheckingType = .no
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let frame = CGRect(x: 0, y: 0, width: textFieldHorizontalMargin, height: textFieldHeight)
        view.leftView = UIView(frame: frame)
        view.leftViewMode = .always
        
        view.rightView = UIView(frame: frame)
        view.rightViewMode = .always
        
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        view.textColor = .text
        
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.disabledText,
            .font : view.font!
        ]
        
        view.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
        
        return view
    }
    
    // MARK: - Gestures
    
    private func setUpGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        stopHeadRotation()
    }
    // MARK: - Actions
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isPasswordVisible = sender.isSelected
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        critterView.isPeeking = isPasswordVisible
        
        // 🎩✨ Magic to fix cursor position when toggling password visibility
        if let textRange = passwordTextField.textRange(from: passwordTextField.beginningOfDocument, to: passwordTextField.endOfDocument), let password = passwordTextField.text {
            passwordTextField.replace(textRange, withText: password)
        }
    }
    
    @objc private func loginButtonTapped() {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            
            return
        }
        
        spinner.show(in: view)
        
        //Firebase Log In
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else{
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard let _ = authResult, error == nil else {
                self?.alertUserLoginError(message: "Bilgilerinizi Kontrol Edin.")
                return
            }
            strongSelf.navigationController?.dismiss(animated: true)
        }
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func alertUserLoginError(message: String) {
        let alert = UIAlertController(title: "Woops!",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam",
                                      style: .cancel))
        
        present(alert, animated: true)
    }
    
    // MARK: - Notifications
    
    /*  private func setUpNotification() {
     notificationCenter.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
     }
     
     @objc private func applicationDidEnterBackground() {
     stopHeadRotation()
     } */
    
    // MARK: - Debug Mode
    
    private let isDebugMode = false
    
    private lazy var dubug_activeAnimationSlider = UISlider()
    
    private func debug_setUpDebugUI() {
        guard isDebugMode else { return }
        
        let animateButton = UIButton(type: .system)
        animateButton.setTitle("Activate", for: .normal)
        animateButton.setTitleColor(.white, for: .normal)
        animateButton.addTarget(self, action: #selector(debug_activeAnimation), for: .touchUpInside)
        
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Neutral", for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.addTarget(self, action: #selector(debug_neutralAnimation), for: .touchUpInside)
        
        let validateButton = UIButton(type: .system)
        validateButton.setTitle("Ecstatic", for: .normal)
        validateButton.setTitleColor(.white, for: .normal)
        validateButton.addTarget(self, action: #selector(debug_ecstaticAnimation), for: .touchUpInside)
        
        dubug_activeAnimationSlider.tintColor = .light
        dubug_activeAnimationSlider.isEnabled = false
        dubug_activeAnimationSlider.addTarget(self, action: #selector(debug_activeAnimationSliderValueChanged(sender:)), for: .valueChanged)
        
        let stackView = UIStackView(
            arrangedSubviews:
                [
                    animateButton,
                    resetButton,
                    validateButton,
                    dubug_activeAnimationSlider
                ]
        )
        stackView.axis = .vertical
        stackView.spacing = 5
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func debug_activeAnimation() {
        critterView.startHeadRotation(startAt: dubug_activeAnimationSlider.value)
        dubug_activeAnimationSlider.isEnabled = true
    }
    
    @objc private func debug_neutralAnimation() {
        stopHeadRotation()
        dubug_activeAnimationSlider.isEnabled = false
    }
    
    @objc private func debug_ecstaticAnimation() {
        critterView.isEcstatic.toggle()
    }
    
    @objc private func debug_activeAnimationSliderValueChanged(sender: UISlider) {
        critterView.updateHeadRotation(to: sender.value)
    }
}
// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let deadlineTime = DispatchTime.now() + .milliseconds(100)
        
        if textField == emailTextField {
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) { // 🎩✨ Magic to ensure animation starts
                let fractionComplete = self.fractionComplete(for: textField)
                self.critterView.startHeadRotation(startAt: fractionComplete)
                self.passwordDidResignAsFirstResponder()
            }
        }
        else if textField == passwordTextField {
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) { // 🎩✨ Magic to ensure animation starts
                self.critterView.isShy = true
                self.showHidePasswordButton.isHidden = false
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else {
            passwordTextField.resignFirstResponder()
            passwordDidResignAsFirstResponder()
            loginButtonTapped()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            critterView.stopHeadRotation()
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard !critterView.isActiveStartAnimating, textField == emailTextField else { return }
        
        let fractionComplete = self.fractionComplete(for: textField)
        critterView.updateHeadRotation(to: fractionComplete)
        
        if let text = textField.text {
            critterView.isEcstatic = text.contains("@")
        }
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            self.alertUserLoginError(message: error?.localizedDescription ?? "Hata!!")
            return
        }
        
        let facebookReques = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                        parameters: ["fields":
                                                                        "email, first_name, last_name, picture.type(large)"],
                                                        tokenString: token,
                                                        version: nil,
                                                        httpMethod: .get)
        
        facebookReques.start { _, result, error in
            guard let result = result as? [String: Any],
                  error == nil else {
                self.alertUserLoginError(message: error?.localizedDescription ?? "Hata")
                return
            }
            
            guard let firstName = result["first_name"] as? String,
                  let lastName = result["last_name"] as? String,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String: Any],
                  let data = picture["data"] as? [String: Any],
                  let pictureUrl = data["url"] as? String else {
                self.alertUserLoginError(message: error?.localizedDescription ?? "Hata!")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                guard let strongSelf = self else {
                    return
                }
                
                DatabaseManager.shared.userExists(with: email) { exists in
                    if !exists {
                        let chatUser = ChatAppUser(firstName: firstName,
                                                   lastName: lastName,
                                                   emailAddress: email)
                        DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                            if success {
                                
                                guard let url = URL(string: pictureUrl) else {
                                    return
                                }
                                
                                URLSession.shared.dataTask(with: url, completionHandler: { data, _,_ in
                                    guard let data = data else {
                                        return
                                    }
                                    // upload image
                                    let fileName = chatUser.profilePictureFileName
                                    StorageManager.shared.uploadProfilePicture(with: data,
                                                                               fileName: fileName,
                                                                               completion: { result in
                                        switch result {
                                        case .success(let downloadUrl):
                                            UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                            print(downloadUrl)
                                        case .failure(let error):
                                            print("Storage manager error: \(error)")
                                        }
                                    })
                                }).resume()
                            }
                        })
                    }
                }
                
                guard authResult != nil, error == nil else {
                    if let error = error {
                        self?.alertUserLoginError(message: error.localizedDescription)
                    }
                    return
                }
                
                print("Succesfulfy logged user in")
                strongSelf.navigationController?.dismiss(animated: true)
            })
        }
    }
}
