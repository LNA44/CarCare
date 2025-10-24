//
//  LottieView.swift
//  CarCare
//
//  Created by Ordinateur elena on 20/09/2025.
//

import SwiftUI
import ImageIO

struct AnimationView: UIViewRepresentable {
    let name: String
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let path = Bundle.main.path(forResource: name, ofType: "gif"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let image = UIImage.gif(data: data) {  
            imageView.image = image
        }
        
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) { }
}

extension UIImage {
    static func gif(data: Data, scale: CGFloat = 0.5) -> UIImage? { // scale = 0.5 pour réduire 50%
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var duration: Double = 0

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let uiImage = UIImage(cgImage: cgImage)
                let newSize = CGSize(width: uiImage.size.width * scale, height: uiImage.size.height * scale)

                UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
                uiImage.draw(in: CGRect(origin: .zero, size: newSize))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                if let resizedImage = resizedImage {
                    images.append(resizedImage)
                }

                let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [CFString: Any]
                let gifInfo = properties?[kCGImagePropertyGIFDictionary] as? [CFString: Any]
                let frameDuration = gifInfo?[kCGImagePropertyGIFUnclampedDelayTime] as? Double
                    ?? gifInfo?[kCGImagePropertyGIFDelayTime] as? Double
                    ?? 0.1
                duration += frameDuration
            }
        }

        return UIImage.animatedImage(with: images, duration: duration)
    }
}
