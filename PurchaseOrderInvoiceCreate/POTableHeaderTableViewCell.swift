//
//  POTableHeaderTableViewCell.swift
//  PurchaseOrderInvoiceCreate
//
//  Created by Chetan Melkote nagaraj on 17/10/20.
//  Copyright © 2020 Chetan M Nagaraj. All rights reserved.
//

import UIKit

class POTableHeaderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var itemUnitPrice: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
