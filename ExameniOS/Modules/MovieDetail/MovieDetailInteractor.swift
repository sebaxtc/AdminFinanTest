
import Foundation
class MovieDetailInteractor {
    private let movieService: MovieService
    @Published var movie: Movie
    @Published var isLoading = false
    @Published var error: NSError?
    
    init(movieService: MovieService = MovieStore.shared, movie: Movie) {
        self.movieService = movieService
        self.movie = movie
    }
    
    func loadMovie(id: Int) {
        self.movie = Movie(id: 0, title: "", backdropPath: "", posterPath: "", overview: "", voteAverage: 0.0, voteCount: 0, runtime: 0, releaseDate: "", genres: [], credits: MovieCredit(cast: [], crew: []), videos: MovieVideoResponse(results: []))
        self.isLoading = false
        self.movieService.fetchMovie(id: id) {[weak self] (result) in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let movie):
                self.movie = movie
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
