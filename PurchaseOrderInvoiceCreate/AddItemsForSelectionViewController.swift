//
//  AddItemsForSelectionViewController.swift
//  PurchaseOrderInvoiceCreate
//
//  Created by Chetan Melkote nagaraj on 21/10/20.
//  Copyright © 2020 Chetan M Nagaraj. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class AddItemsForSelectionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemUnitPrice: UITextField!
    @IBOutlet weak var addItem: UIButton!
    
    @IBAction func addItemForSelection(_ sender: Any) {
        addItemsForSelection(item: itemName.text!, itemPrice: itemUnitPrice.text!)
        itemName.text = nil
        itemUnitPrice.text = nil
        self.view.endEditing(true)
    }
    
    var resignationHandler: (() -> Void)?
    
    //Resign keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    //Tapping outside of the textfield resigns the keyboard
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar(self)
        
        itemName.delegate = self
        itemUnitPrice.delegate = self
        itemUnitPrice.keyboardType = .numberPad
        
        addItem.layer.cornerRadius = 10
        addItem.clipsToBounds = true
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    func addItemsForSelection(item: String, itemPrice: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let itemListContext = appDelegate.persistentContainer.viewContext
        
        let fetchItemList = NSFetchRequest<CDItemList>(entityName: "CDItemList")
        
        let itemCount = try? itemListContext.count(for: fetchItemList)
        
        let addItemsToList = CDItemList(context: itemListContext)
        addItemsToList.itemID = Int32(itemCount! + 1)
        addItemsToList.itemName = item
        addItemsToList.unitPrice = Double(itemPrice)!
        do {
            try itemListContext.save()
            DispatchQueue.main.async {
                notification(message: "Item Added\n ✅", viewSender: self.view, window: nil)
            }
        }
        catch {
            print(error)
        }
    }
}
