//
//  EditableWidget.swift
//  EditableWidget
//
//  Created by tigi KIM on 2021/02/25.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct EditableWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 20) {
            Text(entry.configuration.parameter ?? "editable")
            
            switch entry.configuration.enumparameter {
            case .unknown:
                Text("unknown enum")
            case .first:
                Text("first enum")
            case .second:
                Text("second enum")
            default:
                Text("default enum")

            }
        }
    }
}

@main
struct EditableWidget: Widget {
    let kind: String = "EditableWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            EditableWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Editable Widget")
        .description("This is an editable widget.")
    }
}

struct EditableWidget_Previews: PreviewProvider {
    static var previews: some View {
        EditableWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
