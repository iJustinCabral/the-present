//
//  MoonView.swift
//  Present
//
//  Created by Justin Cabral on 6/30/20.
//

import SwiftUI

struct MoonView: View {
    
    @EnvironmentObject var settings: Settings
    
    @State private var isShowing = false
    @State private var isNorthernHemisphere = false
    
    private let newMoonDayNumber = 2459051
    
    private var moonPhaseString: String {
        switch calculateMoonPhase() {
        case 0.0...0.9:
            return "New Moon"
        case 1.0...7.09:
            return "Waxing Crescent"
        case 7.1...14.99:
            return "Waxing Gibbous"
        case 15.0...15.09:
            return "Full Moon"
        case 15.1...22.09:
            return "Waning Gibbous"
        case 22.1...29.49:
            return "Waning Crescent"
        case 29.5...29.539:
            return "New Moon"
        default:
            return "Waxing Crescent"
        }
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                Color("backgroundColor").edgesIgnoringSafeArea(.all)
                VStack {
              
                    MoonClock()
                        .padding(.all, 10)

                    Text("Phase")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(moonPhaseString)
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding(.all, 10)
                    
                }
                .padding(.bottom, 10)
            }
            .navigationTitle("The Present - Moon")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: { isShowing.toggle() }, label: {
                Image(systemName: "questionmark")
                    .padding(.all, 10)
                    .foregroundColor(.purple)
            }))
            .sheet(isPresented: $isShowing) {
                MoonDetail()
            }
        }
    }
    
    func calculateMoonPhase() -> Double {
        var year = Calendar.current.component(.year, from: Date())
        var month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        
        if month == 1 || month == 2 {
            year = year - 1
            month = month + 12
        }
        
        let a = year / 100
        let b = a / 4
        let c = 2 - a + b
        let e = 365.25 * Double(year + 4716)
        let f = 30.6001 * Double(month + 1)
        let eInt: Int = Int(e)
        let fInt: Int = Int(f)
        let jd = Double(c) + Double(day) + Double(eInt) + Double(fInt) - 1524.5
        
        let daysSinceNew = jd - Double(newMoonDayNumber)
        let newMoons = daysSinceNew / 29.53
        let decimalMoons = newMoons.fraction
                
        let daysIntoCycle = decimalMoons * 29.53
        print("Days Into Cycle: \(daysIntoCycle)")
        
        return daysIntoCycle
        
    }
    
}

struct MoonView_Previews: PreviewProvider {
    static var previews: some View {
        MoonView()
    }
}
