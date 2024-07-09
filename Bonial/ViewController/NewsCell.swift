//
//  NewsCell.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import UIKit

protocol NewsCellDelegate: AnyObject {
    func didTapNewsCell(with url: URL)
}

class NewsCell: UICollectionViewCell {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblSource: UILabel!

    static let identifier = String(describing: NewsCell.self)
    weak var delegate: NewsCellDelegate?
    private var news: News?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.setupTapGesture()
    }
    
    private func setupUI() {
        self.viewBackground.layer.cornerRadius = 4
        self.viewBackground.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        guard let news, let url = news.url, let delegate else { return }
        delegate.didTapNewsCell(with: url)
    }
    
    func configure(with news: News) {
        self.news = news
        self.lblTitle.text = news.title ?? "-"
        self.lblDescription.text = news.description ?? "-"
        self.lblSource.text = "From: \(news.source?.name ?? "Unknown Source")"
        self.lblTime.text = news.publishedAt?.timeAgoDisplay() ?? "-"
        
        if let urlString = news.urlToImage?.absoluteString, let url = URL(string: urlString) {
            self.imgCover.isHidden = false
            loadImage(from: url)
        } else {
            self.imgCover.isHidden = true
            self.imgCover.image = nil
        }
    }
    
    private func loadImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imgCover.isHidden = false
                    self.imgCover.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.imgCover.isHidden = true
                }
            }
        }
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
