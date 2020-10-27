//
//  NotificationView.swift
//  PurchaseOrderInvoiceCreate
//
//  Created by Chetan Melkote nagaraj on 27/10/20.
//  Copyright © 2020 Chetan M Nagaraj. All rights reserved.
//

import Foundation
import UIKit

func notification(message: String, viewSender: UIView, window: UIWindow?) {
    
    DispatchQueue.main.async {
        let center = CGPoint(x: 0 + viewSender.center.x, y: viewSender.center.y - 90)
        let uploadedNotification = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        uploadedNotification.layer.cornerRadius = 10
        uploadedNotification.clipsToBounds = true
        uploadedNotification.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        uploadedNotification.center = center
        
        let notificationBackground = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        notificationBackground.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        notificationBackground.center = center
        
        let uploadLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        uploadLabel.center = center
        uploadLabel.textAlignment = .center
        uploadLabel.text = message
        uploadLabel.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        uploadLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        uploadLabel.numberOfLines = 0
        
        if let windowIsAvailable = window {
            windowIsAvailable.addSubview(notificationBackground)
            windowIsAvailable.addSubview(uploadedNotification)
            windowIsAvailable.addSubview(uploadLabel)
        } else {
            viewSender.addSubview(notificationBackground)
            viewSender.addSubview(uploadedNotification)
            viewSender.addSubview(uploadLabel)
        }
        UIView.animate(withDuration: 0, animations: {
            let bound = CGRect(x: 0, y: 0, width: 400, height: 820)
            notificationBackground.frame = bound
            uploadedNotification.frame = CGRect(x: 0, y: 0, width: 220, height: 100)
            uploadLabel.frame = CGRect(x: 0, y: 0, width: 220, height: 75)
            uploadLabel.center = center
            uploadedNotification.center = center
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
            
        }, completion: { done in
            if done {
                sleep(2)
                UIView.animate(withDuration: 0, animations: {
                    let bound = CGRect(x: 0, y: 0, width: 0, height: 0)
                    notificationBackground.frame = bound
                    uploadedNotification.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                    uploadLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                    uploadLabel.center = center
                    uploadedNotification.center = center
                }
                    
                )
            }
        })
    }
}
