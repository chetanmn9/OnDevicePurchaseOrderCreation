//
//  PurchaseOrderTableViewCell.swift
//  PurchaseOrderInvoiceCreate
//
//  Created by Chetan Melkote nagaraj on 21/10/20.
//  Copyright © 2020 Chetan M Nagaraj. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PurchaseOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var purchaseOrderNumber: UILabel!
    @IBOutlet weak var supplierName: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var uploadStatus: UIButton!
    
    var vc = ViewController()
    
    @IBAction func uploadPurchaseOrder(_ sender: Any) {
        
        print("Upload to Database")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let getPurchaseOrderContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CDPurchaseOrder>(entityName: "CDPurchaseOrder")
        fetchRequest.predicate = NSPredicate(format: "purchaseOrderNumber = %@", purchaseOrderNumber.text!)
        
        let fetchItemsRequest = NSFetchRequest<CDItems>(entityName: "CDItems")
        
        fetchItemsRequest.predicate = NSPredicate(format: "itemsToPO.purchaseOrderNumber = %@", purchaseOrderNumber.text!)
        
        let itemsForPurchaseOrder = (try? getPurchaseOrderContext.fetch(fetchItemsRequest)) ?? []
        
        let purchaseOrderToUpload = (try? getPurchaseOrderContext.fetch(fetchRequest))
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let urlPath = "Your URL"
        
        let url: URL = URL(string: urlPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var purchaseOrderItems = [[ : ]]
        var purchaseOrderHeader = [String : Any]()
        var purchaseOrderItem = [String : Any]()
        var purchaseOrderPost = [String : Any]()
        
        purchaseOrderHeader["zid"] = purchaseOrderToUpload?.first?.id
        purchaseOrderHeader["zpurchase_order_number"] = purchaseOrderToUpload?.first?.purchaseOrderNumber?.description
        purchaseOrderHeader["zissue_date"] = formatter.string(from: (purchaseOrderToUpload?.first?.issueDate)!) //purchaseOrderToUpload?.first?.issueDate
        purchaseOrderHeader["zsupplier_id"] = purchaseOrderToUpload?.first?.supplierID
        purchaseOrderHeader["zsupplier_address"] = purchaseOrderToUpload?.first?.supplierAddress?.description
        purchaseOrderHeader["zsupplier_name"] = purchaseOrderToUpload?.first?.supplierName?.description
        if purchaseOrderToUpload?.first?.uploaded == true {
            purchaseOrderHeader["zuploaded"] = 1
        } else {
            purchaseOrderHeader["zuploaded"] = 0
        }
        purchaseOrderHeader["zdelivery_date"] = purchaseOrderToUpload?.first?.deliveryDate
        purchaseOrderHeader["zdelivery_notes"] = purchaseOrderToUpload?.first?.deliveryNote
        
        for item in itemsForPurchaseOrder {
            print("item=\(item.itemID),\(item.itemName!),\(item.quantity),\(item.unitPrice),\(item.totalPrice),")
            
            purchaseOrderItem["zpurchase_order_number"] = purchaseOrderToUpload?.first?.purchaseOrderNumber
            purchaseOrderItem["zitem_id"] = item.itemID
            purchaseOrderItem["zitem_name"] = item.itemName
            purchaseOrderItem["zitem_quantity"] = item.quantity
            purchaseOrderItem["zitem_unitprice"] = item.unitPrice
            purchaseOrderItem["zitem_totalprice"] = item.totalPrice
            
            purchaseOrderItems.append(purchaseOrderItem)
            
        }
        print(purchaseOrderHeader)
        print (purchaseOrderItems)
        purchaseOrderPost = [ "purchaseOrderHeader" : purchaseOrderHeader, "purchaseOrderItems" : purchaseOrderItems]
        
        //-----------------------------------------------
        var purchaseOrders : NSString = ""
        do {
            let jsonArray = try JSONSerialization.data(withJSONObject: purchaseOrderPost, options: .prettyPrinted)
            let string = NSString(data: jsonArray, encoding: String.Encoding.utf8.rawValue)
            purchaseOrders = string! as NSString
        } catch let error as NSError {
            print(error)
        }
        
        let data = purchaseOrders.data(using: String.Encoding.utf8.rawValue)
        
        do
        {
            let uploadJob = URLSession.shared.uploadTask(with: request, from: data )
            {
                data, response, error in
                
                if error != nil {
                    print(error!)
                }
                else
                {
                    if let unwrappedData = data {
                        
                        let returnedData = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue) // Response from web server hosting the database
                        
                        if returnedData == "1"
                        {
                            purchaseOrderToUpload?.first?.uploaded = true
                            do {
                                try getPurchaseOrderContext.save()             //save into database
                            }
                            catch
                            {
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                notification(message: "\(purchaseOrderToUpload?.first?.purchaseOrderNumber!.description ?? "No PO")\n Uploaded \n ✅", viewSender: self.superview!, window: self.window!)
                            }
                            
                        }
                    }
                    else
                    {
                        print("Ooops... Error in upload...")
                    }
                }
            }
            uploadJob.resume()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        uploadStatus.layer.cornerRadius = 10
        uploadStatus.clipsToBounds = true
    }
    
}
