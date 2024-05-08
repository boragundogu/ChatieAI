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
    
    @AppStorage("darkMode") var isDarkMode: Bool = false
    @State var textInput = ""
    @State var logoAnimating = false
    @State var timer: Timer?
    @State var chatMessages = ChatMessages()
    @State private var isExampleShow: Bool = false
    
    struct Suggestions {
        let title: String
        let subTitle: String
        
    }
    
    var example = [
        Suggestions(title: "Write an email", subTitle: "to companies for internship"),
        Suggestions(title: "Test my math knowledge", subTitle: "for universitiy degree"),
        Suggestions(title: "Plan a summer holiday", subTitle: "with my friends"),
        Suggestions(title: "Give me ideas", subTitle: "for app development"),
        Suggestions(title: "Help me pick", subTitle: "an outfit for date")
    ]
    
    var body: some View {
        NavigationView {
            VStack{
                ScrollViewReader(content: { proxy in
                    ScrollView{
                        ForEach(chatMessages.messages) { msg in
                            messageView(msg)
                            
                        }
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    .scrollIndicators(.hidden)
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
                
                VStack(alignment: .leading) {
                    ScrollView(.horizontal){
                        if isExampleShow == false {
                            HStack {
                                ForEach(example, id:\.title) { txt in
                                    VStack {
                                        Button(action: {
                                            isExampleShow.toggle()
                                            suggestionMessage(sugTitle: txt.title + " " + txt.subTitle)}, label: {
                                            VStack{
                                                Text(txt.title)
                                                    .foregroundStyle(isDarkMode ? .white : .white)
                                                    .font(.system(.headline, design: .default, weight: .bold))
                                                Text(txt.subTitle)
                                                    .foregroundStyle(isDarkMode ? .white : .white)
                                                    .font(.system(.subheadline, design: .default, weight: .light))
                                            }
                                        })
                                    }
                                    .padding()
                                    .background{
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundStyle(isDarkMode ? .gray.opacity(0.4) : .black.opacity(0.6))
                                    }
                                    
                                }
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    .scrollIndicators(.hidden)
                    HStack{
                        TextField("Enter a message", text: $textInput)
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundStyle(isDarkMode ? .gray : .black)
                            .padding(15)
                            .background{
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(isDarkMode ? .gray : .black)
                                    .opacity(0.2)
                            }
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .scaleEffect(1.4)
                                .opacity(textInput == "" ? 0.2 : 1)
                                .foregroundStyle(isDarkMode ? .gray : .black)
                        }
                        .disabled(textInput == "" ? true : false)
                    }
                }
                
            }
            .toolbar {
                if isExampleShow == true {
                    Button(action: {
                        isExampleShow = false
                    }, label: {
                        Image(systemName: "info.square")
                            .foregroundStyle(isDarkMode ? .white : .black)
                    })
                }
                Spacer()
                Button(action: {
                    isDarkMode.toggle()
                }, label: {
                    Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                        .foregroundStyle(isDarkMode ? .white : .black)
                })
            }
            .foregroundStyle(.white)
            .padding()
        }
    }
    
    @ViewBuilder func messageView(_ message: ChatMessage) -> some View {
        MessageDetail(message: message.message, username: message.role == .model ? "ChatieAI" : "Bora", image: message.role == .model ? "ChatieAI" : "Bora")
            .frame(alignment: .leading)
    }
    
    private func sendMessage(){
        chatMessages.sendMessage(textInput)
        textInput = ""
    }
    
    private func suggestionMessage(sugTitle: String){
        chatMessages.sendMessage(sugTitle)
    }
    
    private func startLoadingAnimation(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            logoAnimating.toggle()
        })
    }
    
    private func stopLoadingAnimation(){
        logoAnimating = false
        timer?.invalidate()
        timer = nil
    }
    
    private  func hideKeyboard(){
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    
}

#Preview {
    ContentView()
}
