
import SwiftUI

struct MoviePosterCard: View {
    
    let movie: Movie
    var body: some View {
        ZStack {

            AsyncImage(
                url: movie.posterURL,
                content: { image in
                    image.resizable()
                },
                placeholder: {
                    ProgressView()
                }
            )
            
        }
        .frame(width: 204, height: 306)
    }
}

