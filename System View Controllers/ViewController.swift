//
//  ViewController.swift
//  System View Controllers
//
//  Created by Николай Никитин on 15.11.2021.
//

import SafariServices
import UIKit
import MessageUI

class ViewController: UIViewController {

  //MARK: - Outlets
  @IBOutlet var stackView: UIStackView!
  @IBOutlet var imageView: UIImageView!

  //MARK: - UIViewController Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI(with: view.bounds.size)
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    updateUI(with: size)
  }


//MARK: - UI Methods
  func updateUI(with size: CGSize){
    let isVertical = size.width < size.height
    stackView.axis = isVertical ? .vertical : .horizontal
  }


  //MARK: - Actions
  @IBAction func shareButtonPressed(_ sender: UIButton) {
    guard let image = imageView.image else { return }
    let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    activityController.popoverPresentationController?.sourceView = sender
    present(activityController, animated: true)
  }

  @IBAction func safaryButtonPressed(_ sender: UIButton) {
let url = URL(string: "http://apple.com")!
let safary = SFSafariViewController(url: url)
present(safary, animated: true)
  }

  @IBAction func cameraButtonPressed(_ sender: UIButton) {
    let alert = UIAlertController(title: "Please, choose image souse", message: nil, preferredStyle: .actionSheet)
let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(cancelAction)

    if UIImagePickerController.isSourceTypeAvailable(.camera){
      let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true)
      }
      alert.addAction(cameraAction)
    }

    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
      let photoLibraryAction = UIAlertAction(title: "PhotoLibrary", style: .default) { action in
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
      }
      alert.addAction(photoLibraryAction)
    }
    alert.popoverPresentationController?.sourceView = sender
    present(alert, animated: true)
  }

  @IBAction func emailButtonPressed(_ sender: UIButton) {
    guard MFMailComposeViewController.canSendMail() else {
      print ("Mail services are not available.")
       return
    }
let mailComposer = MFMailComposeViewController()
    mailComposer.mailComposeDelegate = self
    mailComposer.setToRecipients(["nikitin.nikolay.v@gmail.com"])
    mailComposer.setSubject("Ошибка \(Date())")
    mailComposer.setMessageBody("The main question of life, the universe and all that.", isHTML: false)
//  TODO: -  mailComposer.addAttachmentData(<#T##attachment: Data##Data#>, mimeType: <#T##String#>, fileName: <#T##String#>)
    present(mailComposer, animated: true)
  }

}

//MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let selectedImage = info[.originalImage] as? UIImage else { return }
    imageView.image = selectedImage
    dismiss(animated: true)
  }
}

//MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {}

// MARK: - MFMailComposeViewControllerDelegat
extension ViewController: MFMailComposeViewControllerDelegate {
  private func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, eroor: Error?){
    dismiss(animated: true)
  }
}
