//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by tigi KIM on 2021/02/25.
//

import WidgetKit
import SwiftUI


// MARK: - provider


struct WeatherWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherWidgetEntry {
        WeatherWidgetEntry(date: Date(), icon: "", location: "", temperature: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherWidgetEntry) -> ()) {
        let entry = WeatherWidgetEntry(date: Date(), icon: "01d", location: "location", temperature: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WeatherWidgetEntry] = []

        let currentDate = Date()
        for secondOffset in 0 ..< 4 {
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset * 10, to: currentDate)!
            let weatherData = WeatherLocalData[secondOffset]
            let entry = WeatherWidgetEntry(date: entryDate, icon: weatherData["icon"] as! String, location: weatherData["location"]  as! String, temperature: weatherData["temp"]  as! Double)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}


// MARK: - Entry


struct WeatherWidgetEntry: TimelineEntry {
    let date: Date
    let icon: String
    let location: String
    let temperature: Double
}


// MARK: - view


struct WeatherWidgetEntryView : View {
    var entry: WeatherWidgetProvider.Entry
    @Environment(\.widgetFamily) var family
    
    struct WeahterSmallView : View {
        var entry: WeatherWidgetProvider.Entry
        
        var formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            return formatter
        }()
        
        var body: some View {
            VStack {
                Spacer()
                
                Text(formatter.string(from: entry.date))
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(entry.location)
                    .font(.body)
                
                Image(entry.icon)
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                
                Text(String(format: " %.1f °C", entry.temperature))
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding(10)
        }
    }
    
    struct WeahterMediumView : View {
        var entry: WeatherWidgetProvider.Entry
        
        var formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy. MM. dd. HH:mm:ss"
            return formatter
        }()
        
        var body: some View {
            HStack(spacing: 20) {
                
                Image(entry.icon)
                
                VStack(alignment: .leading) {
                    Text(formatter.string(from: entry.date))
                        .font(.body)
                        .foregroundColor(.gray)
                    Text(entry.location)
                        .font(.title)
                    
                    Text(String(format: " %.1f °C", entry.temperature))
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .padding(10)
        }
    }
    
    
    var body: some View {
        switch family {
        case .systemSmall:
            WeahterSmallView(entry: entry)
        default:
            WeahterMediumView(entry: entry)
        }
    }
}


// MARK: - widget


struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherWidgetProvider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("This is an weather widget")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct WeatherWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        WeatherWidget()
        AirWidget()
    }
}


// MARK: - preview


struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: WeatherWidgetEntry(date: Date(), icon: "01d", location: "location", temperature: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct WeatherWidget_Previews_medium: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: WeatherWidgetEntry(date: Date(), icon: "01d", location: "location", temperature: 0))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
