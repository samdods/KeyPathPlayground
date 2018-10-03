
struct Address {
    let street: String
    let city: String
    let id: String?
}

struct Person {
    let name: String
    let address: Address
}

let people = [
    Person(name: "Tom",address: Address(street: "Regent Street", city: "London", id: nil)),
    Person(name: "Dick", address: Address(street: "", city: "Nottingham", id: nil)),
    Person(name: "Harry", address: Address(street: "", city: "London", id: "1b0d")),
    Person(name: "Alice", address: Address(street: "London Road", city: "Edinburgh", id: nil)),
    Person(name: "Bob", address: Address(street: "The Avenue", city: "Nottingham", id: "0xg2")),
    Person(name: "Charles", address: Address(street: "", city: "Leicester", id: nil)),
]

prefix operator ~

/// Allows a key path to be passed into mapping functions
prefix func ~<A, B>(_ keyPath: KeyPath<A, B>) -> (A) -> B {
    return { $0[keyPath: keyPath] }
}

/// Allows a key path to be passed into sorting functions
prefix func ~<A, B>(_ keyPath: KeyPath<A, B>) -> (A, A) -> Bool where B: Comparable {
    return { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
}

/// Allows a Boolean-type key path to be passed into filter-like functions,
/// e.g. `filter`, `first(where:)`, `drop(while:)`, etc.
prefix func ~<A>(_ keyPath: KeyPath<A, Bool>) -> (A) -> Bool {
    return { $0[keyPath: keyPath] }
}

//: ## map, compactMap

// list of names for each person
people.map(~\.name)

// list of cities for each person
people.map(~\.address.city)

// list of IDs for each person's address, where present
people.compactMap(~\.address.id)

//: ## sort, sorted

var p2 = people
p2.sort(by: ~\.name)

// people sorted by name
people.sorted(by: ~\.name)

// people sorted by their address city
people.sorted(by: ~\.address.city)

// people sorted by their address city in reverse
people.sorted(by: ~\.address.city).reversed()

// the names of the people sorted by name
people.sorted(by: ~\.name).map(~\.name)
// => ["Alice", "Bob", "Charles", "Dick", "Harry", "Tom"]

//: ## filter

// only people with empty street in their address
people.filter(~\.address.street.isEmpty)

// the names of the people with non-empty street
people.filter(~\.address.street.isEmpty).map(~\.name)
// => ["Tom", "Alice", "Bob"]

extension Bool {
    /// Returns true for false and false for true
    var inverted: Bool {
        return !self
    }
}

// only people with non-empty street
people.filter(~\.address.street.isEmpty.inverted)

// the first person whose street address is empty
people.first(where: ~\.address.street.isEmpty)

