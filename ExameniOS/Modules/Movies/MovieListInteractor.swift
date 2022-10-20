
import Foundation
import SwiftUI

class MovieListInteractor {
    @Published var movies: [Movie]
    @Published var isLoading: Bool = false
    @Published var error: NSError?

    private let movieService: MovieService
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
        self.movies = []
    }
    
    func loadMovies(with endpoint: MovieListEndpoint) {
        self.movies = []
        self.isLoading = true
        self.movieService.fetchMovies(from: endpoint) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.movies = response.results
                
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
    func sendSelfie(name: String, image: UIImage) {
        let manager = FirebaseManager()
        var fileName = name
        if name.isEmpty {
            let timestamp = NSDate().timeIntervalSince1970
            fileName = String(timestamp)
        }
        
        let targetSize = CGSize(width: 800, height: 800)

        let scaledImage = image.scalePreservingAspectRatio(
            targetSize: targetSize
        )
        
        manager.sendImage(name: fileName, data: scaledImage.pngData() ?? Data())
    }
}
