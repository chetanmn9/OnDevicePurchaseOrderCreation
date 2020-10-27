//
//  ViewController.swift
//  PurchaseOrderInvoiceCreate
//
//  Created by Chetan Melkote nagaraj on 29/9/20.
//  Copyright © 2020 Chetan M Nagaraj. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        purchaseOrderDetails!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let purchaseOrdercell =  POTableView.dequeueReusableCell(withIdentifier: "PurchaseOrderCell", for: indexPath)
        
        if let purchaseOrderNumberCell = purchaseOrdercell as? PurchaseOrderTableViewCell {
            
            purchaseOrderNumberCell.purchaseOrderNumber.text = self.purchaseOrderDetails![indexPath.row].purchaseOrderNumber
            purchaseOrderNumberCell.supplierName.text = self.purchaseOrderDetails![indexPath.row].supplierName
            purchaseOrderNumberCell.dateCreated.text = "Created on: " + String((self.purchaseOrderDetails![indexPath.row].issueDate?.description.prefix(10))!)
            if self.purchaseOrderDetails![indexPath.row].uploaded == true {
                purchaseOrderNumberCell.uploadStatus.isEnabled = false
                purchaseOrderNumberCell.uploadStatus.setTitle("Uploaded ✅", for: .normal)
                purchaseOrderNumberCell.uploadStatus.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                purchaseOrderNumberCell.uploadStatus.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            } else {
                purchaseOrderNumberCell.uploadStatus.isEnabled = true
                purchaseOrderNumberCell.uploadStatus.titleLabel?.textAlignment = .center
                purchaseOrderNumberCell.uploadStatus.titleLabel?.lineBreakMode = .byWordWrapping
                purchaseOrderNumberCell.uploadStatus.titleLabel?.numberOfLines = 0
                purchaseOrderNumberCell.uploadStatus.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                purchaseOrderNumberCell.uploadStatus.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
                purchaseOrderNumberCell.uploadStatus.setTitle("Upload \n Purchase Order", for: .normal)
                purchaseOrderNumberCell.uploadStatus.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            }
        }
        return purchaseOrdercell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Add Items", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddItemsToPOViewController {
            destination.purchaseOrderItems = purchaseOrderDetails![(POTableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    @IBAction func createPurchaseOrder(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CreatePO", sender: self)
        
    }
    
    @IBOutlet weak var POTableView: UITableView!
    
    var purchaseOrderDetails: [CDPurchaseOrder]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getPurchaseOrders), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        
        POTableView.delegate = self
        POTableView.dataSource = self
        
        getPurchaseOrders()
        
    }
    
    @objc func getPurchaseOrders() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let purchaseOrderContext = appDelegate.persistentContainer.viewContext
        
        //get customer first name after authentication
        do {
            self.purchaseOrderDetails = try purchaseOrderContext.fetch(CDPurchaseOrder.fetchRequest())
            DispatchQueue.main.async {
                self.POTableView.reloadData()   
            }
        } catch {
            print("Failed")
        }
    }
}
