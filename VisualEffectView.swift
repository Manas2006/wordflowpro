//
//  VisualEffectView.swift
//  WordFlowPro4
//
//  Created by Manas Pathak on 7/24/23.
//

import SwiftUI

// Helper view to create a translucent background with blur effect
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView()
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}
