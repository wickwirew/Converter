# Converter
Converter is an object mapper similar to [AutoMapper](https://github.com/AutoMapper/AutoMapper) for Swift. Converting an object of one type to a different type usually invloves writing a lot of boiler plate code. Converter is an automatic convetion based solution. Still a WIP, but nearing the end.

## Example
There comes time where you have two similar models. Say you have a `User` model. You want to send an API request to update the User but it takes a slimmed down version of `User` called `UserDTO`. Mapping `User` to `UserDTO` would usually involve writing manual code to covert it. With Converter:
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

// Choose property from it's key path
try createConversion(from: Person.self, to: Teacher.self)
     .for(property: "name", use: \.firstName)
     
// OR

// Closure to allow a combination
try createConversion(from: Person.self, to: Teacher.self)
     .for(property: "name", use: {"\($0.firstName) \($0.lastName)"})
```
So when the coversion runs it will now set the `name` property on teacher to the combination of `firstName` and `lastName`.

## Ignoring Properties
Say on one conversion you would like to omit one property from being set. Example:
```swift
try createConversion(from: Person.self, to: Teacher.self)
     .ignore(property: "lastName")
```
## Property Matching
Converter tries to be intelligent when matching properties on the source to the destination type. It will automatically handle mapping to and from diffenert casing styles, including `camelCasing`, `PascalCasing`, and `snake_casing`. 

So for example `Person` and `PersonPascal` can be automatically converted with no extra work:
```swift
struct Person {
    var id: Int
    var firstName: String
    var lastName: String
}

struct PersonPascal {
    var Id: Int
    var FirstName: String
    var LastName: String
}
```

Private properties sometimes are noted with an underscore at the beginning. Converter will automatically convert them as well. So for example `firstName` can be mapped automatically to `_firstName`. 

If you would like the conversion to match properties only the names are an exact match then when the conversion if created you can specify a `strict` matching policy.

Example:
```swift
try createConversion(from: Person.self, to: Teacher.self, matching: .strict)
```

## How Does it Work?
To get and set the values dynamically it uses my other library [Runtime](https://github.com/wickwirew/Runtime). Converter will automatically convert two objects when the property names are the same, and allows for custom mappings. The `createConversion(from: to:)` method defines a path of how it will be converted. Some of the more expensive operations are done once when the conversion is created making the conversion just a wee bit faster.

## Contributions
Anyone is welcome to contribute! It is still a work in progress. If there is something you would like implemented either send a pull request or open an issue. Any questions also feel free to open an issue.
