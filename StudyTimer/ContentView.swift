//
//  ContentView.swift
//  StudyTimer
//
//  Created by Woo0 on 2021/06/08.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @ObservedObject var viewModel = dbData()
    var body: some View {
        TabView {
            MainView(viewModel: viewModel).tabItem { Image(systemName: "square.and.pencil")
                Text("메인화면")
            }
            CameraView().tabItem { Image(systemName: "square.and.pencil")
                Text("카메라화면")
            }
            InfoView().tabItem { Image(systemName: "square.and.pencil")
                Text("내정보")
            }
        }
    }
}

struct InfoView: View {
    var body: some View {
        Text("내정보")
    }
}

struct MainView: View {
    @ObservedObject var viewModel: dbData
    @State var selectIndex: Int = 0
    @State var weekRate: Double = 0.0
    @State var dayRate: Int = 1
    @State var currentDate = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        VStack {
                            HStack {
                                VStack {
                                    Text("  메인화면").bold()
                                }.frame(width: geometry.size.width / 3.3, height: nil, alignment: .leading)
                                Spacer()
                                VStack {
                                    Text("앱이름").bold()
                                }.frame(width: geometry.size.width / 3.3, height: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                Spacer()
                                VStack {
                                    NavigationLink(
                                        destination: AddView(viewModel: viewModel)) {
                                            Text("+ ").font(.system(size: 40)).bold().foregroundColor(.black)
                                        }
                                }.frame(width: geometry.size.width / 3.3, height: nil, alignment: .trailing)
                            }.frame(width: nil, height: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }.frame(width: nil, height: geometry.size.height / 18, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).border(Color.black)
                        VStack{
                            Form {
                                Section {
                                    if Result().count > 0 {
                                        Picker(selection: $selectIndex, label: Text(Result()[selectIndex].title)){
                                            ForEach(0..<Result().count) { i in
                                                Text(Result()[i].title)
                                            }
                                        }
                                    }
                                }
                            }
                        }.frame(width: nil, height: geometry.size.height / 7, alignment: .center)
                        VStack {
                            HStack {
                                Spacer()
                                VStack {
                                    Text("현재 공부중인 과목").bold()
                                    if Result().count > 0 {
                                        Text(Result()[selectIndex].title)
                                        let hours: Int = Result()[selectIndex].hours
                                        let minute: Int = Result()[selectIndex].minutes
                                        Text("\(hours)시간 \(minute)분")
                                    }
                                }
                                Spacer()
                                VStack {
                                    if Result().count > 0 {
                                        let title: String = Result()[selectIndex].title
                                        let hours: Int = Result()[selectIndex].hours
                                        let minute: Int = Result()[selectIndex].minutes
                                        let second: Int = 0
                                        NavigationLink(destination: TimerStartView(title: title, hours: hours, minute: minute, second: second)) {
                                            Text("start").font(.system(size: 40)).bold().foregroundColor(.black)
                                        }
                                    }
                                }
                                Spacer()
                            }.frame(width: nil, height: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }.frame(width: nil, height: geometry.size.height / 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).border(Color.black)
                        VStack {
                            HStack {
                                Spacer()
                                VStack {
                                    Text("일별 목표 달성률").bold()
                                    Text("\(getDateRate(), specifier : "%.1f")%")
                                }
                                Spacer()
                                VStack {
                                    Text("주별 목표 달성률").bold()
                                    Text("\(getWeekRate(), specifier: "%.1f")%")
                                }
                                Spacer()
                            }.frame(width: nil, height: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }.frame(width: nil, height: geometry.size.height / 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).border(Color.black)
                        VStack {
                            HStack {
                                Spacer()
                                VStack {
                                    Text("완료").bold()
                                    List {
                                        ForEach(Result(), id: \.title) { row in
                                            if row.complet == true {
                                                NavigationLink(
                                                    destination: DetailView(data: row)) {
                                                        VStack {
                                                            Text("\(row.title)")
                                                            Text("\(row.date)")
                                                        }
                                                }
                                            }
                                        }
                                    }.listStyle(PlainListStyle())
                                }
                                VStack {
                                    Text("미완료").bold()
                                    List {
                                        ForEach(Result(), id: \.title) { row in
                                            if row.complet == false {
                                                NavigationLink(
                                                    destination: DetailView(data: row)) {
                                                        VStack {
                                                            Text("\(row.title)")
                                                            Text("\(row.date)")
                                                        }
                                                }
                                            }
                                        }
                                    }.listStyle(PlainListStyle())
                                    
                                }
                                Spacer()
                            }.frame(width: nil, height: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }.frame(width: nil, height: geometry.size.height / 2.5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).border(Color.black)
                    }
                }
                .navigationTitle("")
                .navigationBarHidden(true)
            }
        }
    }
}

struct CameraView: View {
    var body: some View {
        Text("Camera")
    }
}

