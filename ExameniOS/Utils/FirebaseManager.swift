import Foundation
import Firebase
import CoreLocation
import FirebaseCore
import FirebaseStorage

class FirebaseManager {
    func sendLocation(location: CLLocationCoordinate2D) {
        let ref = Database.database().reference()
        ref.child("Locations").childByAutoId().setValue([
            "lat": String(location.latitude),
            "lon": String(location.longitude)
        ])
    }
    
    func sendImage(name: String, data: Data) {
        let storage = Storage.storage()

        let riversRef = storage.reference().child(name + ".jpg")

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
    }
}
