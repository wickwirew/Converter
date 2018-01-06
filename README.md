![Converter](https://github.com/wickwirew/Converter/blob/master/Resources/Converter.png)

## Converter
Converter is an automatic convention based object mapper similar to [AutoMapper](https://github.com/AutoMapper/AutoMapper) for Swift.

## Why?
There comes time where you have two models, with similar properties, that follow the same naming standard. Whether it's a domain model for your persistance layer, a DTO for an API request, or just a slimmed down version. Mapping the object between types usually results in a lot of boiler plate code manually mapping each property. Converter takes the hassle away and does it automatically base off the naming convention.

## Example
For example we have the `Source` type. We want to be able to convert objects of the `Source` type to `Destination`. So first we have to create the conversion. The conversions are static and only need to be created once, usually when the application is started.
```swift
try createConversion(from: Source.self, to: Destination.self)
```
Once the conversion is created to convert the object:
```swift
let newObject = try convert(mySourceObject, to: Destination.self)
```
It's that easy! No boiler plate code to write 🎉.

## AWS Example
If you use the AWS Mobile Hub when it generates the domain models for the DynamoDb instance every property is prefixed with an underscore, and they are classes by default. Say you would like to use structs instead and not have the underscore you would normally have to write code to convert the AWS domain model to the struct model. Converter will do this automatically!
```swift
class PetDomain: AWSDynamoDBObjectModel, AWSDynamoDBModeling { 
    var _userId: String?
    var _name: String?
    var _age: Int
}

struct Pet { 
    var userId: String?
    var name: String?
    var age: Int
}

try createConversion(from: PetDomain.self, to: Pet.self)

let pet = try convert(domain, to: Pet.self)
```

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
Converter tries to be intelligent when matching properties on the source to the destination type. It will automatically handle mapping to and from different casing styles, including `camelCasing`, `PascalCasing`, and `snake_casing`. So for example `SomePropertyName` or `some_property_name` can be instantly mapped to and from `somePropertyName`

Private properties sometimes are noted with an underscore at the beginning. Converter will automatically convert them as well. So for example `firstName` can be mapped automatically to and from `_firstName`. 

If you would like the conversion to match properties only when the names are an exact match then when the conversion if created you can specify a `strict` matching policy.

Example:
```swift
try createConversion(from: Person.self, to: Teacher.self, matching: .strict)
```

## Flattening
Converter also has the ability to flatten out objects, allowing you to automatically pull values out of nested objects with no extra work. For example we have the `Person` type which has a property of type `Pet`. `Pet` objects have a name property. Our destination type would like the pet name to be at the top level. `Person`'s pet property name is `pet` and we would like to flatten out it's `name` property. So by naming our destination property `petName`, Converter will translate that too `pet.name` and grab the value.
```swift
struct Pet {
     var name: String
}

struct Person {
    var pet: Pet
}
        
struct FlattenedPerson {
    var petName: String
}

try createConversion(from: Person.self, to: FlattenedPerson.self)

let source = Person(pet: Pet(name: "Marley"))
let person: Destination = try convert(source)
print(person.petName) // prints Marley
```

## Arrays
Conversions can be made from an array of a source type to an array of the destination type. Example:
```swift
try createConversion(from: Source.self, to: Destination.self)
let new: [Destination] = try convert(arrayOfSourceObjects)
```

## How Does it Work?
To get and set the values dynamically it uses my other library [Runtime](https://github.com/wickwirew/Runtime). Converter will automatically convert two objects when the property names are the same, and allows for custom mappings. The `createConversion(from: to:)` method defines a path of how it will be converted. Some of the more expensive operations are done once when the conversion is created making the conversion just a wee bit faster.

## Contributions
Anyone is welcome to contribute! It is still a work in progress. If there is something you would like implemented either send a pull request or open an issue. Any questions also feel free to open an issue.

## License
Converter is available under the MIT license. See the LICENSE file for more info.
