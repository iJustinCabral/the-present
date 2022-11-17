//
//  TodayView.swift
//  Present
//
//  Created by Justin Cabral on 6/30/20.
//

import SwiftUI
import Combine

struct TodayView: View {
    
    @EnvironmentObject var settings: Settings
    
    @State private var isShowing = false
    @State private var now: String = ""
    @State private var activeSheet: ActiveSheet? = nil
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    private var currentTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let hourString = formatter.string(from: Date())
        
        return hourString
    }
    
    private var timeString: String {
        
        switch currentTime {
        case "12:00 AM":
            return "Midnight"
        case "06:00 AM":
            return "Dawn"
        case "12:00 PM":
            return "Noon"
        case "06:00 PM":
            return "Dusk"
        default:
            return "Time"
        }
    }
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("backgroundColor").edgesIgnoringSafeArea(.all)
                VStack {
                    TodayClock()
                        .padding(.all, 10)
                    
                    Text(timeString)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(now)
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding(.all, 10)
                        .onAppear {
                            self.now = currentTime
                        }

                }
                .padding(.bottom, 10)

            }
            .navigationTitle("The Present - Day")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: { activeSheet = .dayDetail }, label: {
                Image(systemName: "questionmark")
                    .padding(.all, 10)
                    .foregroundColor(.purple)
            }))
            .onAppear(perform: checkFirstLaunch)
            .sheet(item: $activeSheet) { item in
                switch item {
                case .welcome:
                    WelcomeView()
                        .environmentObject(settings)
                case .dayDetail:
                    TodayDetail()
                default:
                    WelcomeView()
                        .environmentObject(settings)
                }
            }
            .onReceive(timer) { _ in
                self.now = currentTime
            }
        }
    }
    
    private func checkFirstLaunch() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.setValue(true, forKey: "didLaunchBefore")
            activeSheet = .welcome
            settings.setHemisphere(.northern)
        }
    }
    
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            
            
    }
}
