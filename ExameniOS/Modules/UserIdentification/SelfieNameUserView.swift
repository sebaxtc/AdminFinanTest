
import SwiftUI

struct SelfieNameUserView: View {
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            UsernameViewCell()
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, 60)
                .padding(.trailing, 60)
                        
            RequestSelfieView()
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, 60)
                .padding(.trailing, 60)
        }
    }
}
