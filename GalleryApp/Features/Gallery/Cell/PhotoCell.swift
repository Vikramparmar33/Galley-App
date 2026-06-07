//
//  PhotoCell.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit
import Kingfisher
import SkeletonView

class PhotoCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Variables
    static let identifier = String(describing: PhotoCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        isSkeletonable = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask() // // Cancel ongoing download
        imageView.image = nil
        hideSkeleton()
    }

    func configure(with photo: Photo) {
        
        // Picsum supports on-the-fly resizing by id. Fetch a thumbnail instead of the full image.
        let side = Int(200 * UIScreen.main.scale)
        
        guard let url = URL(
            string: "https://picsum.photos/id/\(photo.id)/\(side)/\(side)"
        ) else {
            return
        }
        
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "img_placeholder"),
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        ) { [weak self] result in
            guard let self = self else { return }
            //self.handleImageResult(result)
        }
    }
    
    private func handleImageResult(_ result: Result<RetrieveImageResult, KingfisherError>) {
        switch result {

        case .success(let value):

            switch value.cacheType {
            case .memory:
                debugPrint("Image loaded from MEMORY cache")

            case .disk:
                debugPrint("Image loaded from DISK cache")

            case .none:
                debugPrint("Image downloaded from NETWORK")
            }

        case .failure(let error):
            print("Image loading failed:", error.localizedDescription)
        }
    }

}
