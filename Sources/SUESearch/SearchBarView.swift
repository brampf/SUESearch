/*
 
 Copyright (c) <2020>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

import SwiftUI

public struct SearchBarView : View {
    
    @Binding var searchTerm : String
    
    @State private var edited : Bool = false
    
    public init(_ searchTerm: Binding<String>){
        self._searchTerm = searchTerm
    }
    
    public var body : some View {
        
        HStack{
            TextField("Search", text: $searchTerm, onCommit: {
                searchTerm = searchTerm
            })
                .textFieldStyle(PlainTextFieldStyle())
                .padding(3)
            self.clear
                .padding(.trailing, 3)
        }.background(RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color.secondary.opacity(0.3)))
            .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.secondary))
    }
    
    var clear : some View {
        Button(action: {
            self.searchTerm.removeAll()
        }) {
            Image(systemName: "xmark.circle.fill").foregroundColor(.secondary)
        }.buttonStyle(PlainButtonStyle())
        .disabled(!edited)
    }
    
}

struct SearchBarView_Previews: PreviewProvider {
    
    @State static var search : String = ""
    
    static var previews: some View {
        
        VStack{
            Text(search)
        SearchBarView($search)
            .padding()
            .preferredColorScheme(.light)
            .previewLayout(.fixed(width: 300, height: 100))
        }
    }
}
