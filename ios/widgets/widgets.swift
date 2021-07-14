//
//  widgets.swift
//  widgets
//
//  Created by Apple on 2021/7/13.
//

import WidgetKit
import SwiftUI


@main
struct widgets: WidgetBundle {

    @WidgetBundleBuilder
    var body: some Widget{
        ToDoList()
    }
}
