
import SwiftUI

struct RequestSelfieView: View {
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
    }
}

struct RequestSelfieView_Previews: PreviewProvider {
    static var previews: some View {
        RequestSelfieView()
    }
}
