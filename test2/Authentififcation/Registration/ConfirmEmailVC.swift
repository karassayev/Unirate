import UIKit
import Moya

class ConfirmEmailVC: UIViewController, EmailConfirmationViewDelegate {
    
    private var emailConfirmationView: ConfirmEmailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Initialize the custom view
        emailConfirmationView = ConfirmEmailView(
            title: "Confirm Your Email",
            description: "We’ve sent a verification code to your email. Please enter it below.",
            instruction: "Enter the code",
            resendText: "Resend code"
        )
        
        // Set the delegate to self
        emailConfirmationView.delegate = self
        
        // Add custom view to the view controller
        view.addSubview(emailConfirmationView)
        emailConfirmationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - EmailConfirmationViewDelegate
    
    func didTapConfirmButton(withCode code: Int) {
        // Print the received code for debugging purposes
        print("Received code: \(code)")

        // Call the AuthService to activate the account
        AuthService.shared.activateAccount(code: code) { result in
            switch result {
            case .success(let message):
                // On success, log the activation message and show feedback to the user
                print("Activation successful: \(message)")
                self.showAlert(message: message, isSuccess: true)
            case .failure(let error):
                print("Activation failed: \(error.localizedDescription)")
                if let errorData = error as? MoyaError {
                    // If it's a Moya error, print the response data
                    print("Response data: \(String(data: errorData.response?.data ?? Data(), encoding: .utf8) ?? "No data")")
                }
                self.showAlert(message: error.localizedDescription, isSuccess: false)
            }
        }
    }


    // Helper method to show alerts to the user
    private func showAlert(message: String, isSuccess: Bool) {
        let alert = UIAlertController(title: isSuccess ? "Success" : "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

}
