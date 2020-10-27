//
//  AddSuppliersForSelectionViewController.swift
//  PurchaseOrderInvoiceCreate
//
//  Created by Chetan Melkote nagaraj on 21/10/20.
//  Copyright © 2020 Chetan M Nagaraj. All rights reserved.
//

import UIKit
import CoreData

class AddSuppliersForSelectionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var itemSupplierName: UITextField!
    @IBOutlet weak var itemSupplierAddress: UITextField!
    @IBOutlet weak var addSupplier: UIButton!
    
    @IBAction func addSupplierForSelection(_ sender: Any) {
        addSuppliersForSelection(supplierName: itemSupplierName.text!, supplierAddress: itemSupplierAddress.text!)
        itemSupplierName.text = nil
        itemSupplierAddress.text = nil
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
        
        itemSupplierName.delegate = self
        itemSupplierAddress.delegate = self
        
        addSupplier.layer.cornerRadius = 10
        addSupplier.clipsToBounds = true
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view.
    }
    
    
    func addSuppliersForSelection(supplierName: String, supplierAddress: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let supplierListContext = appDelegate.persistentContainer.viewContext
        
        let fetchSupplierList = NSFetchRequest<CDSupplierList>(entityName: "CDSupplierList")
        
        let supplierCount = try? supplierListContext.count(for: fetchSupplierList)
        
        let addSuppliersToList = CDSupplierList(context: supplierListContext)
        addSuppliersToList.supplierID = Int32(supplierCount! + 1)
        addSuppliersToList.supplierName = supplierName
        addSuppliersToList.supplierAddress = supplierAddress
        
        do {
            try supplierListContext.save()
            DispatchQueue.main.async {
                notification(message: "Supplier Added\n ✅", viewSender: self.view, window: nil)
            }
        }
        catch {
            print(error)
        }
    }
    
}
