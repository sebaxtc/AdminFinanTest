import SwiftUI

struct MovieListView: View {
    
    @ObservedObject var presenter: MovieListPresenter
    
    var body: some View {
        NavigationView {
            List {
                
                Group {
                    SelfieNameUserView(presenter: presenter)
                }
                .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                
                Group {
                    MoviePosterCarouselView(presenter: presenter, title: "Now Playing", movies: presenter.nowPlayingState.movies )
                }
                .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                
                Group {
                    MovieBackdropCarouselView(title: "Upcoming", movies: presenter.upcomingState.movies , presenter: presenter)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                
                
                Group {
                    MovieBackdropCarouselView(title: "Top Rated", movies: presenter.topRatedState.movies , presenter: presenter)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                
                Group {
                    MovieBackdropCarouselView(title: "Popular", movies: presenter.popularState.movies , presenter: presenter)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                
                VStack{
                    Button("Enviar") {
                        presenter.sendSelfie()
                    }
                }
                .listRowInsets(EdgeInsets(top: 8, leading: UIScreen.main.bounds.size.width/2 - 60, bottom: 16, trailing: UIScreen.main.bounds.size.width/2 - 60))
            }
            .navigationBarTitle("The MovieDb")
        }
        .onAppear {
            presenter.nowPlayingState.loadMovies(with: .nowPlaying)
            presenter.upcomingState.loadMovies(with: .upcoming)
            presenter.topRatedState.loadMovies(with: .topRated)
            presenter.popularState.loadMovies(with: .popular)
        }
        .onChange(of: presenter.nowPlayingState.movies) { newValue in
            print(newValue.count)
        }
        
    }
}


