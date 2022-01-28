//
//  RegisterView.swift
//  StateAndDataFlow
//
//  Created by Alexey Efimov on 26.01.2022.
//

import SwiftUI
import Combine



class TextBindingManager: ObservableObject {
    @Published var textColor : UIColor = ( .green)
    @Published var charCount : String = "0"
    @Published var isDisabled : Bool = true
    @Published var name = "" {
        didSet {
            charCount = String(name.count)
            if name.count > characterLimit {
                textColor = .green
                isDisabled = false
            } else {
                textColor = .red
                isDisabled = true
            }
           //print ("\(textColor) , \(charCount)")
        }
    }
    let characterLimit: Int
    
    init(limit: Int ){
        characterLimit = limit
    }
}


struct RegisterView: View {
    @EnvironmentObject private var userManager: UserManager
    @ObservedObject var textBindingManager = TextBindingManager(limit: 3)
    @AppStorage("username") var username: String = ""
    
    
    
    var body: some View {
        VStack {
            HStack{
                TextField("Enter your name", text: $textBindingManager.name)
                    .multilineTextAlignment(.center)
                
                Text (textBindingManager.charCount).padding(.horizontal)
                    .foregroundColor(Color(textBindingManager.textColor))
                Spacer()
            }
            Button(action: registerUser) {
                HStack {
                    Image(systemName: "checkmark.circle")
                    Text("OK")
                }
            }.disabled(textBindingManager.isDisabled)
        }
    }
    
    private func registerUser() {
        if !textBindingManager.name.isEmpty {
            userManager.name = textBindingManager.name
            userManager.isRegister.toggle()
            username = userManager.name
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
