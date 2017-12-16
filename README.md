# Converter
Converter is an object mapper similar to [AutoMapper](https://github.com/AutoMapper/AutoMapper) for Swift. Converting an object of one type to a different type usually invloves writing a lot of boiler plate code. Converter is an automatic convetion based solution. Still a WIP, but nearing the end.

# Example
There comes time where you have two similar models. Say you have a `User` model. You want to send an API request to update the User but it is a slimmed down version called `UserDTO`. Mapping `User` to `UserDTO` would usually involve manual code to coverter it. With Converter:
```swift
// Create conversion
try createConversion(from: User.self, to: UserDTO.self)
// Convert object
let dto = try convert(user, to: UserDTO.self)
```
It's that easy! No boiler plate code to write 🎉.

# Custom Maps
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

# Ignoring Properties
Say on one conversion you would like to omit one property from being set. Example:
```swift
try createConversion(from: Person.self, to: Teacher.self)
     .ignore(property: "lastName")
```

