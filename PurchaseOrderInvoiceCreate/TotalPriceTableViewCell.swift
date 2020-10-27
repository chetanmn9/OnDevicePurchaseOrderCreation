//
//  TotalPriceTableViewCell.swift
//  PurchaseOrderInvoiceCreate
//
//  Created by Chetan Melkote nagaraj on 17/10/20.
//  Copyright © 2020 Chetan M Nagaraj. All rights reserved.
//

import UIKit

class TotalPriceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
