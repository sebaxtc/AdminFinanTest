import SwiftUI

struct CameraView: View {
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Binding var isImagePickerDisplay: Bool
    
    var body: some View {
        VStack {
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 300, height: 300)
            } else {
                Image(systemName: "snow")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 300, height: 300)
            }
            
            Button("Camera") {
                self.sourceType = .camera
                self.isImagePickerDisplay.toggle()
            }.padding()
            
            Button("photo") {
                self.sourceType = .photoLibrary
                self.isImagePickerDisplay.toggle()
            }.padding()
        }
        .navigationBarTitle("Demo")
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
    }
}
