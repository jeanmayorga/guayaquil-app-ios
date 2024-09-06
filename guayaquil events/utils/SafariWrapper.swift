//
//  SafariWrapper.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 4/9/24.
//

import SwiftUI
import Foundation
import SafariServices

struct SFSafariViewWrapper: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .overFullScreen  // Asegura que se muestre a pantalla completa
        return safariVC
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
    }
}
