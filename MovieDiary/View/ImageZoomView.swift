//
//  ImageZoomView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import UIKit
import SwiftUI
import PDFKit

//https://stackoverflow.com/a/67577296
struct PhotoDetailView: UIViewRepresentable {
    let image: UIImage
    
    func makeUIView(context: Context) -> PDFView {
        let view =  PDFView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.document = PDFDocument()
        guard let page = PDFPage(image: image) else { return view }
        view.document?.insert(page, at: 0)
        view.autoScales = true
        return view
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        // empty
    }
}

struct ImageZoomView: View {
    @Environment(\.dismiss) var dismiss
    var image: UIImage
    let tintColor: Color
    
    var body: some View {
        PhotoDetailView(image: image)
            .ignoresSafeArea()
            .overlay(BackButton(color: tintColor) { dismiss() }.padding(.leading, -6), alignment: .topLeading)
            .onAppear {
                print("hello")
            }
    }
}
