
import SwiftUI

struct ContentView: View {
    @ObservedObject var presenter = MovieListPresenter(interactor:
                                                        MovieListInteractor(movieService: MovieStore.shared))
    
    var body: some View {
        VStack {
            MovieListView(presenter: presenter)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
