//
//  PhotoDetailVC.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit
import Kingfisher

class PhotoDetailVC: UIViewController {

    // MARK: - Variables
    private let photo: Photo
    private var imageTask: Task<Void, Never>?

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let closeButton = UIButton(type: .system)

    // MARK: - Init
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupScrollView()
        setupImageView()
        setupActivityIndicator()
        setupCloseButton()
        loadImage()
    }

    deinit {
        imageTask?.cancel()
    }

    // MARK: - Setup
    private func setupScrollView() {
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
    }

    private func setupImageView() {
        imageView.frame = scrollView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)

        // Double tap se zoom in/out.
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
    }

    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin,
                                              .flexibleLeftMargin, .flexibleRightMargin]
        activityIndicator.color = .white
        view.addSubview(activityIndicator)
    }

    private func setupCloseButton() {
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .white
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    // MARK: - Image Loading
    private func loadImage() {

        guard let url = URL(string: photo.downloadURL) else { return }

        // Pehle se cached thumbnail ho to placeholder ki tarah turant dikha do.
        let side = Int(200 * UIScreen.main.scale)
        let thumbKey = "https://picsum.photos/id/\(photo.id)/\(side)/\(side)"
        let placeholder = ImageCache.default.retrieveImageInMemoryCache(forKey: thumbKey)

        // MARK: Kingfisher — full-res load, fade-in, activity indicator.
        activityIndicator.startAnimating()
        imageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.transition(.fade(0.2))]
        ) { [weak self] _ in
            self?.activityIndicator.stopAnimating()
        }
    }

    // MARK: - Actions
    @objc private func handleClose() {
        dismiss(animated: true)
    }

    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate (Zoom)
extension PhotoDetailVC: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

