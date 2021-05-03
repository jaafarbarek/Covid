//
//  ProfileTableViewCell.swift
//  Covid
//
//  Created by Jaafar Barek on 03/05/2021.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(test: TestModel) {
        self.nameLabel.text = test.name ?? "-"
        self.dateLabel.text = test.date ?? "-"
        self.locationLabel.text = test.location ?? "-"
        self.statusLabel.text = test.status ?? "-"
    }
    
}
