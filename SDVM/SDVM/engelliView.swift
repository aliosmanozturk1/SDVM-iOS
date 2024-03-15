import SwiftUI
import Firebase

struct User: Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let occupation: String
    let gender: String
    let types: String
}

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    
    init() {
        fetchUsers()
    }
    
    func fetchUsers() {
        let ref = Database.database().reference().child("users")
        
        ref.observe(.value, with: { snapshot in
            var tempList: [User] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let user = snapshot.value as? [String: Any],
                   let firstName = user["firstName"] as? String,
                   let lastName = user["lastName"] as? String,
                   let occupation = user["occupation"] as? String,
                   let gender = user["gender"] as? String,
                   let types = user["types"] as? String,
                   types.contains("Çevirmen") { // Sadece "cevirmen" olan kullanıcıları temsil edenler kullanılıyor.
                    
                    let id = snapshot.key
                    let newUser = User(id: id, firstName: firstName, lastName: lastName, occupation: occupation, gender: gender, types: types)
                    tempList.append(newUser)
                }
            }
            
            DispatchQueue.main.async {
                self.users = tempList
            }
        })
    }
}

struct engelliView: View {
    @ObservedObject var userViewModel = UserViewModel()
    
    var body: some View {
        VStack() {
            Text("Çevirmen Bul")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            ScrollView {
                ForEach(userViewModel.users) { user in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(user.firstName) \(user.lastName)")
                            Text("\(user.occupation)")
                            Text("\(user.gender)")
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            let phoneNumber = user.occupation.replacingOccurrences(of: "tel:", with: "")
                            guard let encodedMessage = "Selamlar, ben Cafer".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                  let url = URL(string: "https://wa.me/9\(phoneNumber)?text=\(encodedMessage)") else { return }
                            UIApplication.shared.open(url)
                        }) {
                            HStack {
                                Image(systemName: "phone.circle")
                                Text("WhatsApp")
                            }
                            .padding(10)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

struct engelliView_Previews: PreviewProvider {
    static var previews: some View {
        engelliView()
    }
}
