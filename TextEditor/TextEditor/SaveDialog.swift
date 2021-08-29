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
    @Environment(\.dismiss) var dismiss
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
               dismiss()
                }
            },
                   label: {
                Text("Save with this name").scaledToFit().minimumScaleFactor(0.5).frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white).background(isNameAvailable ? .blue : .gray) .cornerRadius(20).padding(.horizontal, 45).font(.title).padding(.vertical,10)
            })
          
        }.navigationBarTitle(Text("Set file name"), displayMode: .inline).navigationBarItems(trailing:
                                                                                                Button("Cancel"){
            dismiss()
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
