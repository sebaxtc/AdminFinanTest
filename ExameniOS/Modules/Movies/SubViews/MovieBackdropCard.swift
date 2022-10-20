
import SwiftUI

struct MovieBackdropCard: View {
    
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                
                AsyncImage(
                    url: movie.backdropURL,
                    content: { image in
                        image.resizable()
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
            }
            .aspectRatio(16/9, contentMode: .fit)
            .cornerRadius(8)
            .shadow(radius: 4)
            
            Text(movie.title)
        }
        .lineLimit(1)
    }
}
