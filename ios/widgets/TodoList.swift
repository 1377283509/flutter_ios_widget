//
//  TodoList.swift
//  Runner
//
//  Created by Apple on 2021/7/13.
//

import SwiftUI
import WidgetKit


struct ToDoList:Widget {
    var kind:String = "todo_list"
    
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: kind, provider: ToDoListProvider()) { entry in
            ToDoListView(entry: entry)
        }.configurationDisplayName("用户信息")
        .description("展示用户id和姓名")
        .supportedFamilies([.systemMedium,.systemSmall])
    }
}

struct ToDoListView:View{
    
    var entry:ToDoListProvider.Entry
    
    var body: some View{
        VStack{
            Text("ToDoList")
            Text(entry.userid)
            Text(entry.author)
        }.widgetURL(URL(string: "dynamictheme://user?userid=\(entry.userid)&author=\(entry.author)"))
    }
}

struct ToDoListProvider:TimelineProvider {
    func placeholder(in context: Context) -> ToDoListTimelineEntry {
        ToDoListTimelineEntry(date: Date(),userid: "无", author:"无")
    }
    
    typealias Entry = ToDoListTimelineEntry
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(ToDoListTimelineEntry(date: Date(), userid: "无", author: "无"))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        print("start getTimeline")
        let userDefaults = UserDefaults(suiteName: "group.com.cc.ToDo")
        let userid = userDefaults?.string(forKey: "userid")
        let author = userDefaults?.string(forKey: "author")
        print("timeline:  \(userid!) \(author!)")
        completion(Timeline(entries: [ToDoListTimelineEntry(date: Date(), userid: userid!, author: author!)], policy: .atEnd))
    }
}



struct ToDoListTimelineEntry:TimelineEntry {
    var date: Date
    var userid:String
    var author:String
}


struct ToDoModel:Codable {
    var title:String
    var content:String
    var status:Bool
    var endDate:Date
    var startDate:Date
}

