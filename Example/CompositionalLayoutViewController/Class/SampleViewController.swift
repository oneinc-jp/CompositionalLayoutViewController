//
//  SampleViewController.swift
//  CompositionalLayoutViewController_Example
//
//  Created by Akira Matsuda on 2021/05/21.
//

import CompositionalLayoutViewController

class SampleViewController: CompositionalLayoutViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [
            TextFormSection(
                items: [
                    .init(
                        initialText: nil,
                        textForm: .init(
                            placeholder: "Email",
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
                    ),
                    .init(
                        initialText: nil,
                        textForm: .init(
                            placeholder: "Password",
                            isSecureTextEntry: true
                        )
                    )
                ]
            ),
            ButtonSection(
                buttonTitle: "Login",
                action: .handler {
                    print("Login button pressed")
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
