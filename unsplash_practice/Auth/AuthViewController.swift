import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    private let showWebViewSegueId = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        setupMainImage()
        setuploginButton()
        
    }
    
    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "auth_screen_logo")
        
        return imageView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.backgroundColor = UIColor.white.cgColor
        
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.ypBlack, for: .normal)
        button.setTitle("Войти", for: .normal)
        
        button.addTarget(self, action: #selector(goToWebVC), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func goToWebVC() {
        let nextViewController = WebViewViewController()
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.delegate = self
        
        self.present(nextViewController, animated: true)
    }
    
    // MARK: UI setup
    
    private func setupMainImage() {
        view.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mainImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            mainImage.heightAnchor.constraint(equalToConstant: 60),
            mainImage.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setuploginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -111),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
