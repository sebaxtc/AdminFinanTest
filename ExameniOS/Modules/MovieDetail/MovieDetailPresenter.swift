
import SwiftUI
import Combine

class MovieDetailPresenter: ObservableObject {
  private let interactor: MovieDetailInteractor
  private let router = MovieListRouter()
  
  private var cancellables = Set<AnyCancellable>()
  
  @Published var movie: Movie
  
  init(interactor: MovieDetailInteractor) {
    self.interactor = interactor
      self.movie = interactor.movie
  }
    
    func loadMovie() {
        interactor.loadMovie(id: movie.id)
    }
    
  func linkBuilder<Content: View>(for movie: Movie, @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(destination: router.makeDetailView(for: movie, model: interactor.movie)) {
      content()
    }
  }
}

