//
//  ContentView.swift
//  Present
//
//  Created by Justin Cabral on 6/27/20.
//

import SwiftUI

enum ActiveSheet : Hashable, Identifiable {
    case dayDetail, moonDetail, seasonDetail, welcome, settings
    
    var id: Int {
        return self.hashValue
    }
}

struct ContentView: View {
    
    @EnvironmentObject var settings: Settings
    
    @State var isShowingDetailView = false
    @State var isShowingWelcomeView = false
    @State var didChangeHemisphere = false
    @State var activeSheet: ActiveSheet? = nil
    
    private let colors: Gradient = Gradient(colors: [Color.white,Color.blue,Color.green,Color.green,
                                                     Color.yellow, Color.yellow,
                                                     Color.orange,Color.red,Color.red,
                                                     Color.purple, Color.white])
    
    private let rotationPerDay = 1.013888889
    
    static let dateForamtter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    private var dayNumber: Double {
        let date = Date()
        let cal = Calendar.current
        guard let day = cal.ordinality(of: .day, in: .year, for: date) else { return 1 }
        
        return Double(day)
    }
    
    private var northernSeasonsString: String {
        switch dayNumber {
        case 1:
            return "Winter Solstice"
        case 2..<80:
            return "Winter"
        case 80:
            return "Spring Equinox"
        case 81..<172:
            return "Spring"
        case 172:
            return "Summer Solstice"
        case 172..<265:
            return "Summer"
        case 265:
            return "Fall Equinox"
        case 265..<355:
            return "Fall"
        case 355..<366:
            return "Winter Solstice"
        default:
            return ""
        }
    }
    
    private var southernSeasonsString: String {
        switch dayNumber {
        case 1:
            return "Summer Solstice"
        case 2..<80:
            return "Summer"
        case 80:
            return "Fall Equinox"
        case 81..<172:
            return "Fall"
        case 172:
            return "Winter Solstice"
        case 173..<265:
            return "Winter"
        case 265:
            return "Spring Equinox"
        case 266..<355:
            return "Spring"
        case 355..<366:
            return "Summer Solstice"
        default:
            return ""
        }
    }

    
    private var todaysDate = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color("backgroundColor").edgesIgnoringSafeArea(.all)
                VStack {
                    
                    SeasonClock(hemisphere: didChangeHemisphere ? .northern : .southern)
                        .shadow(radius: 3)
                        .padding(.all, 10)
                    
                    Text(didChangeHemisphere ? northernSeasonsString : southernSeasonsString)
                        .font(.headline)
                        .foregroundColor(.primary)
                
                    Text("\(todaysDate, formatter: Self.dateForamtter)")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding(.all, 10)

                    
                }
                .padding(.bottom, 10)
            }
            .navigationTitle("The Present - Year")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: { activeSheet = .seasonDetail }, label: {
                Image(systemName: "questionmark")
                    .padding(.all, 10)
                    .foregroundColor(.purple)
            }))
            .sheet(item: $activeSheet) { item in
                switch item {
                case .seasonDetail:
                    SeasonDetail()
                default:
                    SeasonDetail()
                }
            }
            .onAppear(perform: checkHemisphere)
            .onReceive(settings.hemisphereWillChange, perform: { hemisphere in
                if hemisphere == .northern {
                    didChangeHemisphere = true
                    settings.value = true
                } else {
                    didChangeHemisphere = false
                    settings.value = false
                }
            })

        }
    }
    
    private func checkHemisphere() {
        if settings.value == true {
            didChangeHemisphere = true
        } else {
            didChangeHemisphere = false
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
            
    }
}
