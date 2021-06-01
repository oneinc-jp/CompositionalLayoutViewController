//
//  SampleViewController.swift
//  CompositionalLayoutViewController_Example
//
//  Created by Akira Matsuda on 2021/05/21.
//

import Combine
import CompositionalLayoutViewController

struct LoginInfo {
    let email: String
    let password: String
}

class SampleViewController: CompositionalLayoutViewController, SectionProvider {
    private var cancellable = Set<AnyCancellable>()
    private let emailFormViewModel = TextFormViewModel(
        initialText: nil,
        textForm: .init(
            placeholder: "Email",
            keyboardType: .emailAddress,
            autocorrectionType: .no,
            autocapitalizationType: .none,
            contentType: .username,
            validationHandler: { text in
                guard let text = text else {
                    return false
                }
                return text.isValidEmailAddress()
            },
            validationAppearance: .init(
                textColor: .red
            )
        )
    )

    private let passwordFormViewModel = TextFormViewModel(
        initialText: nil,
        textForm: .init(
            placeholder: "Password",
            isSecureTextEntry: true,
            autocorrectionType: .no,
            autocapitalizationType: .none,
            contentType: .password
        )
    )

    private var validateEmail: AnyPublisher<String?, Never> {
        return emailFormViewModel.$text
            .map { email in
                guard let email = email, email.isValidEmailAddress() else {
                    return nil
                }
                return email
            }
            .eraseToAnyPublisher()
    }

    private var validateCredentials: AnyPublisher<LoginInfo?, Never> {
        return Publishers.CombineLatest(validateEmail, passwordFormViewModel.$text)
            .map { email, password in
                guard let email = email,
                      let password = password,
                      !email.isEmpty, !password.isEmpty else {
                    return nil
                }
                return LoginInfo(email: email, password: password)
            }
            .eraseToAnyPublisher()
    }

    var sections = [CollectionViewSection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset.top = 32
        provider = self

        let loginButtonSection = ButtonSection(
            buttonTitle: "Login",
            action: .handler { [unowned self] in
                print("Login button pressed \(String(describing: emailFormViewModel.text)):\(String(describing: passwordFormViewModel.text))")
            }
        )
        loginButtonSection.isEnabled = false
        validateCredentials.map {
            return $0 != nil
        }
        .receive(on: RunLoop.main)
        .assign(to: \.isEnabled, on: loginButtonSection)
        .store(in: &cancellable)

        sections = [
            TextFormSection.form([
                emailFormViewModel,
                passwordFormViewModel
            ]),
            loginButtonSection
        ]
        reloadSections()
    }

    override func layoutConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 17
        return config
    }
}
