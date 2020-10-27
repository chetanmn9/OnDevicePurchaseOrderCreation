//
//  SelectItemsForPurchaseOrder.swift
//  PurchaseOrderInvoiceCreate
//
//  Created by Chetan Melkote nagaraj on 13/10/20.
//  Copyright © 2020 Chetan M Nagaraj. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SelectItemsForPurchaseOrder: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var poNumber = ""
    var items: [CDItems] = []
    
    @IBOutlet weak var selectItemLabel: UILabel!
    
    @IBOutlet weak var selectItemForPO: UITextField!
    
    @IBOutlet weak var selectItemQuantity: UITextField!
    
    @IBOutlet weak var addItems: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var itemPopUp: UIView!
    var itemList: [CDItemList] = []
    
    weak var pickerView: UIPickerView?
    
    var resignationHandler: (() -> Void)?
    
    @IBAction func addItemToPO(_ sender: Any) {
        
        var purchaseOrderSectionHeaders = purchaseOrderSections()
        var purchaseOrderItem = itemsInPurchaseOrder()
        var poTotal = 0.0
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate //else { return }
        let updatePurchaseOrderContext = appDelegate!.persistentContainer.viewContext
        
        let fetchPurchaseOrder = NSFetchRequest<CDPurchaseOrder>(entityName: "CDPurchaseOrder")
        let fetchItemList = NSFetchRequest<CDItemList>(entityName: "CDItemList")
        
        fetchPurchaseOrder.predicate = NSPredicate(format: "purchaseOrderNumber = %@", poNumber)
        
        let itemListForSelection = (try? updatePurchaseOrderContext.fetch(fetchItemList)) ?? []
        let currentPurchaseOrder = (try? updatePurchaseOrderContext.fetch(fetchPurchaseOrder)) ?? []
        
        let addItemToPO = CDItems(context: updatePurchaseOrderContext)
        let fetchRequest = NSFetchRequest<CDItems>(entityName: "CDItems")
        
        fetchRequest.predicate = NSPredicate(format: "itemsToPO.purchaseOrderNumber = %@", poNumber)
        
        var items = (try? updatePurchaseOrderContext.fetch(fetchRequest)) ?? []
        
        for item in itemListForSelection {
            if item.itemName == selectItemForPO.text {
                addItemToPO.itemName = selectItemForPO.text
                addItemToPO.quantity = Int32(selectItemQuantity.text!)!
                addItemToPO.itemID = item.itemID
                addItemToPO.lastUpdated = Date()
                addItemToPO.unitPrice = item.unitPrice
                addItemToPO.totalPrice = Double(addItemToPO.quantity) * addItemToPO.unitPrice
            }
        }
        items.append(addItemToPO)
        
        if let addItem = currentPurchaseOrder.first {
            
            purchaseOrderSectionHeaders.sectionHeading.append(addItem.purchaseOrderNumber ?? "No PO Number")
            purchaseOrderSectionHeaders.sectionHeading.append(addItem.supplierName ?? "No Supplier Name")
            purchaseOrderSectionHeaders.sectionHeading.append(addItem.supplierAddress ?? "No Supplier Address")
            purchaseOrderSectionHeaders.sectionHeading.append("Items List")
            
            for item in items {
                purchaseOrderItem.itemName = item.itemName ?? "No Item Name"
                purchaseOrderItem.itemQuantity = Int(item.quantity)
                purchaseOrderItem.itemUnitPrice = item.unitPrice
                purchaseOrderItem.itemTotalPrice = item.totalPrice
                purchaseOrderSectionHeaders.purchaseOrderItems.append(purchaseOrderItem)
                poTotal += item.totalPrice
            }
            
            purchaseOrderSectionHeaders.sectionHeading.append(String(poTotal))
            
            addItem.items = NSSet.init(array: items)
            
            do {
                try updatePurchaseOrderContext.save()             //save into database
                presentingViewController?.dismiss(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
            }
            catch
            {
                print(error)
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    //Resign keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectItemQuantity.delegate = self
        self.selectItemQuantity.keyboardType = .numberPad
        
        itemList = fetchItemsList()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        selectItemForPO.delegate = self
        selectItemForPO.inputView = pickerView
        
        self.pickerView = pickerView
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        self.itemPopUp.layer.cornerRadius = 10
        self.itemPopUp.clipsToBounds = true
        
        self.addItems.layer.cornerRadius = 10
        self.addItems.clipsToBounds = true
        
        self.cancel.layer.cornerRadius = 10
        self.cancel.clipsToBounds = true
        
    }
    
    func fetchItemsList() -> [CDItemList] {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let getItemsContext = appDelegate!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CDItemList>(entityName: "CDItemList")
        
        //fetchRequest.predicate = NSPredicate(format: "itemsToPO.purchaseOrderNumber = %@", poNumber)
        
        let items = (try? getItemsContext.fetch(fetchRequest)) ?? []
        
        return items
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView?.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if selectItemForPO.isFirstResponder{
            return itemList.count
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectItemForPO.isFirstResponder{
            return itemList[row].itemName
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectItemForPO.isFirstResponder{
            selectItemForPO.text = itemList[row].itemName
        }
    }
    
    //Tapping outside of the textfield resigns the keyboard
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
