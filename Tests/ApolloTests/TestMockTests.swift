import XCTest
import Nimble
@testable import Apollo
import ApolloTestSupport
import ApolloAPI

class TestMockTests: XCTestCase {

  func test__mock_givenObject__hasTypenameSet() throws {
    // given
    let mock = Mock<Dog>()

    // then
    expect(mock._data["__typename"] as? String).to(equal("Dog"))
    expect(mock.__typename).to(equal("Dog"))
  }

  func test__mock__setScalarField__fieldIsSet() throws {
    // given
    let mock = Mock<Dog>()

    // when
    mock.species = "Canine"

    // then
    expect(mock._data["species"] as? String).to(equal("Canine"))
    expect(mock.species).to(equal("Canine"))
  }

  func test__mock__setScalarField_toNil__fieldIsSetToNil() throws {
    // given
    let mock = Mock<Dog>()

    // when
    mock.species = "Canine"
    mock.species = nil

    // then
    expect(mock._data["species"]).to(beNil())
    expect(mock.species).to(beNil())
  }

  func test__mock__setListOfScalarField__fieldIsSet() throws {
    // given
    let mock = Mock<Dog>()

    // when
    mock.listOfStrings = ["a", "b", "c"]

    // then
    expect(mock._data["listOfStrings"] as? [String]).to(equal(["a", "b", "c"]))
    expect(mock.listOfStrings).to(equal(["a", "b", "c"]))
  }

  func test__mock__setObjectField__fieldIsSet() throws {
    // given
    let mock = Mock<Dog>()
    let height = Mock<Height>()

    // when
    height.meters = 1
    mock.height = height
    height.feet = 2
    mock.height?.yards = 3

    // then
    expect(mock._data["height"] as? Mock<Height>).to(beIdenticalTo(height))
    expect(mock.height?.meters).to(equal(1))
    expect(mock.height?.feet).to(equal(2))
    expect(mock.height?.yards).to(equal(3))
  }

  func test__mock__setListOfObjectsField__fieldIsSet() throws {
    // given
    let mock = Mock<Dog>()
    let cat1 = Mock<Cat>()
    let cat2 = Mock<Cat>()
    let cat3 = Mock<Cat>()

    // when
    mock.listOfObjects = [cat1, cat2, cat3]

    // then
    expect(mock._data["listOfObjects"] as? [Mock<Cat>]).to(equal([cat1, cat2, cat3]))
    expect(mock.listOfObjects).to(equal([cat1, cat2, cat3]))
  }

  func test__mock__setNestedListOfObjectsField__fieldIsSet() throws {
    // given
    let mock = Mock<Dog>()
    let cat1 = Mock<Cat>()
    let cat2 = Mock<Cat>()
    let cat3 = Mock<Cat>()

    // when
    mock.nestedListOfObjects = [[cat1, cat2, cat3]]

    // then
    expect(mock._data["nestedListOfObjects"] as? [[Mock<Cat>]]).to(equal([[cat1, cat2, cat3]]))
    expect(mock.nestedListOfObjects).to(equal([[cat1, cat2, cat3]]))
  }

  func test__mock__setListOfOptionalObjectsField__fieldIsSet() throws {
    // given
    let mock = Mock<Dog>()
    let cat1 = Mock<Cat>()
    let cat2 = Mock<Cat>()

    // when
    mock.listOfOptionalObjects = [cat1, nil, cat2, nil]

    // then
    expect(mock._data["listOfOptionalObjects"] as? [Mock<Cat>?]).to(equal([cat1, nil, cat2, nil]))
    expect(mock.listOfOptionalObjects).to(equal([cat1, nil, cat2, nil]))
  }

  func test__mock__setInterfaceField__fieldIsSet() throws {
    // given
    let mock = Mock<Dog>()
    let cat = Mock<Cat>()

    // when
    mock.bestFriend = cat

    // then
    expect(mock._data["bestFriend"] as? Mock<Cat>).to(beIdenticalTo(cat))
    expect(mock.bestFriend as? Mock<Cat>).to(beIdenticalTo(cat))
  }

  func test__mock__setListOfInterfacesField__fieldIsSet() throws {
    // given
    let mock = Mock<Dog>()
    let cat1 = Mock<Cat>()
    let cat2 = Mock<Cat>()
    let dog1 = Mock<Dog>()

    let list: [AnyMock] = [cat1, cat2, dog1]
    let expected = NSArray(array: list)

    // when
    mock.listOfInterfaces = list

    // then
    expect(expected.isEqual(to: mock._data["listOfInterfaces"] as? [AnyMock])).to(beTrue())
    expect(expected.isEqual(to: mock.listOfInterfaces as [AnyMock]?)).to(beTrue())
  }

  func test__mock__setNestedListOfInterfacesField__fieldIsSet() throws {
    // given
    let mock = Mock<Dog>()
    let cat1 = Mock<Cat>()
    let cat2 = Mock<Cat>()
    let dog1 = Mock<Dog>()

    let list: [[AnyMock]] = [[cat1, cat2, dog1]]
    let expected = NSArray(array: list)

    // when
    mock.nestedListOfInterfaces = list

    // then
    expect(expected.isEqual(to: mock._data["nestedListOfInterfaces"] as? [[AnyMock]])).to(beTrue())
    expect(expected.isEqual(to: mock.nestedListOfInterfaces as [[AnyMock]]?)).to(beTrue())
  }


