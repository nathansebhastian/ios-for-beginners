//
//  TasklyWidget.swift
//  TasklyWidget
//
//  Created by Nathan Sebhastian on 25/09/24.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), tasks: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), tasks: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let context = try? ModelContext(.init(for: TaskItem.self))
        let descriptor = FetchDescriptor(predicate: #Predicate<TaskItem>{ $0.isCompleted == false }, sortBy: [SortDescriptor(\TaskItem.dueDate)])
        
        let tasks = try? context?.fetch(descriptor)
        
        let entry = SimpleEntry(date: .now, tasks: tasks ?? [])
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var tasks: [TaskItem]
}

struct TasklyWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            ForEach(entry.tasks) { task in
                HStack(spacing: 10) {
                    Text(task.title)
                        .font(.headline)
                    Text(task.dueDate, format: Date.FormatStyle(date: .numeric, time: .shortened))
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Button(intent: ToggleButton(id: task.taskID)) {
                        Image(systemName: "circle")
                    }
                    .font(.callout)
                    .buttonBorderShape(.circle)
                }
                .transition(.push(from: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if entry.tasks.isEmpty {
                Text("Nothing to do! 🎉")
                    .font(.callout)
                    .transition(.push(from: .bottom))
            }
        }
    }
}

struct TasklyWidget: Widget {
    let kind: String = "TasklyDevWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TasklyWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TasklyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Taskly Widget")
        .description("View active tasks and complete them in a snap.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    TasklyWidget()
} timeline: {
    SimpleEntry(date: .now, tasks: [])
}

/// Button intent to update task status
struct ToggleButton: AppIntent {
    static var title = LocalizedStringResource("Complete Task")
    static var description = IntentDescription("Mark a task as completed.")
    
    @Parameter(title: "Task ID")
    var id: String
    
    init() {}
    
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        let context = try ModelContext(.init(for: TaskItem.self))
        let descriptor = FetchDescriptor(predicate: #Predicate<TaskItem>{ $0.taskID == id })
        if let task = try context.fetch(descriptor).first {
            task.isCompleted.toggle()
            try context.save()
        }
        return .result()
    }
}

