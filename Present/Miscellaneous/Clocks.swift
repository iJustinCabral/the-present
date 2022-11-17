//
//  Clocks.swift
//  Present
//
//  Created by Justin Cabral on 6/30/20.
//

import Foundation
import SwiftUI

enum Hemisphere {
    case northern
    case southern
}
struct Hand: Shape {
    
    let inset: CGFloat
    let angle: Angle

    func path(in rect: CGRect) -> Path {
        let rect = rect.insetBy(dx: inset, dy: inset)
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addRoundedRect(in: CGRect(x: rect.midX - 4, y: rect.midY - 4, width: 8, height: 8), cornerSize: CGSize(width: 8, height: 8))
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: position(for: CGFloat(angle.radians), in: rect))
        return path
    }
    
    private func position(for angle: CGFloat, in rect: CGRect) -> CGPoint {
        let angle = angle - (.pi/2)
        let radius = min(rect.width, rect.height)/2
        let xPosition = rect.midX + (radius * cos(angle))
        let yPosition = rect.midY + (radius * sin(angle))
        return CGPoint(x: xPosition, y: yPosition)
    }
}

struct SeasonClock: View {
        
    private let colors: Gradient = Gradient(colors: [Color.white,Color.blue,Color.green,Color.green,
                                                     Color.yellow, Color.yellow,
                                                     Color.orange,Color.red,Color.red,
                                                     Color.purple, Color.white])
    
    private let rotationPerDay = 1.013888889
    public var hemisphere: Hemisphere
    public var clockHandInset: Int = 10
    
    private var hemisphereRotation: Double {
        switch hemisphere {
        case .northern:
            return 270.0
        case .southern:
            return 90.0
        }
    }
    
    private var dayNumber: Double {
        let date = Date()
        let cal = Calendar.current
        guard let day = cal.ordinality(of: .day, in: .year, for: date) else { return 1 }
        
        return Double(day)
    }

    var body: some View {
        
        ZStack {
            AngularGradient(gradient: colors, center: .center, startAngle: .zero, endAngle: .degrees(360))
                .clipShape(Circle())
                .rotationEffect(.init(degrees: hemisphereRotation))
            
            Hand(inset: CGFloat(clockHandInset), angle: Angle(degrees: dayNumber * rotationPerDay))
                .stroke(lineWidth: 4)
                .foregroundColor(Color.white)
                .shadow(radius: 3)
            
            Rectangle()
                .foregroundColor(Color.black)
                .frame(width: 4, height: 4, alignment: .center)
                .clipShape(Circle())
            
        }
    }
}

struct TodayClock: View {
    
    private let colors: [Color] = [Color.blue, Color.blue, Color.blue, Color.blue,
                                   Color.white,Color.purple,
                                   Color.black, Color.black, Color.black]
    
    private let hour: Int = Calendar.current.component(.hour, from: Date())
    private let minute: Int = Calendar.current.component(.minute, from: Date())
    private let rotationPerMinute: Double = 0.25
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    private var rotationAngle: Double {
        (Double((hour) * 15) + (Double(minute) * rotationPerMinute)) - 180
    }
    
    public var clockHandInset: Int = 10
    
    @State private var angle: Double = 0
    
    var body: some View {
        
        ZStack {
            
            Image("dayCircleCrop")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 3)
            
            Hand(inset: CGFloat(clockHandInset), angle: Angle(degrees: rotationAngle))
                .stroke(lineWidth: 4)
                .foregroundColor(Color.white)
                .shadow(radius: 3)
            
            Rectangle()
                .foregroundColor(Color.black)
                .frame(width: 4, height: 4, alignment: .center)
                .clipShape(Circle())
            
        }
    }
}

struct MoonClock: View {
    
    private let colors: [Color] = [Color.white, Color.white.opacity(0.8), Color.white.opacity(0.8),
                                   Color.gray.opacity(0.8), Color.gray,
                                   Color.black, Color.black]
    
    private let newMoonDayNumber = 2459051
    private let rotationPerDay: Double = 12.2033898305
    public var clockHandInset: Int = 10
    
    private var clockHandColor: Color {
        switch daysIntoCycle {
        case 0.0...0.9:
            return Color.white
        case 1.0...7.09:
            return Color.white.opacity(0.8)
        case 7.1...14.99:
            return Color.gray
        case 15.0...15.09:
            return Color.gray.opacity(0.8)
        case 15.1...22.09:
            return Color.gray
        case 22.1...29.49:
            return Color.white.opacity(0.5)
        case 29.5...29.539:
            return Color.white
        default:
            return Color.gray
        }
    }
    
    private var daysIntoCycle: Double {
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
                
        return daysIntoCycle
    }
    
    private var rotationAngle: Double {
        (rotationPerDay * daysIntoCycle - 180)
    }
    
    var body: some View {
        
        ZStack {
            
            Image("moonCircleCrop")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 3)
            
            Hand(inset: CGFloat(clockHandInset), angle: Angle(degrees: rotationAngle))
                .stroke(lineWidth: 4)
                .foregroundColor(Color.white) // TODO: Gray at 50%, White at new moon, dark at full moon
                .shadow(radius: 3)
            
            Rectangle()
                .foregroundColor(Color.black)
                .frame(width: 4, height: 4, alignment: .center)
                .clipShape(Circle())

        }
    }
}

struct TodayClock_Previews: PreviewProvider {
    static var previews: some View {
        TodayClock()
    }
}

extension Color {
    static public var darkBlue: Color {
        Color(UIColor(red: CGFloat(36), green: CGFloat(4), blue: CGFloat(97), alpha: CGFloat(1)))
    }
}

extension FloatingPoint {
    var whole: Self { modf(self).0 }
    var fraction: Self { modf(self).1 }
}
