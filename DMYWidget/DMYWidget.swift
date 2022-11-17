//
//  DMYWidget.swift
//  DMYWidget
//
//  Created by Justin Cabral on 8/3/20.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
       //TODO: Fill this in correctly
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent.init())
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for _ in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let configuration: ConfigurationIntent
}

struct PlaceholderView : View {
    
    var body: some View {
        Text("Loading...")
    }
}

struct DMYWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var family
    @EnvironmentObject var settings: Settings
    
    static let mediumDateForamtter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static let longDateForamtter: DateFormatter = {
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
    
    private var seasonName: String {
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
    
    var todaysDate = Date()
    let yearLink = URL(string: "daymoonyear:view?index=3")
    
    var entry: Provider.Entry

    var body: some View {
        switch family {
        
        case .systemSmall:
            SeasonClock(hemisphere: .northern, clockHandInset: 36)
                .frame(width: 240, height: 220, alignment: .center)
            
        case .systemMedium:
            ZStack {
                HStack {
                    VStack {
                        TodayClock()
                            .frame(width: 100, height: 100, alignment: .center)
                        Spacer()
                        Text("Day")
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    VStack {
                        MoonClock()
                            .frame(width: 100, height: 100, alignment: .center)
                        Spacer()
                        Text("Moon")
                            .fontWeight(.semibold)

                    }

                    Spacer()
                    
                    VStack {
                        SeasonClock(hemisphere: .northern)
                            .frame(width: 100, height: 100, alignment: .center)
                        Spacer()
                        Text("Year")
                            .fontWeight(.semibold)

                    }
                    
                    Spacer()
                    
                }.padding()
                .background(ContainerRelativeShape().fill(Color("backgroundColor")).edgesIgnoringSafeArea(.all))
            }
            
        case .systemLarge:
            ZStack {
                Color(.black)
                VStack {
                    SeasonClock(hemisphere: .northern, clockHandInset: 10)
                        .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                    
                    Text(seasonName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(todaysDate, formatter: Self.longDateForamtter)")
                        .font(.title2)
                        .foregroundColor(.white)

                }.padding()
            }
            
        @unknown default:
            Text("Default")
        }
    }
}

struct DayWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            TodayClock(clockHandInset: 36)
                .frame(width: 240, height: 220, alignment: .center)
        case .systemMedium:
            TodayClock()
        case .systemLarge:
            TodayClock()
        @unknown default:
            TodayClock()
        }
    }
    
}

struct MoonWidgetEntryView: View {
    
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            MoonClock(clockHandInset: 36)
                .frame(width: 260, height: 240, alignment: .center)
        case .systemMedium:
            MoonClock()
        case .systemLarge:
            MoonClock()
        @unknown default:
            MoonClock()
        }
    }
}

struct YearWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            SeasonClock(hemisphere: .northern, clockHandInset: 36)
                .frame(width: 260, height: 240, alignment: .center)
        case .systemMedium:
            MoonClock()
        case .systemLarge:
            MoonClock()
        @unknown default:
            MoonClock()
        }
    }
}

@main
struct MultipleWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
       
        DayWidget()
        MoonWidget()
        YearWidget()
        DMYWidget()
    }
}


struct DMYWidget: Widget {
    private let kind: String = "DMYWidget"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            DMYWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Day Moon Year")
        .description("Experience time in color.")
        .supportedFamilies([.systemMedium])
    }
}

struct DayWidget: Widget {
    private let kind: String = "DayWidget"
    
    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
           DayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Day")
        .description("Change the way you see your day.")
        .supportedFamilies([.systemSmall])
    }
}

struct MoonWidget: Widget {
    private let kind: String = "MoonWidget"
    
    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
           MoonWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Moon")
        .description("Uncover the mysteries of shadow and light.")
        .supportedFamilies([.systemSmall])
    }
}

struct YearWidget: Widget {
    private let kind: String = "YearWidget"
    
    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
        YearWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Year")
        .description("Discover your own seasons of change.")
        .supportedFamilies([.systemSmall])
    }
}

struct DMYWidget_Previews: PreviewProvider {
    static var previews: some View {
        DMYWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
