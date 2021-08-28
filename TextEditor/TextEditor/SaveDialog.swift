//
//  SaveDialog.swift
//  SaveDialog
//
//  Created by Serega on 28.08.2021.
//

import SwiftUI
struct SaveDialog: View {
    @FocusState var focus: Bool
    @Binding var fileName : String
    @State var successCompletion : (()->Void)?
    @Environment(\.presentationMode) var presentationMode
    var isNameAvailable: Bool {
        get {
            return !FileController.ExistsInRecents(fileName: fileName)
        }
    }
    var displayAttention: Bool {
        get {
            return !isNameAvailable && fileName.count > 0
        }
    }
    var body: some View {
        NavigationView {
        VStack {
            TextField("Enter file name", text: $fileName)
                              .padding(10)
                                .font(.largeTitle)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(!displayAttention ? Color.blue : Color.red, lineWidth: 2)).padding(.horizontal).focused($focus, equals: true)
            if displayAttention {
            Text("Name is not available" ).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal).foregroundColor(.red)
            }
            Spacer()
            Button(action: {
                if(isNameAvailable) {
                    successCompletion?()
                presentationMode.wrappedValue.dismiss()
                }
            },
                   label: {
                Text("Save with this name").scaledToFit().minimumScaleFactor(0.5).frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white).background(.blue) .cornerRadius(20).padding(.horizontal, 45).font(.title)
            })
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            },
                   label: {
                Text("Cancel").frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white).background(.gray) .cornerRadius(20).padding(.horizontal, 45).font(.title)
            })
        }.navigationBarTitle(Text("Set file name"), displayMode: .inline).navigationBarItems(trailing:
            Button(action: {
            presentationMode.wrappedValue.dismiss()              }) {
                                Image(systemName: "multiply.circle.fill").foregroundColor(.gray).scaleEffect(0.85)
                                                                                .font(Font.system(.title))
                                                                                                                        }
                                                                                                                    )
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.focus = true
        }
        }
    }

}
struct SaveDialog_Previews: PreviewProvider {
    static var previews: some View {
        SaveDialog(fileName: .constant(""))
    }
}
