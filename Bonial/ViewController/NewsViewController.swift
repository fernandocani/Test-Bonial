//
//  NewsViewController.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contentUnavailableView: UIView!
    @IBOutlet weak var btnRefresh: UIButton!
    
    private var viewModel: NewsViewModel
    private var isLoading = false {
        didSet {
            self.collectionView.isHidden = self.viewModel.news.isEmpty
            self.contentUnavailableView.isHidden = !self.viewModel.news.isEmpty
        }
    }
    
    private let itemsBeforeLoadMore: CGFloat = 2
    
    required init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: NewsViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bonial News"
        self.setupCollectionView()
        self.setupSettingsBar()
        self.loadNews()
    }
    
    private func setupCollectionView() {
        self.collectionView.collectionViewLayout = CustomNewsLayout()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: String(describing: NewsCell.self), bundle: nil), forCellWithReuseIdentifier: NewsCell.identifier)
    }
    
    private func setupSettingsBar() {
        let switchServiceButton = UIBarButtonItem(title: "Service", style: .plain, target: self, action: #selector(showServiceSwitchAlert))
        self.navigationItem.rightBarButtonItem = switchServiceButton
    }
    
    @objc private func showServiceSwitchAlert() {
        let actionSheet = UIAlertController(title: "Switch Service", message: "Change between Live and Mock services.\nList will clear.", preferredStyle: .actionSheet)
        
        let liveAction = UIAlertAction(title: "Live", style: .default) { [weak self] _ in
            self?.switchService(to: ServiceLive.shared)
        }
        let mockAction = UIAlertAction(title: "Mock", style: .default) { [weak self] _ in
            self?.switchService(to: ServiceMock.shared)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if self.viewModel.service is ServiceMock {
            actionSheet.addAction(liveAction)
        }
        if self.viewModel.service is ServiceLive {
            actionSheet.addAction(mockAction)
        }
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func switchService(to service: Service) {
        self.viewModel.changeService(service: service)
        self.collectionView.reloadData()
        self.loadNews()
    }
    
    private func loadNews() {
        guard !self.isLoading else { return }
        self.isLoading = true
        
        Task {
            defer {
                self.isLoading = false
            }
            do {
                let startIndex = self.viewModel.news.count
                try await self.viewModel.loadMoreNews()
                let endIndex = self.viewModel.news.count
                let indexPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
                self.collectionView.performBatchUpdates {
                    self.collectionView.insertItems(at: indexPaths)
                }
            } catch let error as NewsError {
                self.showAlert(title: error.errorDescription, message: error.recoverySuggestion)
            } catch {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadNews()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnRefresh(_ sender: UIButton) {
        self.loadNews()
    }
    
}

extension NewsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UICollectionViewCell()
        }
        let item = self.viewModel.news[indexPath.item]
        cell.configure(with: item)
        cell.delegate = self
        return cell
    }
    
}

extension NewsViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height * itemsBeforeLoadMore {
            self.loadNews()
        }
    }
    
}

extension NewsViewController: NewsCellDelegate {
    
    func didTapNewsCell(with url: URL) {
        UIApplication.shared.open(url)
    }
    
}

#if DEBUG
#Preview {
    let service = ServiceMock.shared
    let vm = NewsViewModel(service)
    let vc = NewsViewController(viewModel: vm)
    let nav = UINavigationController(rootViewController: vc)
    return nav
}
#endif
