import SwiftUI

struct RegisterView: View {
    
    @StateObject private var viewModel = RegistrationViewModelImpl(
        service: RegistrationServiceImpl()
    )
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 32) {
                
                VStack(spacing: 16) {
                    
                    InputTextFieldView(text: $viewModel.newUser.email,
                                       placeholder: "Email",
                                       keyboardType: .emailAddress,
                                       systemImage: "envelope")
                    
                    InputPasswordView(password: $viewModel.newUser.password,
                                      placeholder: "Şifre",
                                      systemImage: "lock")
                    
                    Divider()
                    
                    InputTextFieldView(text: $viewModel.newUser.firstName,
                                       placeholder: "Ad",
                                       keyboardType: .namePhonePad,
                                       systemImage: nil)
                    
                    InputTextFieldView(text: $viewModel.newUser.lastName,
                                       placeholder: "Soyad",
                                       keyboardType: .namePhonePad,
                                       systemImage: nil)
                    
                    InputTextFieldView(text: $viewModel.newUser.occupation,
                                       placeholder: "Telefon (Başına 0 koyunuz.)",
                                       keyboardType: .phonePad,
                                       systemImage: nil)
                    
                    Picker("Gender", selection: $viewModel.newUser.gender) {
                        ForEach(Gender.allCases) { item in
                            Text(item.rawValue)
                        }
                    }
                    
                    Picker("Types", selection: $viewModel.newUser.types) {
                        ForEach(Types.allCases) { item in
                            Text(item.rawValue)
                        }
                    }
                }
                
                ButtonView(title: "Giriş Yap") {
                    viewModel.create()
                }
            }
            .padding(.horizontal, 15)
            .navigationTitle("Kayıt Ol")
            .applyClose()
            .alert(isPresented: $viewModel.hasError,
                   content: {
                    
                    if case .failed(let error) = viewModel.state {
                        return Alert(
                            title: Text("Error"),
                            message: Text(error.localizedDescription))
                    } else {
                        return Alert(
                            title: Text("Error"),
                            message: Text("Something went wrong"))
                    }
            })
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
            RegisterView()
    }
}
