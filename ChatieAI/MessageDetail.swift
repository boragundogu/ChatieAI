//
//  MessageDetail.swift
//  ChatieAI
//
//  Created by Bora Gündoğu on 2.05.2024.
//

import SwiftUI

struct MessageDetail: View {
    
    @AppStorage("darkMode") var isDarkMode: Bool = false
    @State var message: String
    @State var username: String
    @State var image: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(image)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 45, height: 45)
                .foregroundStyle(isDarkMode ? .gray : .black)
            
            Text(username)
                .bold()
                .foregroundStyle(isDarkMode ? .gray : .black)
                .padding(.bottom, 10)
            Spacer()
        }
        VStack(alignment: .leading){
            HStack {
                Text(message)
                    .foregroundStyle(isDarkMode ? .gray : .black)
                Spacer()
            }
            .padding(.leading, 60)
        }
        .padding(.top, -20)
        
    }
}

#Preview {
    MessageDetail(message: "Example", username: "Bora", image: "Bora")
}
