
import SwiftUI

struct RequestSelfieView: View {
    @ObservedObject var presenter: MovieListPresenter
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var selectedImage: UIImage?
    @State var isImagePickerDisplay = false
    @State var openVieCamera = false
    
    var body: some View {
        
        VStack {
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 300, height: 300)
            }
            
            Button("Selfie") {
                self.sourceType = .camera
                self.isImagePickerDisplay.toggle()
            }.padding()
        }
        .navigationBarTitle("Demo")
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
        .onChange(of: selectedImage ?? UIImage()) { newValue in
            presenter.image = newValue
        }
    }
}
