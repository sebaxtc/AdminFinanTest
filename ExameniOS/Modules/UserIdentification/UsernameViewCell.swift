
import SwiftUI

struct UsernameViewCell: View {
    @ObservedObject var presenter: MovieListPresenter
    @State var name: String = ""
    
    var body: some View {
        TextField("Nombre", text: $name)
            .onChange(of: name) { newValue in
                presenter.name = newValue
            }
    }
}
