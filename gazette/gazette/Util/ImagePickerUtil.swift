//
//  ImagePickerUtil.swift
//  app
//
//  Created by Alireza Ghias on 5/24/1395 AP.
//  Copyright © 1395 iccima. All rights reserved.
//

import Foundation
import MobileCoreServices
import Photos
import XLActionController
class ImagePickerUtil: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	let imagePicker = UIImagePickerController()
	var onPicSaved: CallBack?
	var onProfileSave: ((String, String) -> ())?
	var vc: UIViewController?
	var sourceView: UIView?
	var maxWidth: CGFloat?
	var maxHeight: CGFloat?
	func showImagePickerOptions(_ vc: UIViewController, showCamera: Bool = true) {
		self.vc = vc
		imagePicker.delegate = self
//		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
//		alertController.popoverPresentationController?.sourceView = sourceView
//		alertController.addAction(UIAlertAction(title: "Camera".localized, style: UIAlertActionStyle.default, handler: { (action) in
//			self.imagePicker.allowsEditing = false
//			self.imagePicker.sourceType = .camera
//			self.imagePicker.modalPresentationStyle = .fullScreen
//			self.imagePicker.popoverPresentationController?.sourceView = vc.view
//			self.imagePicker.mediaTypes = [kUTTypeImage as String]
//			vc.present(self.imagePicker, animated: true, completion: nil)
//		}))
//		alertController.addAction(UIAlertAction(title: "Library".localized, style: UIAlertActionStyle.default, handler: { (action) in
//			self.imagePicker.allowsEditing = false
//			self.imagePicker.sourceType = .photoLibrary
//			self.imagePicker.modalPresentationStyle = .fullScreen
//			self.imagePicker.popoverPresentationController?.sourceView = vc.view
//			self.imagePicker.mediaTypes = [kUTTypeImage as String]
//			vc.present(self.imagePicker, animated: true, completion: nil)
//		}))
//		alertController.addAction(UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.cancel, handler: { (action) in
//		}))
		let alertController = SkypeActionController()		
		alertController.popoverPresentationController?.sourceView = sourceView
		if showCamera {
			alertController.addAction(Action.init("Camera".localized, style: .default, handler: { (action) in
				self.imagePicker.allowsEditing = false
				self.imagePicker.sourceType = .camera
				self.imagePicker.modalPresentationStyle = .fullScreen
				self.imagePicker.popoverPresentationController?.sourceView = vc.view
				self.imagePicker.mediaTypes = [kUTTypeImage as String]
				vc.present(self.imagePicker, animated: true, completion: nil)
			}))
		}
		alertController.addAction(Action.init("Library".localized, style: .default, handler: { (action) in
			self.imagePicker.allowsEditing = false
			self.imagePicker.sourceType = .photoLibrary
			self.imagePicker.modalPresentationStyle = .fullScreen
			self.imagePicker.popoverPresentationController?.sourceView = vc.view
			self.imagePicker.mediaTypes = [kUTTypeImage as String]
			vc.present(self.imagePicker, animated: true, completion: nil)
		}))
		alertController.addAction(Action.init("Cancel".localized, style: .cancel, handler: { (action) in
		}))
		
		vc.present(alertController, animated: true, completion: nil)
	}
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		defer {
			vc?.dismiss(animated: true, completion: nil)
		}
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			let attachData: Data!
			if (maxWidth != nil && maxHeight != nil && (pickedImage.size.height > maxHeight! || pickedImage.size.width > maxWidth!)) {
				attachData = IOSUtil.scaleImage(pickedImage, maxWidth: maxWidth!, maxHeight: maxHeight!).data
			} else {
				attachData = pickedImage.data as Data!
			}
			
			let url: URL!
			var fileName = "image_\(Date().timeIntervalSince1970).jpg"
//			if info[UIImagePickerControllerReferenceURL] != nil {
//				url = info[UIImagePickerControllerReferenceURL] as! URL
//				fileName = url.lastPathComponent
//			}
			fileName = "\(fileName)"
			let bigFileName = "big_\(fileName)"
			
			if attachData != nil {
				let path = IOSUtil.getCache("images", fileName, deleteIfExist: true)
				let bigPath = IOSUtil.getCache("images", bigFileName, deleteIfExist: true)
				if let fileHandle = FileHandle(forWritingAtPath: path) {
					if (onProfileSave != nil) {
						if let bigFileHandle = FileHandle(forWritingAtPath: bigPath) {
							bigFileHandle.write(attachData!)
							bigFileHandle.closeFile()
							if let smallData = IOSUtil.scaleImage(UIImage(data: attachData!)!, maxWidth: 150, maxHeight: 150).data {
								fileHandle.write(smallData)
								fileHandle.closeFile()
								onProfileSave!(path, bigPath)
							}
						}
					} else {
						fileHandle.write(attachData!)
						fileHandle.closeFile()
						onPicSaved?(path)
					}
				} else {
					print("fileHandle is nil")
					return
				}
			} else {
				print("attach data is nil")
				return
			}
			
		}
		
	}
	
}
