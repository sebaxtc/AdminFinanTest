
import Foundation
import SwiftUI

class MovieListRouter {
  func makeDetailView(for movie: Movie, model: Movie) -> some View {
    let presenter = MovieDetailPresenter(interactor:
      MovieDetailInteractor(model: movie))
    return MovieDetailView(presenter: presenter)
  }
}