  func test__mock__setListOfOptionalInterfacesField__fieldIsSet() throws {
    // given
    let mock = Mock<Dog>()
    let cat1 = Mock<Cat>()
    let cat2 = Mock<Cat>()

    let list: [AnyMock?] = [cat1, nil, cat2, nil]
    let expected = NSArray(array: list as [Any])

    // when
    mock.listOfOptionalInterfaces = list

    // then
    expect(expected.isEqual(to: mock._data["listOfOptionalInterfaces"] as? [AnyMock?])).to(beTrue())
    expect(expected.isEqual(to: mock.listOfOptionalInterfaces as [AnyMock?]?)).to(beTrue())
  }

  // MARK: Argument Field Tests

  func test__mock__setScalarArgumentFieldValue_valueIsSetForArgument() throws {
    // given
    let mock = Mock<Cat>()

    // when
    mock.scalarArgField[arg: "1"] = "Test"

    // then
    expect((mock._data["scalarArgField(arg:1)"] as? String)).to(equal("Test"))
    expect(mock.scalarArgField[arg: "1"]).to(equal("Test"))
  }

  func test__mock__setScalarArgumentFieldValue_valueIsNotSetForOtherArgument() throws {
    // given
    let mock = Mock<Cat>()

    // when
    mock.scalarArgField[arg: "1"] = "Test"

    // then
    expect(mock.scalarArgField[arg: "2"]).to(beNil())
  }

  func test__mock__setScalarMultipleArgumentFieldValue_valueIsSetForArgumentsOrderIndependent() throws {
    // given
    let mock = Mock<Cat>()

    // when
    mock.scalarMultipleArgNonAlphabeticalField[bArg: "B", aArg: 10] = 12345

    // then
    expect((mock._data["scalarMultipleArgNonAlphabeticalField(aArg:10,bArg:B)"] as? Int))
      .to(equal(12345))
    expect(mock.scalarMultipleArgNonAlphabeticalField[bArg: "B", aArg: 10])
      .to(equal(12345))
  }

  // MARK: JSONEncodable Tests

  func test__jsonValue__givenObjectFieldSetToOtherObject__convertsObjectToJSONDict() throws {
    // given
    let mock = Mock<Dog>()
    let height = Mock<Height>()

    // when
    height.meters = 1
    height.feet = 2
    mock.height = height
    mock.height?.yards = 3

    let actual = mock._jsonObject
    let heightDict = actual["height"] as? JSONObject

    // then
    expect(actual["height"]).to(beAKindOf(JSONObject.self))
    expect(heightDict?["meters"] as? Int).to(equal(1))
    expect(heightDict?["feet"] as? Int).to(equal(2))
    expect(heightDict?["yards"] as? Int).to(equal(3))
  }
}

class Dog: Object {
  override public class var __typename: StaticString { "Dog" }
  override public class var __implementedInterfaces: [Interface.Type]? { _implementedInterfaces }
  private static let _implementedInterfaces: [Interface.Type]? = [
    Animal.self
  ]
}

class Cat: Object {
  override public class var __typename: StaticString { "Dog" }
  override public class var __implementedInterfaces: [Interface.Type]? { _implementedInterfaces }
  private static let _implementedInterfaces: [Interface.Type]? = [
    Animal.self
  ]  
}

class Height: Object {
  override public class var __typename: StaticString { "Height" }
}

class Animal: Interface {}

// MARK: Mockable Extensions

extension Dog: Mockable {
  static let __mockFields = MockFields()

  struct MockFields {
    @Field<String>("id") public var id
    @Field<String>("species") public var species
    @Field<Height>("height") public var height
    @Field<[String]>("listOfStrings") public var listOfStrings
    @Field<Animal>("bestFriend") public var bestFriend
    @Field<[Cat]>("listOfObjects") public var listOfObjects
    @Field<[[Cat]]>("nestedListOfObjects") public var nestedListOfObjects
    @Field<[Cat?]>("listOfOptionalObjects") public var listOfOptionalObjects
    @Field<[Animal]>("listOfInterfaces") public var listOfInterfaces
    @Field<[[Animal]]>("nestedListOfInterfaces") public var nestedListOfInterfaces
    @Field<[Animal?]>("listOfOptionalInterfaces") public var listOfOptionalInterfaces
  }
}

extension Cat: Mockable {
  static let __mockFields = MockFields()

  struct MockFields {
    @Field<String>("id") public var id
    @Field<Height>("height") public var height
    @Field<Animal>("bestFriend") public var bestFriend
    @Field<[Animal]>("predators") public var predators
    @Field<String>("species") public var species

    @Field<ScalarArgField>("scalarArgField") public var scalarArgField
    public class ScalarArgField: ArgumentField<String> {
      public subscript(arg arg: String) -> String? {
        get { getValue(for: ["arg": arg]) }
        set { set(newValue, for: ["arg": arg]) }
      }
     }

    @Field<ScalarMultipleArgNonAlphabeticalField>(
      "scalarMultipleArgNonAlphabeticalField"
    ) public var scalarMultipleArgNonAlphabeticalField
    public class ScalarMultipleArgNonAlphabeticalField: ArgumentField<Int> {
      public subscript(
        bArg bArg: String,
        aArg aArg: Int
      ) -> Int? {
        get { getValue(for: ["bArg": bArg, "aArg": aArg]) }
        set { set(newValue, for: ["bArg": bArg, "aArg": aArg]) }
      }
     }
  }
}

extension Height: Mockable {
  static let __mockFields = MockFields()

  struct MockFields {
    @Field<Int>("meters") public var meters
    @Field<Int>("feet") public var feet
    @Field<Int>("yards") public var yards
    @Field<Int>("inches") public var inches
  }
}
