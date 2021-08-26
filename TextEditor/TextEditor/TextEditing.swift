//
//  TextEditing.swift
//  TextEditor
//
//  Created by Serega on 09.07.2021.
//
import SwiftUI
private var sharingText = ""
struct TextEditing: View {
    @State private var isRename = false
    @State private var renameDialogIsOpen = false
    @State var isSaved = false
    @State var textFile: TextFile = TextFile.simpleFile
    @State var isExists = false
    @State var sharing = false
    @State var isNew : Bool
    @State private var fileText = ""
    @State private var saveDialogIsOpen = false
    @State var fileName : String
    @FocusState private var focus: Bool?
    func wordsCount() -> Int {
        let components = fileText.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        return words.count
    }
  func setRecents(save: Bool = true) {
        if(save) {
        FileController.save(text:fileText, withFileName: fileName)
            isSaved = true
        }
      if(textFile != TextFile.simpleFile) {
          Preferences.recents.remove(at: Preferences.recents.firstIndex(of: textFile) ?? 0)
      }
      Preferences.recents.insert(TextFile(name: fileName, date: DateHelper.date()), at: 0)
      textFile = Preferences.recents[0]
     Preferences.saveRecents()
    }
    var body: some View {
        VStack{
            TextEditor(text: $fileText).focused($focus, equals: true).textAlert(isPresented: $saveDialogIsOpen,
                                             TextAlert(title: "Warning",
                                                                                                                              message: "Choose name for file",
                                                                                        keyboardType: .default) { result in
                                                if let text = result{
                                                  let  fileNameToSave = text
                                                    if(FileController.ExistsInRecents(fileName: fileNameToSave)) {
                                            isExists = true
                                                    } else {
                                                        fileName = fileNameToSave
                                                    isNew = false
                                                    setRecents()
                                                    }
                                                }
            }).textAlert(isPresented: $renameDialogIsOpen,
                                                                                                                            TextAlert(title: "Warning",
                                                                                                                                                                                                             message: "Choose new name for file",
                                                                                                                                                                       keyboardType: .default) { result in
                                                                                                                               if let text = result{
                                                                                                                            let  fileNameToSave = text
                                                                                                                                   if(FileController.ExistsInRecents(fileName: fileNameToSave)) {
                                                                                                                           isExists = true
                                                                                                    isRename = true
                                                                                                                            } else {
                                                                                                                                       let oldName = fileName
                                                                                                                                       fileName = fileNameToSave
                                                                                                                                   setRecents(save: false)
                                                                                                                                FileController.rename(oldName: oldName, newName: fileName,fileText: fileText)
                                                                                                                                   }
                                                                                                                               }
            })
         
            
            
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }.navigationBarItems(trailing: HStack(spacing: 10) {
            Button(action: {
               if isNew {
           saveDialogIsOpen = true
               } else {
                   setRecents()
               }
           }) {
               Image(systemName: "folder")
           }
                Menu {
                    if isSaved || !isNew {
                        Button(action: {
                           renameDialogIsOpen = true
                        }) {
                            Label("Rename",systemImage: "pencil")
                        }
                    }
                    Button(action: {
                        sharingText = fileText
                        let av = UIActivityViewController(activityItems: [sharingText], applicationActivities: nil)
                                UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                   }) {
                       Label("Share",systemImage: "square.and.arrow.up")
                   }
                } label: {
                    Image(systemName: "list.bullet")
                }
            }
        ).toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                if wordsCount() > 0 {
                    Text("Words count: " + String(wordsCount()))
                }
                }
            }
        }.navigationBarTitle(fileName, displayMode: .inline).onAppear{
            if(!isNew && !isSaved) {
                setRecents(save: false)
            }
            if isNew {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.focus = true
            }
            }
        let text = FileController.read(fromDocumentsWithFileName: fileName)
            fileText = text
            sharingText = text
        }.alert(isPresented: $isExists, content: {
            Alert(title: Text("Error"), message: Text("File with this name is already exists!"), primaryButton: .cancel(), secondaryButton: .default(Text("Rename")){
                if(!isRename) {
                saveDialogIsOpen = true
                } else {
                    renameDialogIsOpen = true
                    isRename = false
                }
                
            })
        })
        

    }
}

struct TextEditing_Previews: PreviewProvider {
    static var previews: some View {
        TextEditing(textFile: TextFile.simpleFile, isNew: true, fileName: "unnamed")
    }
}
