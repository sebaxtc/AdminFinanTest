
import SwiftUI

struct MovieDetailView: View {
    
    @ObservedObject var presenter: MovieDetailPresenter

    var body: some View {
        ZStack {
            MovieDetailListView(movie: self.presenter.movie)
        }
        .navigationBarTitle(presenter.movie.title)
        .onAppear {
            self.presenter.loadMovie()
        }
    }
}

struct MovieDetailListView: View {
    
    let movie: Movie
    @State private var selectedTrailer: MovieVideo?
    
    var body: some View {
        List {
            MovieDetailImage(imageURL: self.movie.backdropURL)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            HStack {
                Text(movie.genreText)
                Text("·")
                Text(movie.yearText)
                Text(movie.durationText)
            }
            
            Text(movie.overview)
            HStack {
                if !movie.ratingText.isEmpty {
                    Text(movie.ratingText).foregroundColor(.yellow)
                }
                Text(movie.scoreText)
            }
            
            Divider()
            
            HStack(alignment: .top, spacing: 4) {
                if movie.cast != nil && movie.cast!.count > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Starring").font(.headline)
                        ForEach(self.movie.cast!.prefix(9)) { cast in
                            Text(cast.name)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    
                }
                
                if movie.crew != nil && movie.crew!.count > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        if movie.directors != nil && movie.directors!.count > 0 {
                            Text("Director(s)").font(.headline)
                            ForEach(self.movie.directors!.prefix(2)) { crew in
                                Text(crew.name)
                            }
                        }
                        
                        if movie.producers != nil && movie.producers!.count > 0 {
                            Text("Producer(s)").font(.headline)
                                .padding(.top)
                            ForEach(self.movie.producers!.prefix(2)) { crew in
                                Text(crew.name)
                            }
                        }
                        
                        if movie.screenWriters != nil && movie.screenWriters!.count > 0 {
                            Text("Screenwriter(s)").font(.headline)
                                .padding(.top)
                            ForEach(self.movie.screenWriters!.prefix(2)) { crew in
                                Text(crew.name)
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Divider()
            
            if movie.youtubeTrailers != nil && movie.youtubeTrailers!.count > 0 {
                Text("Trailers").font(.headline)
                
                ForEach(movie.youtubeTrailers!) { trailer in
                    Button(action: {
                        self.selectedTrailer = trailer
                    }) {
                        HStack {
                            Text(trailer.name)
                            Spacer()
                            Image(systemName: "play.circle.fill")
                                .foregroundColor(Color(UIColor.systemBlue))
                        }
                    }
                }
            }
        }
    }
}

struct MovieDetailImage: View {
    
    let imageURL: URL
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.3))
            AsyncImage(
                url: imageURL,
                content: { image in
                    image.resizable()
                },
                placeholder: {
                    ProgressView()
                }
            )
        }
        .aspectRatio(16/9, contentMode: .fit)
    }
}
