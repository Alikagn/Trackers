//
//  StartViewController.swift
//  Tracker
//
//  Created by Dmitry Batorevich on 05.08.2025.
//

import UIKit

// MARK: - StartViewController

final class StartViewController: UIPageViewController {
    
    var onboardingCompletionHandler: (() -> Void)?
    
    // MARK: Private Property
    
    private lazy var pages: [StartPageViewController] = [
        StartPageViewController(
            backgroundName: "backgroundBlueImage",
            startLabel: "Отслеживайте только то, что хотите"
        ),
        StartPageViewController(
            backgroundName: "backgroundPinkImage",
            startLabel: "Даже если это \n не литры воды и йога"
        )
    ]
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Constructor
    
    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey : Any]? = nil
    ) {
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: navigationOrientation,
            options: options
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupControllers()
    }
}

// MARK: - Private Methods

private extension StartViewController {
    
    func setupControllers() {
        dataSource = self
        delegate = self
        
        guard let firstViewController = pages.first else {
            return
        }
        setViewControllers(
            [firstViewController],
            direction: .forward,
            animated: true,
            completion: nil
        )
    }
    
    @objc func handleChangeCurrentPage() {
        let currentPage = ui.pageControl.currentPage
        setViewControllers(
            [pages[currentPage]],
            direction: .forward,
            animated: true,
            completion: nil
        )
    }
    
    @objc func didTapStartButton() {
        onboardingCompletionHandler?()
    }
}

// MARK: - UIPageViewControllerDataSource

extension StartViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        
        guard let viewController = viewController as? StartPageViewController,
              let viewControllerIndex = pages.firstIndex(of: viewController)
        else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= .zero else {
            return pages.last
        }
        return pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        
        guard let viewController = viewController as? StartPageViewController,
              let viewControllerIndex = pages.firstIndex(of: viewController)
        else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return pages.first
        }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension StartViewController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        
        if let currentViewController = pageViewController.viewControllers?.first as? StartPageViewController,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            ui.pageControl.currentPage = currentIndex
        }
    }
}

// MARK: - UI Configuring

private extension StartViewController {
    
    // MARK: UI components
    
    struct UI {
        let pageControl: UIPageControl
        let startButton: UIButton
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypBlack.withAlphaComponent(0.3)
        pageControl.currentPage = .zero
        pageControl.numberOfPages = pages.count
        pageControl.addTarget(
            self,
            action: #selector(handleChangeCurrentPage),
            for: .valueChanged
        )
        view.addSubview(pageControl)
        
        let startButton = UIButton(type: .system)
        startButton.layer.cornerRadius = 16
        startButton.setTitle("Вот это технологии!", for: .normal)
        startButton.backgroundColor = .ypBlack
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.tintColor = .ypWhite
        startButton.addTarget(
            self,
            action: #selector(didTapStartButton),
            for: .touchUpInside
        )
        view.addSubview(startButton)
        
        return .init(
            pageControl: pageControl,
            startButton: startButton
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate( [
            
            ui.pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ui.pageControl.bottomAnchor.constraint(equalTo: ui.startButton.topAnchor, constant: -24),
            
            ui.startButton.widthAnchor.constraint(equalToConstant: 335),
            ui.startButton.heightAnchor.constraint(equalToConstant: 60),
            ui.startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ui.startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ui.startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    func setupUI() {
        view.backgroundColor = .ypWhite
        print(ui.startButton.currentAttributedTitle?.string ?? String())
    }
}

// MARK: - Constants

private extension StartViewController {
    
    // MARK: FontsConstants
    
    enum FontConstants {
        static let startLabelText: UIFont = UIFont.systemFont(ofSize: 32, weight: .bold)
    }
    
    // MARK: ImageConstants
    
    enum ImageConstants {
        static let backgroundImage = UIImage(named: "backgroundBlueImage")
    }
}
