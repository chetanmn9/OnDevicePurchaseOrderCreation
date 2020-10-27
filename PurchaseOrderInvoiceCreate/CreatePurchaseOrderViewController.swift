//
//  CreatePurchaseOrderViewController.swift
//  PurchaseOrderInvoiceCreate
//
//  Created by Chetan Melkote nagaraj on 29/9/20.
//  Copyright © 2020 Chetan M Nagaraj. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Combine


class CreatePurchaseOrderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var purchaseOrderNumber: UILabel!
    
    @IBOutlet weak var supplierID: UITextField!
    @IBOutlet weak var deliveryDate: UITextField!
    @IBOutlet weak var deliveryNotes: UITextField!
    
    var id: Int = 0
    var poNumber = ""
    var suppliers: [CDSupplierList] = []
    var selectedSupplierID = 0
    var selectedSupplierName = ""
    var selectedSupplierAddress = ""
    
    weak var pickerView: UIPickerView?
    
    var resignationHandler: (() -> Void)?
    
    //Resign keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func createPO(_ sender: Any) {
        
        //let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        for supplier in suppliers {
            
            if supplier.supplierName == supplierID.text {
                selectedSupplierID = Int(supplier.supplierID)
                selectedSupplierName = supplier.supplierName!
                selectedSupplierAddress = supplier.supplierAddress!
            }
        }
        
        createPurchaseOrder(id: id, supplierID: selectedSupplierID, supplierName: selectedSupplierName, supplierAddress: selectedSupplierAddress, purchaseOrderNo: poNumber, deliveryDate: deliveryDate.text!, deliveryNotes: deliveryNotes.text!)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        //dismiss after sign up
        presentingViewController?.dismiss(animated: true)
        
    }
    
    @IBAction func close(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    //Date picker for Customer Date of birth
    private var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar(self)
        
        suppliers = getSupplierList()
        id = getRecordsCount()
        let idWithLeadingZeros = String(format: "%06d", id)
        poNumber = "PONUM" + String(idWithLeadingZeros) // String("PONUM0000\(id)")
        purchaseOrderNumber.text = "PO Number:\n \(poNumber)"
        
        //On view did load ensure the date picker is initialized for date picking
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(CreatePurchaseOrderViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        //UIPICKER
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        supplierID.delegate = self
        deliveryDate.delegate = self
        deliveryNotes.delegate = self
        
        supplierID.inputView = pickerView
        deliveryDate.inputView = datePicker
        self.pickerView = pickerView
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView?.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if supplierID.isFirstResponder {
            //return supplierList.count+1
            return suppliers.count
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if supplierID.isFirstResponder{
            return suppliers[row].supplierName
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if supplierID.isFirstResponder{
            supplierID.text = suppliers[row].supplierName
        }
    }
    //Tapping outside of the textfield resigns the keyboard
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func getRecordsCount() -> Int{
        
        var count: Int?
        let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        if let countContext = container?.viewContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDPurchaseOrder")
            count = try? countContext.count(for: fetchRequest)
        }
        return count!
    }
    
    func createPurchaseOrder(id: Int, supplierID: Int, supplierName: String, supplierAddress: String, purchaseOrderNo: String, deliveryDate: String, deliveryNotes: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let purchaseOrderContext = appDelegate.persistentContainer.viewContext
        
        let purchaseOrder = CDPurchaseOrder(context: purchaseOrderContext)
        purchaseOrder.id = Int32(id + 1)
        purchaseOrder.supplierID = Int32(supplierID)
        purchaseOrder.supplierName = supplierName
        purchaseOrder.supplierAddress = supplierAddress
        purchaseOrder.purchaseOrderNumber = purchaseOrderNo
        purchaseOrder.uploaded = false
        
        purchaseOrder.deliveryDate = deliveryDate
        purchaseOrder.deliveryNote = deliveryNotes
        purchaseOrder.issueDate = NSDate() as Date
        
        do {
            try purchaseOrderContext.save()             //save into database
            print("PO Created")
        }
        catch
        {
            print(error)
        }
    }
    
    func getSupplierList() -> [CDSupplierList] {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let getSupplierContext = appDelegate!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CDSupplierList>(entityName: "CDSupplierList")
        
        let suppliers = (try? getSupplierContext.fetch(fetchRequest)) ?? []
        
        return suppliers
        
    }
    
    //On picking the date, it gets assigned to the field that is set to insert into database and then resigns the date picker
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        deliveryDate.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
