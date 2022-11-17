//
//  WelcomeView.swift
//  Present
//
//  Created by Justin Cabral on 7/3/20.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settings: Settings
    
    @State var showingAdd = false
    @State var showingRandom = false
    @State var showingFavorite = false
    @State var showingPicker = false
    @State var tapCount = 0
    @State var hemisphere = 0
    
    var body: some View {
        ZStack {
            
            Color("backgroundColor").edgesIgnoringSafeArea(.all)
            
            VStack() {
                TitleView()
                    .padding(.all, 20)
                
                Spacer()
                VStack(alignment: .leading) {
                    
                    if showingAdd {
                        InfoView(title: "Day", subTitle: "Change the way you see your day with a meditative experience of dawn, dusk, noon, and night.", imageName: "dayCircleCrop")
                            .transition(.move(edge: .leading))
                    }
                    
                    if showingRandom {
                        InfoView(title: "Moon", subTitle: "Uncover the mysterires of shadow and light with a clockhand that appears dark at every full moon, and light at every new moon.", imageName: "moonCircleCrop")
                            .transition(.move(edge: .leading))
                    }
                    
                    if showingFavorite {
                        InfoView(title: "Year", subTitle: "Discover your own seasons of change with a holistic point of view on the nature of time in a year.", imageName: "yearCircleCrop")
                            .transition(.move(edge: .leading))
                    }
                    
                    
                }.padding()
                
                Spacer()
                Spacer()
                Button(action: {
                    
                    self.tapCount += 1
                    
                    withAnimation {
                        
                        if self.tapCount == 1 {
                            self.showingAdd.toggle()
                        }
                        
                        if self.tapCount == 2 {
                            self.showingRandom.toggle()
                        }
                        
                        if self.tapCount == 3 {
                            self.showingFavorite.toggle()
                        }

                        if self.tapCount == 4 {
                            self.tapCount = 0
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }) {
                    
                    Text(self.tapCount == 3 ? "Done" : "Continue")
                        .padding()
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(Color.purple))
                        .animation(.default)
                }
                .shadow(radius: 3)
                
            }
            .padding(.horizontal)
            .animation(.spring())
        }
    }
}

struct TitleView: View {
    
    var body: some View {
        VStack {
            Image("icon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, alignment: .center)
            
            Text("The Present")
                .customStyleText()
            
            Text("Day Moon Year")
                .customStyleText()
                .foregroundColor(.purple)
        }
    }
}

struct InfoView: View {
    
    var title: String
    var subTitle: String
    var imageName: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(imageName)
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
                .font(.largeTitle)
                .foregroundColor(.purple)
                .padding()
                .accessibility(hidden: true)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)
                
                Text(subTitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top)
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .foregroundColor(.white)
        .font(.headline)
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(Color.purple))
        
    }
}

extension View {
    func customButton() -> ModifiedContent<Self, ButtonModifier> {
        return modifier(ButtonModifier())
    }
}

extension Text {
    func customStyleText() -> Text {
        self
        .fontWeight(.black)
        .font(.system(size: 36))
    }
}

extension Color {
    static var testColor = Color(UIColor.systemIndigo)
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
