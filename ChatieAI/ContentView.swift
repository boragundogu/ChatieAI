//
//  ContentView.swift
//  ChatieAI
//
//  Created by Bora Gündoğu on 1.05.2024.
//

import SwiftUI

import SwiftUI
import  GoogleGenerativeAI

struct ContentView: View {
    
    
    @State var textInput = ""
    @State var logoAnimating = false
    @State var timer: Timer?
    @State var chatMessages = ChatMessages()
    
    var body: some View {
        VStack{
            
            Image(systemName: "star.bubble")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .animation(.easeInOut, value: logoAnimating)
                .foregroundStyle(.cyan)
            
            ScrollViewReader(content: { proxy in
                ScrollView{
                    ForEach(chatMessages.messages) { msg in
                        messageView(msg)
                    }
                }
                .onChange(of: chatMessages.messages) { _, _ in
                    guard let recentMessage = chatMessages.messages.last else { return}
                    DispatchQueue.main.async {
                        withAnimation{
                            proxy.scrollTo(recentMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: chatMessages.loadingResponse) { _, newValue in
                    if newValue {
                        startLoadingAnimation()
                    } else {
                        stopLoadingAnimation()
                    }
                }
            })
            
            HStack{
                TextField("Enter a message", text: $textInput)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.black)
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .opacity(textInput == "" ? 0.2 : 1)
                }
                .disabled(textInput == "" ? true : false)
            }
            
        }
        .foregroundStyle(.white)
        .padding()
        .background{
            ZStack{
                Color.black.opacity(0.9)
            }
            .ignoresSafeArea()
        }
    }
    
    
    @ViewBuilder func messageView(_ message: ChatMessage) -> some View {
        MessageBubble(direction: message.role == .model ? .left : .right) {
            Text(message.message)
                .font(.title3)
                .padding(.all, 15)
                .foregroundStyle(.white)
                .background(message.role == .model ? Color.blue : Color.green)
        }
    }
    
    func sendMessage(){
        chatMessages.sendMessage(textInput)
        textInput = ""
    }
    
    func startLoadingAnimation(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            logoAnimating.toggle()
        })
    }
    
    func stopLoadingAnimation(){
        logoAnimating = false
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    ContentView()
}
