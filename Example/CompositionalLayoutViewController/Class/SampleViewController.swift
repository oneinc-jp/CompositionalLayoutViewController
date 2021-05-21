//
//  SampleViewController.swift
//  CompositionalLayoutViewController_Example
//
//  Created by Akira Matsuda on 2021/05/21.
//

import CompositionalLayoutViewController

class SampleViewController: CompositionalLayoutViewController {
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
            autocorrectionType: .no,
            autocapitalizationType: .none,
            contentType: .password
        )
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [
            TextFormSection.form([
                emailFormViewModel,
                passwordFormViewModel
            ]),
            ButtonSection(
                buttonTitle: "Login",
                action: .handler { [unowned self] in
                    print("Login button pressed \(String(describing: emailFormViewModel.text)):\(String(describing: passwordFormViewModel.text))")
                }
            )
        ]
        reloadSections()
    }

    override func layoutConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 17
        return config
    }
}
