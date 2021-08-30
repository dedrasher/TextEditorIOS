//
//  ContentView.swift
//  TextEditor
//
//  Created by Serega on 09.07.2021.
//

import SwiftUI
extension View{
   func padOnlyStackNavigationView() ->some View{
       if UIDevice.current.userInterfaceIdiom == .pad{
           return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
       }else{
           return AnyView(self)
       }
   }
}
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
    @State private var selectedRecents : [TextFile] = []
    @State private var isMultiEditing = false
    @Environment(\.scenePhase) private var scenePhase
    @State private var isRequestDelete = false
    @State private var fileToDelete = TextFile.simpleFile
    @State private var name = ""
    @State private var searchText = ""
    @State private var dates : [String] = []
    @State private var recents : [TextFile] = []
    @State var openView = false
    func displayName(name: String) -> String {
        return name.cut(length: isMultiEditing ? 25: 30, addEllipsis: true)
    }
    func cleanSelected() {
        selectedRecents.removeAll()
    }
    @ViewBuilder
    func displayRecent(recent: TextFile) -> some View {
        if(isMultiEditing) {
            let contains = selectedRecents.contains(recent)
            HStack {
            Image(systemName: contains ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(contains ? Color(UIColor.systemBlue) : Color.secondary)
                Text(displayName(name: recent.name))
            }.onTapGesture {
                if(contains) { selectedRecents.remove(at: selectedRecents.firstIndex(of: recent)!) } else { selectedRecents.append(recent)
                }
            }
        } else {
        HStack {
            NavigationLink(displayName(name: recent.name), destination: TextEditing(textFile: recent, isNew: false, fileName: recent.name))
        }.swipeActions( allowsFullSwipe: false, content: {
            Button("Delete") {
                requestDelete(file: recent)
            }.tint(.red)
        })
        }
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
 
    func requestDelete(file: TextFile? = nil) {
        if(file != nil) {
        self.fileToDelete = file!
        self.name = fileToDelete.name
        }
        isRequestDelete = true
    }
    func delete(isMany: Bool) {
        func remove() {
            FileController.delete(name: fileToDelete.name)
         Preferences.recents.remove(at: Preferences.recents.firstIndex(of: fileToDelete)!)
        }
        if(isMany) {
            for recent in selectedRecents {
                fileToDelete = recent
               remove()
            }
            cleanSelected()
        } else {
          remove()
        }
        recents = Preferences.recents
        dates = Preferences.getDates()
        Preferences.saveRecents()
    }
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: TextEditing(textFile: TextFile.simpleFile, isNew: true, fileName: ""), isActive: $openView) {
                                            
                }
                if(recents.count == 0) {
                    Text("No recents yet!").font(.system(size: 50)).scaledToFill().padding(.horizontal, 20)
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
                    }.navigationBarItems(leading: Button(isMultiEditing ? "Done" : "Edit") {
                        isMultiEditing.toggle()
                        if(!isMultiEditing) {
                            cleanSelected()
                        }
                    }, trailing: HStack {if (isMultiEditing && selectedRecents.count > 0) { Button(action: {
                        requestDelete()
                    }){
                        Image(systemName: "trash")
                    }}}).animation(.spring(), value: searchRecents)
                        }
                }.searchable(text: $searchText)
                }
            }.alert(isPresented: $isRequestDelete) {
                Alert(
                    title: Text("Warning"),
                    message: Text(isMultiEditing ? "Do you really wanna delete selected files?" :"Do you really wanna delete \"" + name + "\"?"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Delete"))
                    {
                       delete(isMany: isMultiEditing)
                        isMultiEditing = false
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
                        if(isMultiEditing && searchText.isEmpty) {
                            let allSelected = selectedRecents.count == recents.count
                            Button(allSelected ? "Deselect all" : "Select all") {
                                if(allSelected) {
                                    selectedRecents.removeAll()
                                } else {
                               selectedRecents = recents
                                }
                            }
                        }
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
        }.onChange(of: scenePhase) {
            phase in
            if (phase == .active && Preferences.openNewFileEditingView){
                Preferences.openNewFileEditingView = false
                openView = true
            }
        }.padOnlyStackNavigationView()
        
            }
             
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
    
