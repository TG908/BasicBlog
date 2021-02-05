---
date: 2020-08-05 20:00
description: Why I love using pragma marks for structuring my code
tags: swift, swift-style-guide
title: Declaring Protocol Conformance in Swift Extensions is bad Style
---

## Introduction

There are two ways of declaring protocol conformance of a type in Swift.

```swift
protocol MyProtocol {
    func someFunction()
    var someVariable: Int { get set }
}
```
The first way is declaring the protocol conformance when declaring your type and using a pragma mark to separate the code related to the protocol from unrelated code inside the type.

```swift
struct MyType: MyProtocol {

    // MARK: - MyProtocol
    var someVariable: Int = 0

    func someFunction() {

    }
}
```
Some people prefer creating extensions on their types to declare the conformance to a certain protocol.

```swift
struct MyType {

}

extension MyType: MyProtocol {

    var someVariable: Int { 0 }

    func someFunction() {

    }
}
```
Let's discuss the advantages and disadvantages of using extensions for protocol conformance.

## The Good

Using extensions for protocol conformance makes your code look cleaner. It separates the code in small independent units. That's it not much huh?

## The Bad

On the other side when using extensions you artificially limit yourself, since you cannot declare stored variables in extensions. Further, you cannot add property observers to existing variables inside of extensions.
Protocol conformances declared in extensions can also not be overwritten in subclasses.

IDE support for using extensions in this way is also not optimal. For example, the code minimap in Xcode does not highlight extensions in the same way as pragma marks, and the type overview does only display the name of the type the extension is extending. It does not mention the protocol being implemented which would be possible using pragma marks.

Declaring protocol conformance inside of extensions can also make your code harder to reason about at a glance. It is much easier to reason about a types capabilities when all implemented protocols are displayed at the top where the type is declared. When using extensions, protocol conformances can hide all over the entire code base and the reader has to search them manually.

## Conclusion

In my opinion, Swift extensions are not the right tool for structuring code. They artificially limit you, they don't enjoy the same IDE support as pragma marks do and they make your code harder to reason about at a glance. 
Pragma marks are a much better tool to structure and document your code, they have great IDE support and they don't limit you in the same way as Swift extensions do.

## Further Reading

[Google Swift Style Guide](https://google.github.io/swift/#extensions)

[LinkedIn Swift Style Guide](https://github.com/linkedin/swift-style-guide#36-protocols)

[Ray Wenderlich Swift Style Guide](https://github.com/raywenderlich/swift-style-guide#protocol-conformance)

[Swift Documentation for Extensions](https://docs.swift.org/swift-book/LanguageGuide/Extensions.html)

## Feedback

Do you like using extensions for protocol conformance? Did I forget any benefits of using extensions for protocol conformance?
Let me know on [GitHub Discussions](https://github.com/tgymnich/BasicBlog/discussions/8).

