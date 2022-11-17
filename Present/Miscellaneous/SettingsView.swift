//
//  SettingsView.swift
//  Present
//
//  Created by Justin Cabral on 6/30/20.
//

import SwiftUI
import Combine
import OSLog

final class Settings : ObservableObject {
    
    let hemisphereWillChange = PassthroughSubject<Hemisphere, Never>()
    
    public private(set) var hemisphere: Hemisphere
    public var value = UserDefaults.standard.bool(forKey: "hemisphere")
    private var logger = Logger()
    
    public init() {
        if value == true {
            hemisphere = .northern
        } else {
            hemisphere = .southern
        }
        
    }
    
    func setHemisphere(_ hemisphere: Hemisphere) {
        self.hemisphere = hemisphere
        if hemisphere == .northern {
            UserDefaults.standard.setValue(true, forKey: "hemisphere")
        } else {
            UserDefaults.standard.setValue(false, forKey: "hemisphere")
        }
        self.hemisphereWillChange.send(self.hemisphere)
    }
}

struct SettingsView: View {
    
    @Environment(\.openURL) var openURL
    @EnvironmentObject var settings: Settings
    @State private var hemisphere: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Choose your hemisphere")) {
                    Picker(selection: $hemisphere, label: Text("Hemisphere")) {
                        Text("Northern").tag(0)
                        Text("Southern").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Physical Products")) {
                    HStack {
                        Text("Online Store: ")
                            .font(.headline)
                        Spacer()
                        Button("Visit Day Moon Year") {
                            openURL(URL(string: "https://www.daymoonyear.com")!)
                        }
                        .padding(.all, 10)
                        .background(Color.purple)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                    }
                }
                Section(header: Text("Creator of The Present - Day Moon Year")) {
                    Text("Scott Thrift")
                }
                
                Section(header: Text("App Developed by")) {
                    Text("Justin Cabral")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: checkSettings)
            .onChange(of: hemisphere, perform: { value in
                if hemisphere == 0 {
                    settings.setHemisphere(Hemisphere.northern)
                } else {
                    settings.setHemisphere(Hemisphere.southern)
                }
            })
        }
    }
    
    private func checkSettings() {
        if settings.hemisphere == .northern {
            self.hemisphere = 0
            settings.setHemisphere(Hemisphere.northern)
        } else {
            self.hemisphere = 1
            settings.setHemisphere(Hemisphere.southern)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
