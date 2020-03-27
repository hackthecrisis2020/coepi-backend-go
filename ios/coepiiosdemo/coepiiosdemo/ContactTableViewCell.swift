//
//  ViewController.swift
//  coepiiosdemo
//
//  Created by Rodney Witcher on 3/24/20.
//  Copyright © 2020 coepi. All rights reserved.
//
import UIKit

class ContactTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var CENLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
