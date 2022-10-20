
import Foundation
import SwiftUI

class MovieListRouter {
  func makeDetailView(for movie: Movie, model: Movie) -> some View {
    let presenter = MovieDetailPresenter(interactor:
                                            MovieDetailInteractor(movieService: MovieStore.shared, movie: movie))
    return MovieDetailView(presenter: presenter)
  }
}
