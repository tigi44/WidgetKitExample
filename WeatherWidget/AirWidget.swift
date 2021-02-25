//
//  AirWidget.swift
//  WeatherWidgetExtension
//
//  Created by tigi KIM on 2021/02/25.
//

import WidgetKit
import SwiftUI

struct AirWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> AirWidgetEntry {
        AirWidgetEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (AirWidgetEntry) -> ()) {
        let entry = AirWidgetEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [AirWidgetEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = AirWidgetEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct AirWidgetEntry: TimelineEntry {
    let date: Date
}

struct AirWidgetEntryView : View {
    var entry: AirWidgetProvider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct AirWidget: Widget {
    let kind: String = "AirWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AirWidgetProvider()) { entry in
            AirWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct AirWidget_Previews: PreviewProvider {
    static var previews: some View {
        AirWidgetEntryView(entry: AirWidgetEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

