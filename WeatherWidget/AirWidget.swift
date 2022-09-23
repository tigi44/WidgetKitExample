//
//  AirWidget.swift
//  WeatherWidgetExtension
//
//  Created by tigi KIM on 2021/02/25.
//

import WidgetKit
import SwiftUI


// MARK: - provider


struct AirWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> AirWidgetEntry {
        AirWidgetEntry(date: Date(), airConditions: [AirWidgetEntry.AirCondition(dt: Date().timeIntervalSince1970, condition: "GOOD")])
    }

    func getSnapshot(in context: Context, completion: @escaping (AirWidgetEntry) -> ()) {
        let entry = AirWidgetEntry(date: Date(), airConditions: [AirWidgetEntry.AirCondition(dt: Date().timeIntervalSince1970, condition: "BAD"),
                                                                 AirWidgetEntry.AirCondition(dt: Date().timeIntervalSince1970 + 60, condition: "GOOD"),
                                                                 AirWidgetEntry.AirCondition(dt: Date().timeIntervalSince1970 + 120, condition: "NORMAL"),
                                                                 AirWidgetEntry.AirCondition(dt: Date().timeIntervalSince1970 + 180, condition: "GOOD")])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [AirWidgetEntry] = []
        var airConditions: [AirWidgetEntry.AirCondition] = []
        
        for air in AirLocalData {
            
            let airCondition = AirWidgetEntry.AirCondition(dt: air["dt"] as! TimeInterval, condition: air["condition"] as! String)
            airConditions.append(airCondition)
        }
        
        let entry = AirWidgetEntry(date: Date(), airConditions: airConditions)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}


// MARK: - entry


struct AirWidgetEntry: TimelineEntry {
    
    struct AirCondition {
        let dt: TimeInterval
        let condition: String
        
        func condifionColor() -> Color {
            switch condition {
            case "GOOD":
                return .green
            case "NORMAL":
                return .yellow
            default:
                return .red
            }
        }
    }
    
    let date: Date
    let airConditions: [AirCondition]
}


// MARK: - view


struct AirWidgetEntryView : View {
    var entry: AirWidgetProvider.Entry
    @Environment(\.widgetFamily) var family
    
    struct AirSmallView : View {
        var entry: AirWidgetProvider.Entry
        
        var body: some View {
            VStack {
                Spacer()
                
                Text(Date(timeIntervalSince1970: entry.airConditions.first!.dt), style: .time)
                
                Spacer()
                
                Text(entry.airConditions.first!.condition)
                    .foregroundColor(entry.airConditions.first!.condifionColor())
                    .bold()
                
                Spacer()
            }
            .padding(20)
        }
    }
    
    struct AirMediumView : View {
        var entry: AirWidgetProvider.Entry
        
        var body: some View {
            VStack(alignment:.leading, spacing: 10) {
                ForEach(entry.airConditions, id: \.dt) { airCondition in
                    HStack(spacing: 50) {
                        Text(Date(timeIntervalSince1970: airCondition.dt), style: .time)
                        
                        Text(airCondition.condition)
                            .foregroundColor(airCondition.condifionColor())
                            .bold()
                        
                    }
                }
            }
        }
    }
    
    var body: some View {
        switch family {
        case .systemSmall:
            AirSmallView(entry: entry)
        default:
            AirMediumView(entry: entry)
        }
    }
}


// MARK: - widget


struct AirWidget: Widget {
    let kind: String = "AirWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AirWidgetProvider()) { entry in
            AirWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Air Widget")
        .description("This is an air widget.")
#if os(watchOS)
        .supportedFamilies([])
#else
        .supportedFamilies([.systemSmall, .systemMedium])
#endif
    }
}


// MARK: - preview


#if os(watchOS)
#else
struct AirWidget_Previews: PreviewProvider {
    static var previews: some View {
        AirWidgetEntryView(entry: AirWidgetEntry(date: Date(), airConditions: [AirWidgetEntry.AirCondition(dt: Date().timeIntervalSince1970, condition: "GOOD")]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct AirWidget_Previews_medium: PreviewProvider {
    static var previews: some View {
        AirWidgetEntryView(entry: AirWidgetEntry(date: Date(), airConditions: [AirWidgetEntry.AirCondition(dt: Date().timeIntervalSince1970, condition: "BAD"),
                                                                               AirWidgetEntry.AirCondition(dt: Date().timeIntervalSince1970 + 60, condition: "GOOD"),
                                                                               AirWidgetEntry.AirCondition(dt: Date().timeIntervalSince1970 + 120, condition: "GOOD"),
                                                                               AirWidgetEntry.AirCondition(dt: Date().timeIntervalSince1970 + 180, condition: "NORMAL")]))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
#endif

