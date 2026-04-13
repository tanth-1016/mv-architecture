import SwiftUI

struct LoginView: View {
    @State private var model: LoginModel

    init(model: LoginModel) {
        _model = State(initialValue: model)
    }

    var body: some View {
        Form {
            Section("Account") {
                TextField("Email", text: $model.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $model.password)
            }

            if let errorMessage = model.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            Section {
                Button {
                    Task { await model.didTapLogin() }
                } label: {
                    if model.isLoading {
                        ProgressView()
                    } else {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(model.isLoading)
            }

            Section("Demo Credentials") {
                LabeledContent("Email", value: "demo@mv.com")
                LabeledContent("Password", value: "123456")
            }
        }
        .navigationTitle("Login")
    }
}
