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

public struct MatchedText<Element> : View {
    
    @Binding var searchTerm : String
    
    
    var element: Element
    var property: KeyPath<Element,String>
    
    var match: Match = .start
    var ignoresCase : Bool = false
    
    public init(_ element: Element,
                _ property: KeyPath<Element,String>,
                match: Match = .start,
                ignoresCase: Bool = false,
                matches searchTerm: Binding<String>){
        self.element = element
        self.property = property
        self.match = match
        self.ignoresCase = ignoresCase
        self._searchTerm = searchTerm
    }
    
    @ViewBuilder public var body : some View {
        switch match {
            case .start : matchStart
            case .anywhere : matchAnywhere
            case .trailing: matchTrail
        }
    }
    
    @ViewBuilder var matchStart : some View {
        
        let string = element[keyPath: property]
        
        if string.match(searchTerm, match, ignoresCase){
            HStack(spacing: 0){
                Text(string.dropLast(string.count-searchTerm.count)).bold()
                Text(string.dropFirst(searchTerm.count))
            }
        } else {
            Text(string)
        }
    }
    
    @ViewBuilder var matchAnywhere : some View {
        
        let string = element[keyPath: property]
        
        if string.match(searchTerm, match, ignoresCase), let range = string.range(of: searchTerm) {
            
            HStack(spacing: 0){
                Text(string.prefix(upTo: range.lowerBound))
                Text(searchTerm).bold()
                Text(string.suffix(from: range.upperBound))
            }
        } else {
            Text(string)
        }
    }
    
    @ViewBuilder var matchTrail : some View {
        
        let string = element[keyPath: property]
        
        if string.match(searchTerm, match, ignoresCase){
            HStack(spacing: 0){
                Text(string.dropLast(searchTerm.count))
                Text(string.dropFirst(string.count-searchTerm.count)).bold()
            }
        } else {
            Text(string)
        }
    }
}

extension MatchedText where Element == String {
    
    public init(_ element: String,
                match: Match = .start,
                ignoresCase: Bool = false,
                matches searchTerm: Binding<String>) {
        
        self.element = element
        self.property = \.self
        self.match = match
        self.ignoresCase = ignoresCase
        self._searchTerm = searchTerm
    }
}


struct MatchedText_Previews: PreviewProvider {
    
    @State static var string : String = "Chris"
    
    static var previews: some View {
        Group{
            List{
                MatchedText("Mary", matches: $string)
                MatchedText("Chris", matches: $string)
                MatchedText("Christophe", matches: $string)
                MatchedText("Christine", matches: $string)
                MatchedText("David", matches: $string)
                MatchedText("Miller, Christian", matches: $string)
            }.padding()
            
            List{
                MatchedText("Mary", match: .anywhere, matches: $string)
                MatchedText("Chris", match: .anywhere, matches: $string)
                MatchedText("Christophe", match: .anywhere, matches: $string)
                MatchedText("Christine",match: .anywhere,  matches: $string)
                MatchedText("David", match: .anywhere, matches: $string)
                MatchedText("Miller, Christian", match: .anywhere, matches: $string)
            }.padding()
            
            List{
                MatchedText("MaryChris", match: .trailing, matches: $string)
                MatchedText("Chris", match: .trailing, matches: $string)
                MatchedText("Christophe", match: .trailing, matches: $string)
                MatchedText("Christine", match: .trailing, matches: $string)
                MatchedText("David", match: .trailing, matches: $string)
                MatchedText("Miller, Christian", match: .trailing, matches: $string)
            }.padding()
        }
    }
}
