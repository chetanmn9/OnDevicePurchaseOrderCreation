//
//  AddItemsToPOViewController.swift
//  PurchaseOrderInvoiceCreate
//
//  Created by Chetan Melkote nagaraj on 2/10/20.
//  Copyright © 2020 Chetan M Nagaraj. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct purchaseOrderSections {
    var sectionHeading = [String]() 
    var purchaseOrderItems = [itemsInPurchaseOrder]()
}

struct itemsInPurchaseOrder {
    var itemName = String()
    var itemQuantity = Int()
    var itemUnitPrice = Double()
    var itemTotalPrice = Double()
}

class AddItemsToPOViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items: [CDItems] = []
    var tableData = purchaseOrderSections()
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        if section != 4 {
    //            let line = UIView(frame: CGRect(x: 0, y:0, width: tableView.frame.width, height: 2))
    //            line.backgroundColor = .black
    //            return line
    //        }
    //        return nil
    //    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section > 1 && section < tableData.sectionHeading.count {
            let line = UIView(frame: CGRect(x: 0, y:0, width: tableView.frame.width, height: 2))
            line.backgroundColor = .black
            return line
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section > 1 && section < tableData.sectionHeading.count {
            return 3.0
        }
        return 0
    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 2.0
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.sectionHeading.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return items.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = POItemsTableView.dequeueReusableCell(withIdentifier: "Item Cell", for: indexPath)
        let poCell = POItemsTableView.dequeueReusableCell(withIdentifier: "POCell", for: indexPath)
        let supplierCell = POItemsTableView.dequeueReusableCell(withIdentifier: "SupplierCell", for: indexPath)
        let supplierAddressCell = POItemsTableView.dequeueReusableCell(withIdentifier: "SupplierAddressCell", for: indexPath)
        let poTableHeaderCell = POItemsTableView.dequeueReusableCell(withIdentifier: "POTableHeader", for: indexPath)
        let itemsCell = POItemsTableView.dequeueReusableCell(withIdentifier: "ItemsCell", for: indexPath)
        let totalPriceCell = POItemsTableView.dequeueReusableCell(withIdentifier: "TotalPriceCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            if let purchaseOrderNumberCell = poCell as? PONumberTableViewCell {
                purchaseOrderNumberCell.poNumber.text = tableData.sectionHeading[indexPath.section]
            }
            return poCell
        case 1:
            if let supplierNameCell = supplierCell as? SupplierNameTableViewCell {
                supplierNameCell.supplierName.text = tableData.sectionHeading[indexPath.section]
            }
            return supplierCell
        case 2:
            if let suppliersAddressCell = supplierAddressCell as? SupplierAddressTableViewCell {
                suppliersAddressCell.supplierAddress.text = tableData.sectionHeading[indexPath.section]
            }
            return supplierAddressCell
        case 3:
            if let poTableHeadingCell = poTableHeaderCell as? POTableHeaderTableViewCell {
                poTableHeadingCell.itemName.text = "Items"  //= tableData.sectionHeading[indexPath.section]
                poTableHeadingCell.itemQuantity.text = "Quantity"
                poTableHeadingCell.itemUnitPrice.text = "Unit Price"
                poTableHeadingCell.itemPrice.text = "Price"
            }
            return poTableHeaderCell
        case 4:
            
            if tableData.sectionHeading[indexPath.section] == "Items List" {
                if let itemsInCell = itemsCell as? ItemsListTableViewCell {
                    itemsInCell.items.text = tableData.purchaseOrderItems[indexPath.row].itemName.description
                    itemsInCell.quantity.text = tableData.purchaseOrderItems[indexPath.row].itemQuantity.description
                    itemsInCell.unitPrice.text = (NSString(format: "%.2f", tableData.purchaseOrderItems[indexPath.row].itemUnitPrice) as String)
                    itemsInCell.price.text = (NSString(format: "%.2f", tableData.purchaseOrderItems[indexPath.row].itemTotalPrice) as String)
                }
            }
            return itemsCell
        case 5:
            if let priceCell = totalPriceCell as? TotalPriceTableViewCell {
                priceCell.total.text = "Total"
                priceCell.totalPrice.text = tableData.sectionHeading[indexPath.section]
                
            }
            
            return totalPriceCell
        default:
            return poCell
        }
        
    }
    
    @IBOutlet weak var POItemsTableView: UITableView!
    
    @IBAction func addItem(_ sender: Any) {
        self.performSegue(withIdentifier: "SelectItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SelectItemsForPurchaseOrder {
            destination.poNumber = purchaseOrderItems?.purchaseOrderNumber! ?? "No Po number" //tableData.sectionHeading[0]
        }
    }
    
    var purchaseOrderItems: CDPurchaseOrder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTable), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        
        POItemsTableView.separatorColor = UIColor.white
        POItemsTableView.delegate = self
        POItemsTableView.dataSource = self
        
        tableData = addItemsToPurchaseOrder(poNumber: purchaseOrderItems?.purchaseOrderNumber ?? "no PO")
    }
    
    @objc func refreshTable() {
        tableData = addItemsToPurchaseOrder(poNumber: purchaseOrderItems?.purchaseOrderNumber ?? "no PO")
        POItemsTableView.reloadData()
    }
    
    func addItemsToPurchaseOrder(poNumber: String) -> purchaseOrderSections {
        
        var purchaseOrderSectionHeaders = purchaseOrderSections()
        var purchaseOrderItem = itemsInPurchaseOrder()
        var poTotal = 0.0
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate //else { return }
        let updatePurchaseOrderContext = appDelegate!.persistentContainer.viewContext
        
        let fetchPurchaseOrder = NSFetchRequest<CDPurchaseOrder>(entityName: "CDPurchaseOrder")
        fetchPurchaseOrder.predicate = NSPredicate(format: "purchaseOrderNumber = %@", poNumber)
        let currentPurchaseOrder = (try? updatePurchaseOrderContext.fetch(fetchPurchaseOrder)) ?? []
        
        items = fetchItemsForPO(poNumber: poNumber )
        
        if let addItem = currentPurchaseOrder.first {
            
            purchaseOrderSectionHeaders.sectionHeading.append(addItem.purchaseOrderNumber ?? "No PO Number")
            purchaseOrderSectionHeaders.sectionHeading.append(addItem.supplierName ?? "No Supplier Name")
            purchaseOrderSectionHeaders.sectionHeading.append(addItem.supplierAddress ?? "No Supplier Address")
            purchaseOrderSectionHeaders.sectionHeading.append("Table Heading")
            purchaseOrderSectionHeaders.sectionHeading.append("Items List")
            
            for item in items {
                purchaseOrderItem.itemName = item.itemName ?? "No Item Name"
                purchaseOrderItem.itemQuantity = Int(item.quantity)
                purchaseOrderItem.itemUnitPrice = item.unitPrice
                purchaseOrderItem.itemTotalPrice = Double(item.quantity) * item.unitPrice //item.totalPrice
                purchaseOrderSectionHeaders.purchaseOrderItems.append(purchaseOrderItem)
                poTotal += item.totalPrice
            }
            
            
            purchaseOrderSectionHeaders.sectionHeading.append(String(poTotal))
            
            addItem.items = NSSet.init(array: items)
            
            do {
                try updatePurchaseOrderContext.save()             //save into database
            }
            catch
            {
                print(error)
            }
        }
        return purchaseOrderSectionHeaders
    }
    
    func fetchItemsForPO(poNumber: String) -> [CDItems] {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let getItemsContext = appDelegate!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CDItems>(entityName: "CDItems")
        
        fetchRequest.predicate = NSPredicate(format: "itemsToPO.purchaseOrderNumber = %@", poNumber)
        
        let items = (try? getItemsContext.fetch(fetchRequest)) ?? []
        
        return items
    }
}
