//
//  ContentView.swift
//  StudyTimer
//
//  Created by Woo0 on 2021/06/08.
//

import SwiftUI
import RealmSwift
import TensorFlowLite

struct ContentView: View {
    @ObservedObject var viewModel = dbData()
    var body: some View {
        TabView {
            MainView(viewModel: viewModel).tabItem { Image(systemName: "square.and.pencil")
                Text("메인화면")
            }
//            CameraView().tabItem { Image(systemName: "square.and.pencil")
//                Text("카메라화면")
//            }
//            InfoView().tabItem { Image(systemName: "square.and.pencil")
//                Text("내정보")
//            }
        }
    }
}

struct InfoView: View {
    var body: some View {
        Text("내정보").font(Font.custom("BMJUAOTF", size: 24)).bold().foregroundColor(CustomColor.customGreen)
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
                                    Text("메인화면").font(Font.custom("BMJUAOTF", size: 20)).bold().foregroundColor(.white)
                                }.frame(width: geometry.size.width / 3.3, height: nil, alignment: .leading).padding([.horizontal], 5)
                                Spacer()
                                VStack {
                                    Text("StudyTimer").font(Font.custom("BMJUAOTF", size: 20)).bold().foregroundColor(.white)
                                }.frame(width: geometry.size.width / 3.3, height: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                Spacer()
                                VStack {
                                    NavigationLink(
                                        destination: AddView(viewModel: viewModel)) {
                                            Text("+").font(.system(size: 40)).font(Font.custom("BMJUAOTF", size: 20)).bold().foregroundColor(.white)
                                        }
                                }.frame(width: geometry.size.width / 3.3, height: nil, alignment: .trailing).padding([.horizontal], 5)
                            }.frame(width: nil, height: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(CustomColor.customGreen).padding([.vertical], 5)
                        }.frame(width: nil, height: geometry.size.height / 18, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        VStack {
                            HStack {
                                Spacer()
                                VStack {
                                    Text("일별 목표 달성률").font(Font.custom("BMJUAOTF", size: 24)).bold().foregroundColor(.black)
                                    Text("\(getDateRate(), specifier : "%.1f")%").font(.system(size: 40)).bold().foregroundColor(CustomColor.customGreen)
                                }
                                Spacer()
                                VStack {
                                    Text("주별 목표 달성률").font(Font.custom("BMJUAOTF", size: 24)).bold().foregroundColor(.black)
                                    Text("\(getWeekRate(), specifier: "%.1f")%").font(.system(size: 40)).bold().foregroundColor(CustomColor.customGreen)
                                }
                                Spacer()
                            }.frame(width: nil, height: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }.frame(width: nil, height: geometry.size.height / 4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(CustomColor.customGreen, lineWidth: 2).padding([.horizontal], 5).padding([.vertical], 10)
                        )
                        VStack {
                            Spacer()
                            //HStack {
                            VStack {
                                Text("미완료").bold().font(Font.custom("BMJUAOTF", size: 24)).bold().foregroundColor(.black).padding([.vertical], 5)
                                List {
                                    ForEach(Result(), id: \.title) { row in
                                        if row.complet == false {
                                            NavigationLink(
                                                destination: DetailView(data: row)) {
                                                    VStack {
                                                        Text("\(row.title)").font(Font.custom("BMJUAOTF", size: 22)).bold().foregroundColor(CustomColor.customGreen)
                                                    }.frame(width: geometry.size.width / 3, height: nil)
                                                    VStack {
                                                        Text("\(row.date)").font(Font.custom("BMJUAOTF", size: 16)).bold().foregroundColor(CustomColor.customGreen)
                                                    }.frame(width: geometry.size.width / 4, height: nil)
                                                    VStack {
                                                        Text("\(row.hours)시간 \(row.minutes)분").font(Font.custom("BMJUAOTF", size: 16)).bold().foregroundColor(CustomColor.customGreen)
                                                    }.frame(width: geometry.size.width / 5, height: nil)
                                            }
                                        }
                                    }
                                }.listStyle(PlainListStyle())
                            }.padding([.horizontal], 5).padding([.vertical], 5)
                            Spacer()
                            VStack {
                                Text("완료").font(Font.custom("BMJUAOTF", size: 24)).bold().foregroundColor(.black).padding([.vertical], 5)
                                List {
                                    ForEach(Result(), id: \.title) { row in
                                        if row.complet == true {
                                            NavigationLink(
                                                destination: DetailView(data: row)) {
                                                    VStack {
                                                        Text("\(row.title)").font(Font.custom("BMJUAOTF", size: 22)).bold().foregroundColor(CustomColor.customGreen)
                                                    }.frame(width: geometry.size.width / 3, height: nil)
                                                    VStack {
                                                        Text("\(row.date)").font(Font.custom("BMJUAOTF", size: 16)).bold().foregroundColor(CustomColor.customGreen)
                                                    }.frame(width: geometry.size.width / 4, height: nil)
                                                    VStack {
                                                        Text("\(row.hours)시간 \(row.minutes)분").font(Font.custom("BMJUAOTF", size: 16)).bold().foregroundColor(CustomColor.customGreen)
                                                    }.frame(width: geometry.size.width / 5, height: nil)
                                            }
                                        }
                                    }
                                }.listStyle(PlainListStyle())
                            }.padding([.horizontal], 5).padding([.vertical], 5)
                            Spacer()
                            //}.frame(width: nil, height: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }.frame(width: nil, height: geometry.size.height / 1.5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(CustomColor.customGreen, lineWidth: 2).padding([.horizontal], 5)
                        )
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
        Text("Camera").font(Font.custom("BMJUAOTF", size: 24)).bold().foregroundColor(CustomColor.customGreen)
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
                        Text("목표 추가").font(Font.custom("BMJUAOTF", size: 48)).bold().foregroundColor(CustomColor.customGreen)
                    }.padding(30)
                    Spacer()
                    VStack {
                        Text("목표 이름").font(Font.custom("BMJUAOTF", size: 24)).bold().foregroundColor(CustomColor.customGreen)
                        TextField("...", text: $title).frame(height: 55)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding([.horizontal], 4)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                            .padding([.horizontal], 24)
                            .padding([.vertical], 30)
                    }
                    Spacer()
                    VStack {
                        Text("시간 설정").font(Font.custom("BMJUAOTF", size: 24)).bold().foregroundColor(CustomColor.customGreen)
                        HStack {
                            Picker("", selection: $minutes){
                                ForEach(0..<720, id: \.self) { i in
                                    Text("\(i) min").font(Font.custom("BMJUAOTF", size: 24)).tag(i)
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
                            Text("추가하기").font(Font.custom("BMJUAOTF", size: 34)).bold().foregroundColor(CustomColor.customGreen)
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

struct TimerStartView: View {
    @State var isTimerRunning = false
    @State var title: String
    @State var hours: Int
    @State var minute: Int
    @State var second: Int
    @State var complet = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            Text("\(title)\n\(hours)시간 \(minute)분").font(Font.custom("BMJUAOTF", size: 50)).bold().foregroundColor(CustomColor.customGreen)
            if (dataSelect(title: title).complet == true) {
                Text("완료한 과목입니다.").font(Font.custom("BMJUAOTF", size: 24)).bold().foregroundColor(CustomColor.customGreen)
            } else {
                Text("남은 시간: \(hours):\(minute):\(second)").font(Font.custom("BMJUAOTF", size: 30)).bold().foregroundColor(CustomColor.customGreen).onReceive(timer) { _ in
                    if hours == 0 && minute == 0 && second == 0 {
                        self.timer.upstream.connect().cancel()
                        completUpdate(title: title)
                    } else {
                        if self.isTimerRunning {
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
                }.onTapGesture {
                    if isTimerRunning {
                        self.stopTimer()
                    } else {
                        self.startTimer()
                    }
                    isTimerRunning.toggle()
                }
            }
        }.onDisappear {
            timeUpdate(title: title, hours: hours, minutes: minute)
        }
    }
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
}

struct DetailView: View {
    var data: Todo
    var body: some View {
        Text("목표 명: \(data.title)").font(Font.custom("BMJUAOTF", size: 24)).bold().foregroundColor(CustomColor.customGreen)
        Text("목표 시간: \(data.hours)시간 \(data.minutes)분").font(Font.custom("BMJUAOTF", size: 24)).bold().foregroundColor(CustomColor.customGreen)
        Text("날짜: \(data.date)").font(Font.custom("BMJUAOTF", size: 24)).bold().foregroundColor(CustomColor.customGreen)
        VStack {
            if Result().count > 0 {
                NavigationLink(destination: TimerStartView(title: data.title, hours: data.hours, minute: data.minutes, second: 0)) {
                    Text("START").font(Font.custom("BMJUAOTF", size: 40)).bold().foregroundColor(CustomColor.customGreen)
                }
//                NavigationLink(destination: CameraView()) {
//                    Text("Camera").font(Font.custom("BMJUAOTF", size: 40)).bold().foregroundColor(CustomColor.customGreen)
//                }
            }
        }
    }
}

func getDateRate() -> Double {
    let realm = try! Realm()
    let results = realm.objects(Todo.self)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let date = formatter.string(from: Date(timeIntervalSinceNow:-86400))
    let date2 = formatter.date(from: date)
    var result = 0.0
    var first = 0
    var second = 0
    for res in results {
        let date3 = formatter.date(from: res.date)
        let useTime = Int(date3!.timeIntervalSince(date2!))
        if 0 < useTime, useTime <= 86400, res.complet{
            first += 1
        }
        if 0 < useTime, useTime <= 86400 {
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
        let useTime = Int(date3!.timeIntervalSince(date2!))
        if 0 < useTime, useTime <= 604800, res.complet{
            first += 1
        }
        if 0 < useTime, useTime <= 604800 {
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

func completUpdate(title: String) {
    let realm = try! Realm()
    if let result = realm.objects(Todo.self).filter(NSPredicate(format: "title = %@", title ?? "No Rapper")).first {
        try! realm.write() {
            result.complet = true
        }
    }
}

func timeUpdate(title: String, hours: Int, minutes: Int) {
    let realm = try! Realm()
    if let result = realm.objects(Todo.self).filter(NSPredicate(format: "title = %@", title ?? "No Rapper")).first {
        try! realm.write() {
            result.hours = hours
            result.minutes = minutes
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
