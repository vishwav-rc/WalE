//
//  HomeViewController.swift
//  NASA APOD
//
//  Created by Vishwanath Vallamkondi on 29/05/21.
//

import UIKit
import SVProgressHUD

class HomeViewController: BaseViewController {

    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var apodImageView:UIImageView?
    @IBOutlet var descriptionLabel:UILabel?

    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ImageDownloadManager.shared.delegate = self
        self.setDefaultData()
        self.updateUI()
        self.registerNotifications()
    }
    
    deinit {
        self.unregisterNotifications()
    }
    
    private func setDefaultData() {
        self.titleLabel?.text = "Title"
        self.descriptionLabel?.text = "Description"
        self.apodImageView?.image = nil
    }
    
    private func updateUI() {
        SVProgressHUD.show()
        self.viewModel.getAPOD {[weak self] (apod, errorMessage) in
            SVProgressHUD.dismiss()
            guard let wself = self else {
                return
            }
            if let apod = apod {
                wself.updatePictureDetails(apod: apod)
            }
            if let message = errorMessage {
                self?.showAlertWithMessage(message: message)
            }
        }
    }
    
    private func updatePictureDetails(apod:APOD) {
        self.titleLabel?.text = apod.title
        self.descriptionLabel?.text = apod.explanation

        if let image = self.viewModel.getImage() {
            self.apodImageView?.image = image
        } else {
            ImageDownloadManager.shared.downloadImage(urlString: apod.url, name: apod.title)
        }
    }
    
    private func showImage() {
        self.apodImageView?.image = ImageDownloadManager.shared.image
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func willEnterForeground() {
        if self.viewModel.isNewApodAvailable() {
            self.updateUI()
        }
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
