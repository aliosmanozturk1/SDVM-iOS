import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var service: SessionServiceImpl
    
    var body: some View {
            VStack(alignment: .leading,
                   spacing: 16) {
                
                VStack(alignment: .leading,
                       spacing: 16) {
                    Text("Ad: \(service.userDetails?.firstName ?? "N/A")")
                    Text("Soyad: \(service.userDetails?.lastName ?? "N/A")")
                    Text("Telefon: \(service.userDetails?.occupation ?? "N/A")")
                    Text("Cinsiyet: \(service.userDetails?.gender ?? "N/A")")
                }
                
                
                    
                    ButtonView(title: "Hesaptan Çıkış Yap") {
                        service.logout()
                    }
                
            }
            .padding(.horizontal, 16)
            .navigationTitle("Main ContentView")        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
            HomeView()
                .environmentObject(SessionServiceImpl())
    }
}
