
import SwiftUI
import Combine

class MovieListPresenter: ObservableObject {
    private let interactor: MovieListInteractor
    private let router = MovieListRouter()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var movies: [Movie] = []
    @Published var nowPlayingState: MovieListInteractor
    @Published var upcomingState: MovieListInteractor
    @Published var topRatedState: MovieListInteractor
    @Published var popularState: MovieListInteractor
    
    init(interactor: MovieListInteractor) {
        self.interactor = interactor
        self.nowPlayingState = interactor
        self.upcomingState = interactor
        self.topRatedState = interactor
        self.popularState = interactor
        self.movies = interactor.movies
        interactor.$movies
            .assign(to: \.movies, on: self)
          .store(in: &cancellables)
    }
    
    func linkBuilder<Content: View>(for movie: Movie, @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(destination: router.makeDetailView(for: movie, model: movie)) {
            content()
        }
    }
}

