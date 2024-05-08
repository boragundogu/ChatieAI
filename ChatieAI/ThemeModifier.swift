//
//  ThemeModifier.swift
//  ChatieAI
//
//  Created by Bora Gündoğu on 2.05.2024.
//

import SwiftUI


public struct ThemeModifier: ViewModifier {
    
    @AppStorage("darkMode") var isDarkMode: Bool = false
    
    public func body(content: Content) -> some View {
        content
            .environment(\.colorScheme, isDarkMode ? .dark : .light)
            .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    
}
