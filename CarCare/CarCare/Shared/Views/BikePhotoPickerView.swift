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
    let haptic = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        VStack(spacing: 20) {
            // Affiche la photo uniquement si elle existe
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
            }

            // Bouton pour prendre une photo
            /*Button(action: { showCamera = true }) {
                Label("Prendre une photo", systemImage: "camera")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("AppPrimaryColor"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            }

            // Bouton pour choisir dans la bibliothèque
            Button(action: { showPhotoPicker = true }) {
                Label("Choisir dans la bibliothèque", systemImage: "photo.on.rectangle")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("ButtonColor").opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            }*/
            
            Button(action: {
                haptic.impactOccurred()
                showCamera = true
            }) {
                Label(LocalizedStringKey("take_photo"), systemImage: "camera")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("AppPrimaryColor"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.system(size: 16, weight: .bold, design: .default))
            }
            
            // Bouton pour choisir dans la bibliothèque
            Button(action: {
                haptic.impactOccurred()
                showPhotoPicker = true
            }) {
                Label(LocalizedStringKey("choose_library"), systemImage: "photo.on.rectangle")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("ButtonColor").opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.system(size: 16, weight: .bold, design: .default))
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