struct TimerStartView: View {
    @State var title: String
    @State var hours: Int
    @State var minute: Int
    @State var second: Int
    var complet = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        Text("\(title)\n\(hours)시간 \(minute)분")
        if (dataSelect(title: title).complet == true) {
            Text("완료한 과목입니다.")
        } else {
            Text("\(hours):\(minute):\(second)").onReceive(timer) { _ in
                if hours == 0 && minute == 0 && second == 0 {
                    self.timer.upstream.connect().cancel()
                    dataUpdate(title: title)
                } else {
                    if minute == 0 && second == 0 {
                        hours -= 1
                        minute = 59
                        second = 59
                    }
                    if second > 0 {
                        second -= 1
                    } else if second == 0 {
                        minute -= 1
                        second = 59
                    }
                }
            }
        }
    }
}

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var title: String = ""
    @State var hours: Double = 0.0
    @State var minutes: Int = 0
    @ObservedObject var viewModel: dbData
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    VStack {
                        Text("목표 추가").font(.system(size: 50))
                    }
                    Spacer()
                    VStack {
                        Text("목표")
                        TextField("...", text: $title).frame(height: 55)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding([.horizontal], 4)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                            .padding([.horizontal], 24)
                    }
                    VStack {
                        Text("시간")
                        HStack {
                            Picker("", selection: $minutes){
                                ForEach(0..<720, id: \.self) { i in
                                    Text("\(i) min").tag(i)
                                }
                            }.pickerStyle(WheelPickerStyle()).frame(width: nil, height: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            if minutes != 0 {
                                hours = floor(Double(minutes)/60)
                                minutes = minutes % 60
                                print("\(title) : \(Int(hours))시간\(minutes)분 추가되었습니다.")
                                let realm = try! Realm()
                                let todo = Todo()
                                todo.title = title
                                todo.hours = Int(hours)
                                todo.minutes = minutes
                                todo.complet = false
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd"
                                todo.date = formatter.string(from: Date())
                                try? realm.write {
                                    realm.add(todo)
                                }
                                viewModel.data.append(todo)
                            }
                        }, label: {
                            Text("추가하기")
                        })
                        Spacer()
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct DetailView: View {
    var data: Todo
    var body: some View {
        Text("목표 명: \(data.title)")
        Text("목표 시간: \(data.hours)시간 \(data.minutes)분")
        Text("날짜: \(data.date)")
    }
}

func getDateRate() -> Double {
    let realm = try! Realm()
    let results = realm.objects(Todo.self)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let date = formatter.string(from: Date(timeIntervalSinceNow:-604800))
    let date2 = formatter.date(from: date)
    var result = 0.0
    var first = 0
    var second = 0
    for res in results {
        let date3 = formatter.date(from: res.date)
        var useTime = Int(date3!.timeIntervalSince(date2!))
        if 0 < useTime, useTime < 86400, res.complet{
            first += 1
        }
        if 0 < useTime, useTime < 86400 {
            second += 1
        }
    }
    result = Double(first) / Double(second) * 100
    
    if result.isNaN{
        result = 0.0
    }
    
    return result
}

func getWeekRate() -> Double {
    let realm = try! Realm()
    let results = realm.objects(Todo.self)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let date = formatter.string(from: Date(timeIntervalSinceNow:-604800))
    let date2 = formatter.date(from: date)
    var result = 0.0
    var first = 0
    var second = 0
    for res in results {
        let date3 = formatter.date(from: res.date)
        var useTime = Int(date3!.timeIntervalSince(date2!))
        if 0 < useTime, useTime < 604800, res.complet{
            first += 1
        }
        if 0 < useTime, useTime < 604800 {
            second += 1
        }
    }
    result = Double(first) / Double(second) * 100
    
    if result.isNaN{
        result = 0.0
    }
    
    return result
}

class Todo: Object {
    @objc dynamic var title = ""
    @objc dynamic var hours = 0
    @objc dynamic var minutes = 0
    @objc dynamic var complet = false
    @objc dynamic var date = ""
    override static func primaryKey() -> String? {
        return "title"
    }
}

class dbData: ObservableObject {
    @Published var data: [Todo] = []
    func dataSelect() -> [Todo] {
        let realm = try! Realm()
        let results = realm.objects(Todo.self)
        for result in results {
            data.append(result)
        }
        return data
    }
}

func Result() -> [Todo] {
    let realm = try! Realm()
    let results = realm.objects(Todo.self)
    var data: [Todo] = []
    for result in results {
        data.append(result)
    }
    return data
}

func dataUpdate(title: String) {
    let realm = try! Realm()
    if let result = realm.objects(Todo.self).filter(NSPredicate(format: "title = %@", title ?? "No Rapper")).first {
        try! realm.write() {
            result.complet = true
        }
    }
}

func dataDelete(title: String) {
    let realm = try! Realm()
    if let result = realm.objects(Todo.self).filter(NSPredicate(format: "title = %@", title ?? "No Rapper")).first {
        try! realm.write() {
            realm.delete(result)
        }
    }
}

func dataSelect(title: String) -> Todo {
    let realm = try! Realm()
    let result = realm.objects(Todo.self).filter(NSPredicate(format: "title = %@", title ?? "No Rapper")).first
    return result!
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
