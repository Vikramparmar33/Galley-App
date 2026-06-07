//
//  GalleryVM.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation
import Kingfisher

class GalleryViewModel {

    private(set) var photos: [Photo] = []

    private let limit = 20
    private var currentPage = 1
    var isLoading = false
    private var hasMorePages = true
    private let paginationThreshold = 6

    private let photoManager = PhotoManager()

    var reloadCollection: (() -> Void)?
    var showError: ((String) -> Void)?
    var showSkeleton: ((Bool) -> Void)?
    
    /// Loads cached photos first, then syncs with the server.
    func loadInitialData() {
        currentPage = 1
        hasMorePages = true

        loadCachedPhotos()
        loadPhotos(reset: true)
    }

    /// Triggered by pull-to-refresh to fetch the latest data.
    func refresh() {
        currentPage = 1
        hasMorePages = true

        loadPhotos(reset: false)
    }

    /// Displays locally cached photos before the network request completes.
    private func loadCachedPhotos() {
        guard photos.isEmpty else { return }
        let cached = photoManager.fetchPhoto()
        guard !cached.isEmpty else { return }
        photos = cached
        reloadCollection?()
    }

    /// Loads the next page when the user scrolls near the end of the list.
    func loadNextPageIfNeeded(currentIndex: Int) {
        guard currentIndex >= photos.count - paginationThreshold else {
            return
        }
        guard !isLoading, hasMorePages else { return }
        loadPhotos(reset: false)
    }

}

// MARK: - Photo Loading
extension GalleryViewModel {
    
    /// Performs photo fetching, pagination, and refresh state management.
    private func loadPhotos(reset: Bool) {

        guard !isLoading else { return }

        if reset {
            showSkeleton?(true)
        }

        isLoading = true

        Task { [weak self] in

            guard let self else { return }

            // Ensure state is restored regardless of success or failure.
            defer {
                self.isLoading = false

                if reset {
                    self.showSkeleton?(false)
                }
            }

            do {

                let fetchedPhotos = try await GalleryService.shared.fetchPhotos(
                    request: GalleryRequest(
                        page: currentPage,
                        limit: limit
                    )
                )

                self.handlePhotoResponse(
                    fetchedPhotos,
                    reset: reset
                )

            } catch {
                self.handleError(error)
            }
        }
    }
    
    private func handlePhotoResponse(_ fetchedPhotos: [Photo], reset: Bool) {

        if reset {
            photos = fetchedPhotos
        } else {
            photos.append(contentsOf: fetchedPhotos)
        }

        // Store API data locally for offline access.
        photoManager.savePhotos(photo: fetchedPhotos)
        
        // Download and cache images for offline viewing.
        let urls = fetchedPhotos.compactMap {
            URL(string: $0.downloadURL)
        }

        ImagePrefetcher(urls: urls).start()

        // No more pages if returned items are less than requested limit.
        hasMorePages = fetchedPhotos.count == limit

        currentPage += 1

        reloadCollection?()
    }
    
    private func handleError(_ error: Error) {
        showError?(error.localizedDescription)
    }
    
}
