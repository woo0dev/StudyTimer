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
    @State var currentDate = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
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
                    }.frame(width: nil, height: geometry.size.height / 10, alignment: .center).border(Color.black)
                    VStack {
                        HStack {
                            Spacer()
                            VStack {
                                Text("진행중인 타이머").bold()
                                if Result().count > 0 {
                                    var title = Result()[selectIndex]
                                    var hours = title.hours * 60
                                    var minute = hours + title.minutes * 60
                                    var second = minute * 60
                                    Text("\(second)")
                                }
//                                Text("\(currentDate)").onReceive(timer) {
//                                    self.currentDate = $0
//                                }
                            }
                            Spacer()
                            VStack {
                                Text("현재 공부중인 과목").bold()
                                if Result().count > 0 {
                                    Text(Result()[selectIndex].title)
                                }
                            }
                            Spacer()
                        }.frame(width: nil, height: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Button(action: {
                            
                        }, label: {
                            Text("Start")
                        }).foregroundColor(.black)
                    }.frame(width: nil, height: geometry.size.height / 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).border(Color.black)
                    VStack {
                        HStack {
                            Spacer()
                            VStack {
                                Text("시간별 목표 달성률").bold()
                                Text("45%").font(.system(size: 50))
                            }
                            Spacer()
                            VStack {
                                Text("일별 달성률").bold()
                                Text("75%").font(.system(size: 50))
                            }
                            Spacer()
                        }.frame(width: nil, height: nil, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }.frame(width: nil, height: geometry.size.height / 3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).border(Color.black)
                    VStack {
                        HStack {
                            Spacer()
                            VStack {
                                Text("완료").bold()
                                List {
                                    ForEach(Result(), id: \.title) { row in
                                        if row.complet == true {
                                            NavigationLink(
                                                destination: Text("Detail \(row.title))")) {
                                                Text("\(Text(row.title))")
                                            }
                                        }
                                    }
                                }
                            }
                            VStack {
                                Text("미완료").bold()
                                List {
                                    ForEach(Result(), id: \.title) { row in
                                        if row.complet == false {
                                            NavigationLink(
                                                destination: Text("Detail \(row.title))")) {
                                                Text("\(Text(row.title))")
                                            }
                                        }
                                    }
                                }
                                
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

func dataCount() -> Int {
    let realm = try! Realm()
    let results = realm.objects(Todo.self)
    return results.count
}

func titleData() -> [String] {
    var titleList: [String] = []
    let realm = try! Realm()
    let results = realm.objects(Todo.self)
    for result in results {
        titleList.append(result.title)
    }
    return titleList
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

struct CameraView: View {
    var body: some View {
        Text("Camera")
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

class Todo: Object {
    @objc dynamic var title = ""
    @objc dynamic var hours = 0
    @objc dynamic var minutes = 0
    @objc dynamic var complet = false
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

