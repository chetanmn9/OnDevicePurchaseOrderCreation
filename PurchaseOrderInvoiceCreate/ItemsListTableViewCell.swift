//
//  ItemsListTableViewCell.swift
//  PurchaseOrderInvoiceCreate
//
//  Created by Chetan Melkote nagaraj on 17/10/20.
//  Copyright © 2020 Chetan M Nagaraj. All rights reserved.
//

import UIKit

class ItemsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var items: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
