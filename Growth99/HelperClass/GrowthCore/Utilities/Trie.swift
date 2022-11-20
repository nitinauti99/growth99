//
//  Trie.swift
//  Fargo
//
//  Created by Robin van Dijke on 6/1/16.
//  Copyright © 2016 Apple. All rights reserved.
//

public protocol Trie {
    associatedtype KeyElement: Hashable
    associatedtype Value

    var value: Value? { get }
    var children: [KeyElement: Self] { get set }

    init(value: Value?)
}

public extension Trie {
    mutating func insert(_ value: Value, forKey key: ArraySlice<KeyElement>) {
        guard let (key, rest) = key.decompose() else {
            // done inserting
            return
        }

        if self.children.keys.contains(key) {
            if rest.isEmpty {
                if let child = self.children[key] {
                    if child.value == nil {
                        var child = Self(value: value)
                        child.children = self.children[key]!.children

                        self.children[key]! = child
                    } else {
                        // value already exists
                        fatalError("Trying to insert a duplicate value")
                    }
                }
            } else {
                // insert in child
                self.children[key]!.insert(value, forKey: rest)
            }
        } else {
            var child: Self

            if rest.isEmpty {
                child = Self(value: value)
            } else {
                // no child found, make new
                child = Self(value: nil)

                // insert rest into child
                child.insert(value, forKey: rest)
            }

            // insert child
            self.children[key] = child
        }
    }

    func traverse(_ block: (_ keyElement: KeyElement?, _ value: Value?) -> Void) {
        self.traverse(nil, block: block)
    }

    func traverse(_ parentKeyElement: KeyElement?, block: (_ keyElement: KeyElement?, _ value: Value?) -> Void) {
        block(parentKeyElement, self.value)
        for (keyElement, trie) in self.children {
            trie.traverse(keyElement, block: block)
        }
    }

    func find(forKey key: ArraySlice<KeyElement>, selector: (Self, KeyElement, inout ArraySlice<KeyElement>) -> Self?) -> Value? {
        if key.isEmpty {
            // return our own value if an empty key is given
            return self.value
        }

        guard let decomposed = key.decompose() else {
            return nil
        }

        let keyElement = decomposed.0
        var rest = decomposed.1

        if let trie = selector(self, keyElement, &rest) {
            return trie.find(forKey: rest, selector: selector)}

        return nil
    }
}
