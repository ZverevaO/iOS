//
//  LoginFormControllerViewController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 07.02.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit

class LoginFormControllerViewController: UIViewController {
    
    @IBOutlet weak var loginTextFild: UITextField!
    
    @IBOutlet weak var passworTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let hideAction = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideAction)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardDidHideNotification,
                                                  object: nil)
    }
    
    @objc func keyboardWillShow (notification: Notification) {
        
        let info = notification.userInfo! as NSDictionary
        let size = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: size.height, right: 0)
        
        self.scrollView?.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide (notification: Notification)
    {
        scrollView.contentInset = .zero
    }
    
    @objc func hideKeyboard ()
    {
        view.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        switch identifier {
        case "loginSegue":
            
            let isAuth = login()
            
            if !isAuth {
                showErrorAlert()
            }
            
            return isAuth
        default:
            return true
        }
    }
    
    func login () -> Bool {
        // функция проверки учетных данных пользователя
        //        guard let login = loginTextFild.text, let password = passworTextField.text else {return}
        let login = loginTextFild.text!
        let password = passworTextField.text!
        return login == "admin" && password == "123456"
        
    }
    
    func showErrorAlert() {
        // вывод сообщения для пользователя
        // Создаем контроллер
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Введены неверные данные пользователя",
            preferredStyle: .alert)
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        // Добавляем кнопку на UIAlertController
        alert.addAction(action)
        // Показываем UIAlertController
        present(alert, animated: true)
    }
    
    
    

       
}
