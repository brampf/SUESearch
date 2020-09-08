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

import Foundation

public enum Match {
    case start
    case anywhere
    case trailing
}

extension Array {
    
    public func filter(_ property: KeyPath<Element,String>, by search: String, _ match: Match = .start, _ caseSensitive: Bool = false) -> Self {
        return self.filter { element in
            element[keyPath: property].match(search, match, caseSensitive)
        }
    }
    
}

extension String {
    
    public func match(_ string: String, _ match: Match = .start, _ caseSensitive: Bool = false) -> Bool {
        
        switch match {
        case .start:
            if caseSensitive {
                return self.starts(with: string)
            } else {
                return self.lowercased().starts(with: string.lowercased())
            }
            
        case .anywhere:
            if caseSensitive {
                return self.contains(string)
            } else {
                return self.lowercased().contains(string.lowercased())
            }
            
        case .trailing:
            
            if caseSensitive {
                return self.reversed().starts(with: string.reversed())
            } else {
                return self.lowercased().reversed().starts(with: string.lowercased().reversed())
            }
        }
        
    }
    
}

extension Optional where Wrapped == String {
    
    public func match(_ string: String, _ match: Match = .start, _ caseSensitive: Bool = false) -> Bool {
        return self?.match(string, match, caseSensitive) ?? false
    }
}
