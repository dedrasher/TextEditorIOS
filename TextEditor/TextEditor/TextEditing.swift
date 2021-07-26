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
    @State var showOptionsMenu = false
    @State var isSaved = false
    @State var textFile: TextFile = TextFile.simpleFile
    @State var isExists = false
    @State var sharing = false
    @State var isNew : Bool
    @State private var fileText = ""
    @State private var saveDialogIsOpen = false
    @State var fileName : String
  func setRecents(save: Bool = true) {
        if(save) {
        FileController.save(text:fileText, withFileName: fileName)
            isSaved = true
        }
      if(textFile != TextFile.simpleFile) {
          Preferences.recents.remove(at: Preferences.recents.firstIndex(of: textFile) ?? 0)
      }
     Preferences.recents.append(TextFile(name: fileName, date: DateHelper.date()))
      textFile = Preferences.recents[Preferences.recents.count - 1]
     Preferences.SaveRecents()
    }
    var body: some View {
        VStack{
            TextEditor(text: $fileText).submitLabel(SubmitLabel.done).textAlert(isPresented: $saveDialogIsOpen,
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
                                                                                                                                   isNew = false
                                                                                                                                   setRecents(save: false)
                                                                                                                                FileController.rename(oldName: oldName, newName: fileName,fileText: fileText)
                                                                                                                                   }
                                                                                                                               }
            })
            
            
            
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }.toolbar{
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                   if isNew {
               saveDialogIsOpen = true
                   } else {
                       setRecents()
                   }
               }) {
                   Image(systemName: "folder")
               }
                Button(action: {
                    sharingText = fileText
                 sharing = true
               }) {
                   Image(systemName: "square.and.arrow.up")
               }
            }
           
            ToolbarItem(placement: .bottomBar) {
                if isSaved || !isNew {
                    HStack {
                        Spacer()
                        Button(action: {
                          showOptionsMenu = true
                       }) {
                           Image(systemName: "list.bullet")
                       }
                    }
            }
            }
                
                }.navigationBarTitle(fileName, displayMode: .inline).onAppear{
        let text = FileController.read(fromDocumentsWithFileName: fileName)
            fileText = text
            sharingText = text
        }.onWillDisappear {
            if(!isNew && !isSaved) {
                setRecents(save: false)
            }
        }.sheet(isPresented: $sharing, content: {
            ActivityViewController(activityItems: [sharingText], applicationActivities: nil)
        }).alert(isPresented: $isExists, content: {
            Alert(title: Text("Error"), message: Text("File with this name is already exists!"), primaryButton: .cancel(), secondaryButton: .default(Text("Rename")){
                if(!isRename) {
                saveDialogIsOpen = true
                } else {
                    renameDialogIsOpen = true
                    isRename = false
                }
                
            })
        }).actionSheet(isPresented: $showOptionsMenu) {
            ActionSheet(title: Text("Options menu"), buttons: [.default(Text("Rename")) {
                renameDialogIsOpen = true
            }, .cancel()])
        }
        

    }
}

struct TextEditing_Previews: PreviewProvider {
    static var previews: some View {
        TextEditing(textFile: TextFile.simpleFile, isNew: true, fileName: "unnamed")
    }
}
