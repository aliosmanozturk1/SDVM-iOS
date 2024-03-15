import SwiftUI

struct cevirmenView: View {
    var body: some View {
        VStack {
            Text("Merhaba uygulamamıza hoş geldiniz.")
                .fontWeight(.heavy)
                .font(.largeTitle)
                .padding()
            
            Text("Çevirmen olarak kaydınız tamamlanmıştır.")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                
            Text("Artık engelli bireyler ile numaranız paylaşılmıştır. Engelli bireyler Whatsapp üzerinden sizlere ulaşabilecektir.")
                .fontWeight(.semibold)
                .font(.title3)
                .padding()
        }
        .multilineTextAlignment(.center)
        .padding(.all)
    }
}

#Preview {
    cevirmenView()
}
