//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 19.06.2025.
//

import UIKit

class StatisticViewController: UIViewController, UICollectionViewDelegate {
    
    private let cellIdentifier = "cell"

    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.black
        label.backgroundColor = Colors.white
        label.text = "Скоро здесь появится статистика..."
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var cometImageView: UIImageView = {
        let profileImage = UIImage(named: "ArrDwn")
        let imageView = UIImageView(image: profileImage)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.white
        self.title = "Статистика"
    
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
        private func setupView() {
            
            [questionLabel, cometImageView].forEach
            {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
            }
            setConstraints()
        }

}

extension StatisticViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            cometImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            cometImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            cometImageView.widthAnchor.constraint(equalToConstant: 80),
            cometImageView.heightAnchor.constraint(equalToConstant: 80),
                questionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                questionLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}
