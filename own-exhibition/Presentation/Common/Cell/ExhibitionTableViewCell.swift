//
//  ExhibitionTableViewCell.swift
//  own-exhibition
//
//  Created by Jaewon on 2022/10/20.
//

import UIKit

final class ExhibitionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(by exhibition: Exhibition) {
        thumbnailImageView.image = {
            if let imageUrl = URL.init(string: exhibition.thumbnailUrl),
               let imageData = try? Data.init(contentsOf: imageUrl),
               let thumbnail = UIImage.init(data: imageData) {
                return thumbnail
            } else {
                // FIXME: 기본 썸네일 이미지 반환
                return UIImage.init()
            }
        }()
        titleLabel.text = exhibition.title
    }
}
