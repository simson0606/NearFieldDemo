//
//  ViewController.swift
//  NearFieldDemo
//
//  Created by simon heij on 08-02-19.
//  Copyright © 2019 simon heij. All rights reserved.
//

import UIKit
import NotificationCenter

class ViewController: UIViewController, FriendRequestReceiver {
    

    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var refreshSwitch: UISwitch!
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultMessageLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)


       
        let timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.QrValidSeconds-1), target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func fireTimer() {
        if refreshSwitch.isOn && nameTextField?.text != nil {
            let friendRequest = FriendRequestData(dateTime: Date(), name: nameTextField.text!)
            let jsonEncoder = JSONEncoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            jsonEncoder.dateEncodingStrategy = .formatted(formatter)
            let jsonData = try! jsonEncoder.encode(friendRequest)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            let cryptor = StringCryptor()
            let encrypted = cryptor.encrypt(string: json!)
            qrImage.image = generateQRCode(from: encrypted)
        }
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }

    func setReceivedFriendRequest(friendRequest: FriendRequestData) {
        let validator = FriendRequestValidator()
        let valid = validator.validate(friendRequest: friendRequest)
        
        let title = valid ? "Now friends with \(friendRequest.name)" : "Cannot accept friend request"
        var message = valid ? "Friend request valid" : "Friend request timeout"
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        message += " \(formatter.string(from: friendRequest.dateTime))"
        resultTitleLabel.text = title
        resultMessageLabel.text = message
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is QrScannerViewController {
            let vc = segue.destination as! QrScannerViewController
            vc.receiver = self
        }
    }
    
    @IBAction func registerLocal(sender: AnyObject) {
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    
    @IBAction func scheduleLocal(sender: AnyObject) {
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5) as Date
        notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
        notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.shared.scheduleLocalNotification(notification)
        
        
        guard let settings = UIApplication.shared.currentUserNotificationSettings else { return }
        
        if settings.types == [] {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        
    }
    
}

