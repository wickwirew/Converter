# Converter
Converter is an object mapper similar to [AutoMapper](https://github.com/AutoMapper/AutoMapper) for Swift. Converting an object of one type to a different type usually invloves writing a lot of boiler plate code. Converter is an automatic convetion based solution. Still a WIP, but nearing the end.

## Example
There comes time where you have two similar models. Say you have a `User` model. You want to send an API request to update the User but it is a slimmed down version called `UserDTO`. Mapping `User` to `UserDTO` would usually involve writing manual code to coverter it. With Converter:
```swift
// Create conversion
try createConversion(from: User.self, to: UserDTO.self)
// Convert object
let dto = try convert(user, to: UserDTO.self)
```
It's that easy! No boiler plate code to write 🎉.

## Custom Maps
Say you have two models that are similar but the property names dont match perfectly. Or even one property in the destination type is a combination of two on the source type. To define a custom map for a property:
```swift
struct Person {
    var id: Int
    var firstName: String
    var lastName: String
    var age: Int
}

struct Teacher {
    var id: Int
    var name: String
    var age: Int
}

// Conversion with custom property map
try! createConversion(from: Person.self, to: Teacher.self)
      .for(property: "name", do: {s,d in d.name = "\(s.firstName) \(s.lastName)"})
```
So when the coversion runs it will now set the `name` property on teacher to the combination of `firstName` and `lastName`.

## Ignoring Properties
Say on one conversion you would like to omit one property from being set. Example:
```swift
try createConversion(from: Person.self, to: Teacher.self)
     .ignore(property: "lastName")
```

## How Does it Work?
Converter will automatically convert two objects when the property names are the same, and allows for custom mappings. The `createConversion(from: to:)` method defines a path of how it will be converted. Some of the more expensive operations are done once when the conversion is created making the conversion just a wee bit faster. To get and set the values dynamically it uses my other library [Runtime](https://github.com/wickwirew/Runtime)

## Contributions
Anyone is welcome to contribute! It is still a work in progress. If there is something you would like implemented either send a pull request or open an issue. Any questions also feel free to open an issue.
