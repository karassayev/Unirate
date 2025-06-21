//
//  ChatViewController.swift
//  test2
//
//  Created by Dias Karassayev on 4/14/25.
//

import UIKit
import SnapKit
import Moya

class ChatViewController: UIViewController {
    private lazy var geminiService = GeminiService()

    // MARK: - Properties
    
    private lazy var messages: [ChatMessage] = []
    private lazy var provider = MoyaProvider<GeminiAPI>()
    
    // MARK: - UI Components
    
    private lazy var tableView = UITableView()
    private lazy var inputField = UITextField.createTextField(placeholder: "Ask your question...")
    private lazy var sendButton: UIButton = {
        return UIButton.createButton(
            title: "",
            color: UIColor.customGreen,
            textColor: .white,
            action: { [weak self] in
                self?.sendTapped()
            },
            image: UIImage(named: "send")
        )
    }()
    private lazy var iconImage: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(named: "logoAI")
         imageView.contentMode = .scaleAspectFill
         imageView.clipsToBounds = true
         return imageView
     }()
    private lazy var label = UILabel.createLabel(size: 16, color: .black, font: "Poppins-Bold", text: "AI assistant")
    private lazy var label2 = UILabel.createLabel(size: 12, color: .lightGray, font: "Poppins-Bold", text: "chatbot")
    private lazy var inputContainer = UIView()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
}

// MARK: - UI Setup

private extension ChatViewController {
    
    func setupUI() {
        setupViews()
    }
    
    func setupViews() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ChatCell.self, forCellReuseIdentifier: "ChatCell")
        
        view.addSubview(label)
        view.addSubview(label2)
        view.addSubview(iconImage)

                
        view.addSubview(tableView)
        view.addSubview(inputContainer)
    
        inputContainer.addSubview(inputField)
        inputContainer.addSubview(sendButton)
        
        
        
        iconImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(48)
        }
        label.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        label2.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(16)
            make.bottom.equalTo(iconImage.snp.bottom)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(inputContainer.snp.top)
        }
        
        inputContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16).inset(16)
            make.trailing.equalToSuperview().inset(16)  // Ensure it doesn't stretch beyond the edges
            make.bottom.equalToSuperview().inset(30) // Adjust for keyboard
            make.height.equalToSuperview().multipliedBy(0.1)
        }

        inputField.snp.makeConstraints { make in
            make.leading.equalToSuperview()// Ensure proper padding
            make.top.equalToSuperview().offset(8)  // Add some padding from the top
            make.width.equalToSuperview().multipliedBy(0.8)  // Ensure the width is reasonable
            make.height.equalTo(60)
        }

        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(inputField.snp.centerY)  // Align with the input field's top
            make.left.equalTo(inputField.snp.right).offset(16)
            make.height.equalTo(48)
            make.width.equalTo(48)  // Ensure the send button has a fixed width
        }

        let lastSubview = [tableView, inputContainer].last!
        lastSubview.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
    }
    
    @objc func sendTapped() {
        guard let prompt = inputField.text, !prompt.isEmpty else { return }
        
        view.endEditing(true)
        // Add user message
        messages.append(ChatMessage(text: prompt, sender: .user, timestamp: Date()))
        
        // Add "thinking..." Gemini placeholder
        let loading = ChatMessage(text: "AI is thinking...", sender: .gemini, timestamp: Date())
        messages.append(loading)
        
        inputField.text = ""
        tableView.reloadData()
        scrollToBottom()
        
        geminiService.sendPrompt(prompt) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                // Remove "thinking..." message
                if let last = self.messages.last, last.text == "AI is thinking..." {
                    self.messages.removeLast()
                }

                switch result {
                case .success(let reply):
                    self.messages.append(ChatMessage(text: reply, sender: .gemini, timestamp: Date()))
                case .failure(let error):
                    self.messages.append(ChatMessage(text: "Error: \(error.localizedDescription)", sender: .gemini, timestamp: Date()))
                }

                self.tableView.reloadData()
                self.scrollToBottom()
            }
        }

    }
    
    func scrollToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell else {
            return UITableViewCell()
        }

        let message = messages[indexPath.row]
        cell.configure(with: message)
        return cell
    }
}
