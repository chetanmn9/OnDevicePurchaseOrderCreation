//
//  PONumberTableViewCell.swift
//  PurchaseOrderInvoiceCreate
//
//  Created by Chetan Melkote nagaraj on 16/10/20.
//  Copyright © 2020 Chetan M Nagaraj. All rights reserved.
//

import UIKit

class PONumberTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var poNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
