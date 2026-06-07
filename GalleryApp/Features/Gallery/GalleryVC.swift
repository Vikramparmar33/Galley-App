//
//  GalleryVC.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit
import SkeletonView

class GalleryVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var appBarView: CustomAppBarView!
    @IBOutlet weak var photoCollectionView: UICollectionView!{
        didSet {
            let nib = UINib(nibName: PhotoCell.identifier, bundle: nil)
            photoCollectionView.register(nib, forCellWithReuseIdentifier: PhotoCell.identifier)
            photoCollectionView.delegate = self
            photoCollectionView.dataSource = self
        }
    }
    
    // MARK: - Variables
    private let viewModel = GalleryViewModel()
    let refreshControl = UIRefreshControl()
    private let itemsPerRow: CGFloat = 2
    private let spacing: CGFloat = 10
    private var isSkeletonVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
        bindViewModel()
        viewModel.loadInitialData()
    }
    
    // MARK: - Functions
    private func setupUI() {
        photoCollectionView.isSkeletonable = true

        appBarView.configure(
            title: "Gallery",
            isHideBackButton: true
        )
        
        photoCollectionView.register(
            LoadingFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingFooterView.reuseIdentifier
        )
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(
            self,
            action: #selector(handleRefresh),
            for: .valueChanged
        )

        photoCollectionView.alwaysBounceVertical = true
        photoCollectionView.refreshControl = refreshControl
    }
    
    @objc func handleRefresh() {
        viewModel.refresh()
    }

    // MARK: - Bindings
    private func bindViewModel() {

        viewModel.reloadCollection = { [weak self] in
            guard let self else { return }

            Task { @MainActor in
                self.refreshControl.endRefreshing()
                self.photoCollectionView.reloadData()
            }
        }

        viewModel.showError = { [weak self] message in
            guard let self else { return }

            Task { @MainActor in
                self.refreshControl.endRefreshing()
                self.showErrorToast(message)
            }
        }

        viewModel.showSkeleton = { [weak self] show in
            guard let self else { return }

            Task { @MainActor in
                self.isSkeletonVisible = show

                if show {
                    self.photoCollectionView.showAnimatedGradientSkeleton()
                } else {
                    self.photoCollectionView.hideSkeleton(
                        reloadDataAfter: true,
                        transition: .crossDissolve(0.25)
                    )
                }
            }
        }
    }
    
}

//MARK: - UICollectionView Delegate
extension GalleryVC: UIScrollViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         viewModel.loadNextPageIfNeeded(
             currentIndex: indexPath.item
         )
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.photos[indexPath.item]
        let detailVC = PhotoDetailVC(photo: photo)
        present(detailVC, animated: true)
    }
}

// MARK: - UICollectionView Data Source
extension GalleryVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCell.identifier,
            for: indexPath
        ) as? PhotoCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: viewModel.photos[indexPath.item])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionFooter else {
            return UICollectionReusableView()
        }

        let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: LoadingFooterView.reuseIdentifier,
            for: indexPath
        ) as! LoadingFooterView

        footer.configure(isLoading: viewModel.isLoading)
        return footer
    }
}

// MARK: - UICollectionView Flow Layout
extension GalleryVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {

        let sectionInset: CGFloat = 10

        let totalSpacing = (itemsPerRow - 1) * spacing
        let totalInsets = sectionInset * 2

        let availableWidth = collectionView.bounds.width - totalSpacing - totalInsets

        let width = floor(availableWidth / itemsPerRow)

        return CGSize(width: width, height: width)
    }

    // Vertical gap between rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    // Horizontal gap between items in the same row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {

        return viewModel.isLoading
            ? CGSize(width: collectionView.bounds.width, height: 60)
            : .zero
    }

}

// MARK: - Skeleton Collection View
extension GalleryVC: SkeletonCollectionViewDataSource {

    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return PhotoCell.identifier
    }
}
