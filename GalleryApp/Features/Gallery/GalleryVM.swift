//
//  GalleryVM.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation
import Kingfisher
import UIKit

enum DataMode {
    case online
    case offline
}

class GalleryViewModel {

    // MARK: - Variables
    private(set) var photos: [Photo] = []

    private let limit = 20
    private var currentPage = 1
    var isLoading = false
    private var hasMoreOnlinePages = true
    private var hasMoreOfflinePages = true
    private let paginationThreshold = 6

    private let photoManager = PhotoManager()
    
    private var mode: DataMode {
        return Utility.isInternetAvailable() ? .online : .offline
    }

    // MARK: - Closures
    var reloadCollection: (() -> Void)?
    var showError: ((String) -> Void)?
    var showSkeleton: ((Bool) -> Void)?
    
    /// Loads photos based on current mode (online/offline).
    /// Resets pagination and fetches first page of data.
    func loadData(isInitialLoad: Bool) {
        currentPage = 1
        
        switch mode {
        case .online:
            hasMoreOnlinePages = true
            loadPhotos(isInitialLoad: isInitialLoad, isOnline: true)
            
        case .offline:
            hasMoreOfflinePages = true
            loadPhotos(isInitialLoad: isInitialLoad, isOnline: false)
        }
    
    }

    /// Loads the next page when the user scrolls near the end of the list.
    func loadNextPageIfNeeded(currentIndex: Int) {
        guard currentIndex >= photos.count - paginationThreshold else {
            return
        }
        guard !isLoading else { return }
        
        if Utility.isInternetAvailable() {
            guard hasMoreOnlinePages else { return }
            loadPhotos(isInitialLoad: false, isOnline: true)
        } else {
            guard hasMoreOfflinePages else { return }
            loadPhotos(isInitialLoad: false, isOnline: false)
        }
    }

}

// MARK: - Photo Loading
extension GalleryViewModel {
    
    /// Performs photo fetching, pagination, and refresh state management.
    private func loadPhotos(isInitialLoad: Bool, isOnline: Bool) {
        
        if isOnline {
            fetchFromAPI(isInitialLoad: isInitialLoad)
        } else {
            isLoading = true
            fetchFromCoreData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isLoading = false
            }

        }
       
    }
    
    // MARK: - API Call
    func fetchFromAPI(isInitialLoad: Bool) {

        guard !isLoading else { return }

        if isInitialLoad {
            showSkeleton?(true)
        }

        isLoading = true

        Task { [weak self] in

            guard let self else { return }

            // Ensure state is restored regardless of success or failure.
            defer {
                self.isLoading = false

                if isInitialLoad {
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
                    isInitialLoad: isInitialLoad
                )

            } catch {
                self.handleError(error)
            }
        }
    }
    
    private func handlePhotoResponse(_ fetchedPhotos: [Photo], isInitialLoad: Bool) {

        if isInitialLoad {
            photos = fetchedPhotos
        } else {
            photos.append(contentsOf: fetchedPhotos)
        }
        
        prefetchAndSave(photos: fetchedPhotos)

        // No more pages if returned items are less than requested limit.
        hasMoreOnlinePages = fetchedPhotos.count == limit
        currentPage += 1
        reloadCollection?()
    }
    
    private func handleError(_ error: Error) {
        showError?(error.localizedDescription)
    }
    
    // MARK: - Offline Data
    func fetchFromCoreData() {
        let fetchedPhotos = photoManager.fetchPhotosForPage(page: currentPage)

        guard !fetchedPhotos.isEmpty else {
            hasMoreOfflinePages = false
            reloadCollection?()
            return
        }

        // update data
        photos.append(contentsOf: fetchedPhotos)
        reloadCollection?()
        debugPrint("offline Data Photos ==> \(photos.count)")

        // pagination logic
        hasMoreOfflinePages = fetchedPhotos.count == limit
        currentPage += 1
        
        debugPrint("offline Data Current Page==> \(currentPage)")
        
    }
    
}

// MARK: - Downloads images in advance and persists them locally for offline caching.
extension GalleryViewModel {
    
    private func prefetchAndSave(photos: [Photo]) {

        let group = DispatchGroup()

        var updatedPhotos = photos

        for index in photos.indices {

            guard let url = URL(string: photos[index].downloadURL) else { continue }

            group.enter()

            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    if let imageData = value.image.jpegData(compressionQuality: 0.8) {
                        updatedPhotos[index].imageData = imageData
                        debugPrint("index = \(index) url = \(url) fetched image data")
                    }

                case .failure:
                    break
                }

                group.leave()
            }
        }

        group.notify(queue: .main) {
            // Store API data locally for offline access.
            self.photoManager.savePhotos(photo: updatedPhotos)
            debugPrint("All photo saved in core data")
        }
    }
    
}
