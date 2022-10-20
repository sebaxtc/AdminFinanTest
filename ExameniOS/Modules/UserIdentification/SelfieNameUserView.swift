
import SwiftUI

struct SelfieNameUserView: View {
    @ObservedObject var presenter: MovieListPresenter
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            UsernameViewCell(presenter: presenter)
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, 60)
                .padding(.trailing, 60)
                        
            RequestSelfieView(presenter: presenter)
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, 60)
                .padding(.trailing, 60)
        }
    }
}
