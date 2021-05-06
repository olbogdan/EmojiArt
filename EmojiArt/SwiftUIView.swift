//
//  SwiftUIView.swift
//  EmojiArt
//
//  Created by bogdanov on 06.05.21.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {}

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {}
    }
}
