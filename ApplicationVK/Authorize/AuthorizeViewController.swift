//
//  AuthorizeViewController.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 13.05.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import WebKit


var urlComponents = URLComponents()
class AuthorizeViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7462855"),//подставить клиент_ид
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            //URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "scope", value: "270342"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.103")
        ]
        
        
        print (urlComponents.url!)
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension AuthorizeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        
        Session.instance.token = params["access_token"]!
        Session.instance.userId = Int(params["user_id"]!)!
       
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "tabbarNavigationController")
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        print ("token =" + params["access_token"]!)
        print (params["user_id"]!)
        
        decisionHandler(.cancel)
    }
}

