//
//  SwiftUIView.swift
//  EmojiArt
//
//  Created by bogdanov on 06.05.21.
//

import SwiftUI
import UIKit

typealias PickedImageHandler = (UIImage?) -> Void
struct ImagePicker: UIViewControllerRepresentable {
    var handlePickedImage: PickedImageHandler

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(handlePickedImage: handlePickedImage)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var handlePickedImage: PickedImageHandler

        init(handlePickedImage: @escaping PickedImageHandler) {
            self.handlePickedImage = handlePickedImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let image = info[.originalImage] as? UIImage
            handlePickedImage(image)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            handlePickedImage(nil)
        }
    }
}
