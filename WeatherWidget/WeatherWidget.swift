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
        let entry = WeatherWidgetEntry(date: Date(), icon: "sun.max.fill", location: "location", temperature: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WeatherWidgetEntry] = []

        let currentDate = Date()
        for secondOffset in 0 ..< 4 {
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset * 2, to: currentDate)!
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
                
                Image(systemName: entry.icon)
                    .renderingMode(.original)
                    .font(.title)
                    .padding(10)
                
                Text(String(format: " %.1f °C", entry.temperature))
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(Color.primary.opacity(0.1))
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
                
                Image(systemName: entry.icon)
                    .renderingMode(.original)
                    .font(.largeTitle)
                    .padding(10)
                
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(10)
            .background(Color.primary.opacity(0.1))
        }
    }
    
    @available(iOSApplicationExtension 16.0, *)
    struct WeahterAccessoryCircularView: View {
        @Environment(\.widgetRenderingMode) var widgetRenderingMode
        
        var entry: WeatherWidgetProvider.Entry
        
        var body: some View {
            ZStack {
                AccessoryWidgetBackground()
                
                VStack {
                    Image(systemName: entry.icon)
                        .symbolRenderingMode(.multicolor)
                        .widgetAccentable()
                    
                    switch widgetRenderingMode {
                    case .vibrant:
                        Text(String(format: " %.1f °C", entry.temperature))
                            .font(.caption2)
                    default:
                        EmptyView()
                    }
                }
            }
        }
    }
    
    @available(iOSApplicationExtension 16.0, *)
    struct WeahterAccessoryRectangularView: View {
        var entry: WeatherWidgetProvider.Entry
        
        var formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy. MM. dd."
            return formatter
        }()
        
        var body: some View {
            ZStack(alignment: .leading) {
                AccessoryWidgetBackground()
                
                HStack {
                    Image(systemName: entry.icon)
                        .widgetAccentable()
                        .symbolRenderingMode(.multicolor)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(formatter.string(from: entry.date))
                            .font(.headline)
                            .widgetAccentable()

                        Text(entry.location)
                            .font(.body)
                        
                        Text(String(format: " %.1f °C", entry.temperature))
                            .font(.body)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
    
    @available(iOSApplicationExtension 16.0, *)
    struct WeahterAccessoryInlineView: View {
        var entry: WeatherWidgetProvider.Entry
        
        var body: some View {
            ZStack {
                AccessoryWidgetBackground()
                
                HStack {
                    Image(systemName: entry.icon)
                        .symbolRenderingMode(.multicolor)
                        .widgetAccentable()
                    
                    Text(String(format: " %.1f °C", entry.temperature))
                        .font(.title)
                }
            }
        }
    }
    
    var body: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            switch family {
            case .accessoryCircular:
                WeahterAccessoryCircularView(entry: entry)
            case .accessoryRectangular:
                WeahterAccessoryRectangularView(entry: entry)
            case .accessoryInline:
                WeahterAccessoryInlineView(entry: entry)
            case .accessoryCorner:
                WeahterAccessoryCircularView(entry: entry)
            case .systemSmall:
                WeahterSmallView(entry: entry)
            case .systemMedium:
                WeahterMediumView(entry: entry)
            default:
                WeahterMediumView(entry: entry)
            }
        } else {
            switch family {
            case .systemSmall:
                WeahterSmallView(entry: entry)
            case .systemMedium:
                WeahterMediumView(entry: entry)
            default:
                WeahterMediumView(entry: entry)
            }
        }
    }
}


// MARK: - widget


struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var supportedFamilies: [WidgetFamily] {
        if #available(iOSApplicationExtension 16.0, *) {
#if os(watchOS)
            return [.accessoryCircular, .accessoryRectangular, .accessoryInline, .accessoryCorner]
#else
            return [.accessoryCircular, .accessoryRectangular, .accessoryInline, .systemSmall, .systemMedium]
#endif
        } else {
#if os(watchOS)
            return []
#else
            return [.systemSmall, .systemMedium]
#endif
        }
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherWidgetProvider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("This is an weather widget")
        .supportedFamilies(self.supportedFamilies)
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
        Group {
            if #available(iOSApplicationExtension 16.0, *) {
                WeatherWidgetEntryView(entry: WeatherWidgetEntry(date: Date(), icon: "cloud.sun.rain.fill", location: "location", temperature: 0))
                    .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                    .previewDisplayName("accessoryCircular")
                WeatherWidgetEntryView(entry: WeatherWidgetEntry(date: Date(), icon: "cloud.sun.rain.fill", location: "location", temperature: 0))
                    .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                    .previewDisplayName("accessoryRectangular")
                WeatherWidgetEntryView(entry: WeatherWidgetEntry(date: Date(), icon: "cloud.sun.rain.fill", location: "location", temperature: 0))
                    .previewContext(WidgetPreviewContext(family: .accessoryInline))
                    .previewDisplayName("accessoryInline")
#if os(watchOS)
                WeatherWidgetEntryView(entry: WeatherWidgetEntry(date: Date(), icon: "cloud.sun.rain.fill", location: "location", temperature: 0))
                    .previewContext(WidgetPreviewContext(family: .accessoryCorner))
                    .previewDisplayName("accessoryCorner")
#endif
            }
            
#if os(iOS)
            WeatherWidgetEntryView(entry: WeatherWidgetEntry(date: Date(), icon: "cloud.sun.rain.fill", location: "location", temperature: 0))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("systemSmall")
            
            WeatherWidgetEntryView(entry: WeatherWidgetEntry(date: Date(), icon: "cloud.sun.rain.fill", location: "location", temperature: 0))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDisplayName("systemMedium")
#endif
        }
    }
}
