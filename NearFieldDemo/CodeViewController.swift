//
//  CodeViewController.swift
//  NearFieldDemo
//
//  Created by simon heij on 06/03/2019.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit

class CodeViewController: ViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var codeLabel: UILabel!
    
    let serverConnection = ServerConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createCodeTapped(_ sender: Any) {
        
        if name.text != nil {
            serverConnection.createCode(for: name.text!) { (result) -> () in
                DispatchQueue.main.async {
                    self.codeLabel.text = result

                }
            }
        }
        
    }
    
    @IBAction func validateCode(_ sender: Any) {
        if code.text != nil {
            serverConnection.validateCode(for: code.text!) { (result) -> () in
                DispatchQueue.main.async {

                    let alert = UIAlertController(title: "Friend request", message: "Accepted: \(result)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
}
