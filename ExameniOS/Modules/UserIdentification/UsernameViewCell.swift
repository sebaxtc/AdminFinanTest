
import SwiftUI

struct UsernameViewCell: View {
    @State var name: String = ""
    
    var body: some View {
        TextField("Nombre", text: $name)
    }
}

struct UsernameViewCell_Previews: PreviewProvider {
    static var previews: some View {
        UsernameViewCell()
    }
}
