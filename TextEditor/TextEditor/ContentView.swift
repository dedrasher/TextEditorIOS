//
//  ContentView.swift
//  TextEditor
//
//  Created by Serega on 09.07.2021.
//

import SwiftUI
extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
extension String {
     func cut(length: Int) -> String{
        if length > self.count - 1  {
            return self
        }
        var result = ""
            for  i in 0..<length{
                result += String(self[i])
            }
       return result
    }
}
struct ContentView: View {
    @State private var isRequestDelete = false
    @State private var index = IndexSet()
    @State private var name = ""
    @State private var isEditing = false
    @State private var searchText = ""
    @State private var dates : [String] = []
    @State private var recents : [TextFile] = []
    @State private var openView = false
    var searchRecents: [TextFile] {
            if searchText.isEmpty {
                return recents
            } else {
                return recents.filter { $0.name.contains(searchText) }
            }
    }
    var searchDates: [String] {
        if searchText.isEmpty {
            return self.dates
        } else {
            var dates:[String] = []
            for i in searchRecents {
                if(!dates.contains(i.date)) {
                dates.append(i.date)
                }
            }
            return dates
        }
    }
 
    func requestDelete(index: IndexSet) {
        self.index = index
        var recentIndex = 0
        index.forEach { (i) in
           recentIndex = i
        }
        self.name = recents[recentIndex].name
        isRequestDelete = true
    }
    func delete(index: IndexSet) {
       index.forEach { (i) in
           var index: Int
           index = searchText.isEmpty ? i : Preferences.recents.firstIndex(of: searchRecents[i])!
           FileController.delete(name: recents[index].name)
           Preferences.recents.remove(at: index)
       }
        recents = Preferences.recents
        dates = Preferences.getDates()
        Preferences.SaveRecents()
    }
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: TextEditing(textFile: TextFile.simpleFile, isNew: true, fileName: "unnamed"), isActive: $openView) {
                                            
                }
                if(recents.count == 0) {
                    Text("No recents yet!").font(.system(size: 50)).scaledToFit().minimumScaleFactor(0.5)
                }
                else {
                    List {
                        ForEach(searchDates, id:\.self) {
                            section in Section(header: Text(String(section))){
                                ForEach(searchRecents, id: \.self) {
                                    recent in
                                    if(recent.date == section) {
                                        NavigationLink(recent.name.cut(length: 30)+"...", destination: TextEditing(textFile: recent, isNew: false, fileName: recent.name))
                                    }
                                }.onDelete(perform: requestDelete)
                            }
                        }
                    }.searchable(text: $searchText) .navigationBarItems(trailing: EditButton())
                }
                
            }.alert(isPresented: $isRequestDelete) {
                Alert(
                    title: Text("Warning"),
                    message: Text("Do you really wanna delete \"" + name + "\"?"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Delete"))
                    {
                        delete(index: index)
                    }
                )
            }.onAppear{
                if(recents.count == 0) {
               Preferences.LoadRecents()
                }
                recents = Preferences.recents
                dates = Preferences.getDates()
            }.navigationBarTitle("Recents").toolbar{
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        if(recents.count > 0) {
                        Text("Files count: " + String(recents.count))
                        }
                        Spacer()
                    Button(action: {
                       openView = true
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                       
                    }
                }
            }
            }
            }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
    
