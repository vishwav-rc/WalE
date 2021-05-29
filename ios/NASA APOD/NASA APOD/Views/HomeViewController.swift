//
//  HomeViewController.swift
//  NASA APOD
//
//  Created by Vishwanath Vallamkondi on 29/05/21.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var apodImageView:UIImageView?
    @IBOutlet var descriptionLabel:UILabel?

    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ImageDownloadManager.shared.delegate = self
        self.updateUI()
    }
    
    private func updateUI() {
        self.viewModel.getAPOD {[weak self] (apod, errorMessage) in
            guard let wself = self else {
                return
            }
            if let apod = apod {
                wself.updatePictureDetails(apod: apod)
            } else if let message = errorMessage {
                self?.showAlertWithMessage(message: message)
            }
        }
    }
    
    private func updatePictureDetails(apod:APOD) {
        self.titleLabel?.text = apod.title
        self.descriptionLabel?.text = apod.explanation

        ImageDownloadManager.shared.downloadImage(urlString: apod.url)
    }
    
    private func showImage() {
        self.apodImageView?.image = ImageDownloadManager.shared.image
    }
}

extension HomeViewController : ImageDownloadManagerDelegate {
    func imageDownloadingFailed(message: String) {
        self.showAlertWithMessage(message: "Failed to download the image")
    }
    
    func imageDownloadedSuccessfully() {
        DispatchQueue.main.async {
            self.showImage()
        }
    }
}
