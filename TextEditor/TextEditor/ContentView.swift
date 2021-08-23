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
    func cut(length: Int, addEllipsis: Bool) -> String{
        if length > self.count - 1  {
            return self
        }
        var result = ""
            for  i in 0..<length{
                result += String(self[i])
            }
        if addEllipsis {
     result+="..."
        }
       return result
    }
}
struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var isRequestDelete = false
    @State private var fileToDelete = TextFile.simpleFile
    @State private var name = ""
    @State private var searchText = ""
    @State private var dates : [String] = []
    @State private var recents : [TextFile] = []
    @State private var openView = false
    @ViewBuilder
    func displayRecent(recent: TextFile) -> some View {
        HStack {
            NavigationLink(recent.name.cut(length: 30, addEllipsis: true), destination: TextEditing(textFile: recent, isNew: false, fileName: recent.name))
        }.swipeActions( allowsFullSwipe: false, content: {
            Button("Delete") {
                requestDelete(file: recent)
            }.tint(.red)
        })
    }
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
 
    func requestDelete(file: TextFile) {
        self.fileToDelete = file
        self.name = fileToDelete.name
        isRequestDelete = true
    }
    func delete() {
           FileController.delete(name: fileToDelete.name)
        Preferences.recents.remove(at: Preferences.recents.firstIndex(of: fileToDelete)!)
        recents = Preferences.recents
        dates = Preferences.getDates()
        Preferences.saveRecents()
    }
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: TextEditing(textFile: TextFile.simpleFile, isNew: true, fileName: "unnamed"), isActive: $openView) {
                                            
                }
                if(recents.count == 0) {
                    Text("No recents yet!").font(.system(size: 50)).scaledToFit().padding(.horizontal, 20)
                }
                else {
                    VStack {
                        if(searchRecents.count == 0) {
                            Text("No results").font(.system(size: 50)).scaledToFit().padding(.horizontal, 20).foregroundColor(.gray)
                        } else {
                    List {
                        ForEach(searchDates, id:\.self) {
                            section in Section(header: Text(String(section))){
                                ForEach(searchRecents, id: \.self) {
                                    recent in
                                    if(recent.date == section) {
                                        displayRecent(recent: recent)
                                           
                                    }
                                }
                            }
                        }
                    }.animation(.spring(), value: searchRecents)
                        }
                }.searchable(text: $searchText)
                }
            }.alert(isPresented: $isRequestDelete) {
                Alert(
                    title: Text("Warning"),
                    message: Text("Do you really wanna delete \"" + name + "\"?"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Delete"))
                    {
                        delete()
                    }
                )
            }.onAppear{
                if(recents.count == 0) {
               Preferences.loadRecents()
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
            }.onChange(of: scenePhase) { phase in
                if phase == .active {
                    if(Preferences.getCreateNewFile()) {
                        Preferences.setCreateNewFile(value: false)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                       openView = true
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
    
