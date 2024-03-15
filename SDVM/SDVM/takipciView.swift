import SwiftUI
import MapKit
import Firebase
import FirebaseDatabase

let database = Database.database()
let ref = database.reference(withPath: "location")

// Harita görüntülemek için yapı
struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        uiView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotation(annotation)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
    }
}

// Firebase Realtime Database'den veri çekmek için ViewModel
class LocationViewModel: ObservableObject {
    @Published var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    func fetchLocation() {
        ref.observe(.value) { snapshot in
            if let locationData = snapshot.value as? [String: Double],
               let latitude = locationData["latitude"],
               let longitude = locationData["longitude"] {
                DispatchQueue.main.async {
                    self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
            }
        }
    }
}

// Ana ekran
struct takipciView: View {
    @StateObject var viewModel = LocationViewModel()
    
    var body: some View {
        VStack {
            MapView(coordinate: viewModel.coordinate)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    viewModel.fetchLocation()
                }
            
            Button("Bul") {
                viewModel.fetchLocation()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            
            Button("Haritalar'da Göster") {
                showInMaps(coordinate: viewModel.coordinate)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
    func showInMaps(coordinate: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Hedef Konum"
        mapItem.openInMaps()
    }
}

struct takipciView_Previews: PreviewProvider {
    static var previews: some View {
        takipciView()
    }
}
