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
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(_ exhibition: Exhibition, withFetchedImage fetchedImage: @escaping (UIImage?) -> Void) {
        titleLabel.text = exhibition.title
        periodLabel.text = {
            let formatter: DateFormatter = .init()
            formatter.dateFormat = "yyyy.MM.dd"
            let startDate = formatter.string(from: exhibition.startDate)
            let endDate = formatter.string(from: exhibition.endDate)
            return "기간 : \(startDate)~\(endDate)"
        }()
        placeLabel.text = "장소 : \(exhibition.place)"
        descriptionLabel.text = exhibition.description
        
        fetchThumbnailImage(exhibition.thumbnailUrl) { image in
            fetchedImage(image)
        }
    }
    
    func initializeCell() {
        thumbnailImageView.image = UIImage.init(named: "default_thumbnail")
        titleLabel.text = ""
        periodLabel.text = ""
        placeLabel.text = ""
        descriptionLabel.text = ""
    }
    
    func setThumbnailImage(_ thumbnailImage: UIImage?) {
        if let thumbnailImage = thumbnailImage {
            thumbnailImageView.image = thumbnailImage
        } else {
            thumbnailImageView.image = UIImage.init(named: "default_thumbnail")
        }
    }
    
    private func fetchThumbnailImage(_ url: String, completion: @escaping (UIImage?) -> Void) {
        ImageLoader.patch(url) { result in
            switch result {
            case .success(let thumbnailImage):
                completion(thumbnailImage)
            case .failure(let error):
                _ = error
                completion(nil)
            }
        }
    }
}
