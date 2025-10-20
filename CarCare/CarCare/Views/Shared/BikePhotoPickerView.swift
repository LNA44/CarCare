//
//  BikePhotoPickerView.swift
//  CarCare
//
//  Created by Ordinateur elena on 20/10/2025.
//

import SwiftUI
import UIKit

struct BikePhotoPickerView: View {
    @Binding var selectedImage: UIImage?
    @State private var showCamera = false
    @State private var showPhotoPicker = false

    var body: some View {
        VStack(spacing: 20) {
            // Affiche la photo uniquement si elle existe
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
            }

            // Bouton pour prendre une photo
            Button(action: { showCamera = true }) {
                Label("Prendre une photo", systemImage: "camera")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("AppPrimaryColor"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // Bouton pour choisir dans la bibliothèque
            Button(action: { showPhotoPicker = true }) {
                Label("Choisir dans la bibliothèque", systemImage: "photo.on.rectangle")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("TextColor"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
        }
        .sheet(isPresented: $showPhotoPicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
    }
}

struct BikePhotoPickerView_Previews: PreviewProvider {
    @State static var previewImage: UIImage? = nil

    static var previews: some View {
        BikePhotoPickerView(selectedImage: $previewImage)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
