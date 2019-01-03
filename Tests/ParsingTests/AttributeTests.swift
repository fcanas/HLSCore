import XCTest
@testable import Parsing
import Types

class AttributeValueTests: XCTestCase {

    func testFloatingPoint() {
        XCTAssertNil(TypeParser.float.run("")?.0)
        XCTAssertNil(TypeParser.float.run("A0.1")?.0)
        XCTAssertNil(TypeParser.float.run("\n0.1")?.0)
        XCTAssertNil(TypeParser.float.run("1")?.0)
        XCTAssertNil(TypeParser.float.run("0")?.0)
        XCTAssertNil(TypeParser.float.run("-1")?.0)
        XCTAssertNil(TypeParser.float.run("-1.1")?.0)

        XCTAssertEqual(TypeParser.float.run("0.1")!.0, 0.1, accuracy: 0.0001)
        XCTAssertEqual(TypeParser.float.run("1.1")!.0, 1.1, accuracy: 0.0001)
        XCTAssertEqual(TypeParser.float.run("18446744073709551615.18446744073709551615")!.0, 18446744073709551615.18446744073709551615, accuracy: 0.0001)
    }

    func testSignedFloatingPoint() {
        XCTAssertNil(TypeParser.signedFloat.run("")?.0)
        XCTAssertNil(TypeParser.signedFloat.run("A0.1")?.0)
        XCTAssertNil(TypeParser.signedFloat.run("\n0.1")?.0)
        XCTAssertNil(TypeParser.signedFloat.run("1")?.0)
        XCTAssertNil(TypeParser.signedFloat.run("0")?.0)
        XCTAssertNil(TypeParser.signedFloat.run("-1")?.0)

        XCTAssertEqual(TypeParser.signedFloat.run("0.1")!.0.rawValue, 0.1, accuracy: 0.0001)
        XCTAssertEqual(TypeParser.signedFloat.run("1.1")!.0.rawValue, 1.1, accuracy: 0.0001)
        XCTAssertEqual(TypeParser.signedFloat.run("18446744073709551615.18446744073709551615")!.0.rawValue, 18446744073709551615.18446744073709551615, accuracy: 0.0001)

        XCTAssertEqual(TypeParser.signedFloat.run("-0.1")!.0.rawValue, -0.1, accuracy: 0.0001)
        XCTAssertEqual(TypeParser.signedFloat.run("-1.1")!.0.rawValue, -1.1, accuracy: 0.0001)
        XCTAssertEqual(TypeParser.signedFloat.run("-18446744073709551615.18446744073709551615")!.0.rawValue, -18446744073709551615.18446744073709551615, accuracy: 0.0001)
    }

    func testQuotedString() {
        XCTAssertNil(TypeParser.quoteString.run("something"))
        XCTAssertNil(TypeParser.quoteString.run("something\""))
        XCTAssertNil(TypeParser.quoteString.run("\"something\nelse\""))
        XCTAssertNil(TypeParser.quoteString.run("\"something\relse\""))
        XCTAssertNil(TypeParser.quoteString.run("\"something\r\nelse\""))

        XCTAssertEqual(TypeParser.quoteString.run("\"\"")?.0, "")
        XCTAssertEqual(TypeParser.quoteString.run("\"something\"")?.0, "something")
        XCTAssertEqual(TypeParser.quoteString.run("\"something\" else")?.0, "something")
    }

    func testEnumeratedString() {
        XCTAssertNil(TypeParser.enumString.run("")?.0)
        XCTAssertNil(TypeParser.enumString.run("\n")?.0)
        XCTAssertEqual(TypeParser.enumString.run("A B")?.0.rawValue, "A")
        XCTAssertEqual(TypeParser.enumString.run("A\nB")?.0.rawValue, "A")
        XCTAssertEqual(TypeParser.enumString.run("A\rB")?.0.rawValue, "A")
        XCTAssertEqual(TypeParser.enumString.run("A\tB")?.0.rawValue, "A")
        XCTAssertEqual(TypeParser.enumString.run("A\"B")?.0.rawValue, "A")
        XCTAssertEqual(TypeParser.enumString.run("A,B")?.0.rawValue, "A")

        XCTAssertEqual(TypeParser.enumString.run("Abcd efg")?.0.rawValue, "Abcd")
        XCTAssertEqual(TypeParser.enumString.run("Abcd\nefg")?.0.rawValue, "Abcd")
        XCTAssertEqual(TypeParser.enumString.run("Abcd\refg")?.0.rawValue, "Abcd")
        XCTAssertEqual(TypeParser.enumString.run("Abcd\tefg")?.0.rawValue, "Abcd")
        XCTAssertEqual(TypeParser.enumString.run("Abcd\"efg")?.0.rawValue, "Abcd")
        XCTAssertEqual(TypeParser.enumString.run("Abcd,efg")?.0.rawValue, "Abcd")
    }

    func testDecimalResolution() {
        XCTAssertNil(decimalResolution.run("1234x")?.0)
        XCTAssertNil(decimalResolution.run("1234x")?.0)

        XCTAssertEqual(TypeParser.resolution.run("1x1")?.0, Resolution(width: 1, height: 1))
        XCTAssertEqual(TypeParser.resolution.run("1x2")?.0, Resolution(width: 1, height: 2))
        XCTAssertEqual(TypeParser.resolution.run("1234x5678")?.0, Resolution(width: 1234, height: 5678))
        XCTAssertEqual(TypeParser.resolution.run("1920x1080")?.0, Resolution(width: 1920, height: 1080))
    }

    static var allTests: [(String, (AttributeValueTests) -> () throws -> Void)] {
        return [
            ("testFloatingPoint", testFloatingPoint),
            ("testSignedFloatingPoint", testSignedFloatingPoint),
            ("testQuotedString", testQuotedString),
            ("testEnumeratedString", testEnumeratedString),
            ("testDecimalResolution", testDecimalResolution)
        ]
    }
}

class AttributeListTests: XCTestCase {

    func testSingleIntegerAttribute() {
        // Integer
        let intAttribute = "NAME=12"
        let (parsedIntAL, _) = attributeList.run(intAttribute)!
        let expectedIntAL: AttributeList = ["NAME": AttributeValue.decimalInteger(12)]
        XCTAssertEqual(parsedIntAL, expectedIntAL)
    }

    func testSingleHexAttribute() {
        // Hex
        let hexAttribute = "NAME=0x12"
        let (parsedHexAL, _) = attributeList.run(hexAttribute)!
        let expectedHexAL: AttributeList = ["NAME": AttributeValue.hexadecimalSequence(HexadecimalSequence(value: 0x12))]
        XCTAssertEqual(parsedHexAL, expectedHexAL)
    }

    func testSingleFloatAttribute() {
        // Float
        let floatAttribute = "NAME=12.123"
        let (parsedFloatAL, _) = attributeList.run(floatAttribute)!
        let expectedFloatAL: AttributeList = ["NAME": AttributeValue.decimalFloatingPoint(12.123)]
        XCTAssertEqual(parsedFloatAL, expectedFloatAL)
    }

    func testSingleSignedFloatAttribute() {
        // Signed Float
        let signedFloatAttribute = "NAME=-12.123"
        let (parsedSignedFloatAL, _) = attributeList.run(signedFloatAttribute)!
        let expectedSignedFloatAL: AttributeList = ["NAME": AttributeValue.signedDecimalFloatingPoint(SignedFloat(rawValue: -12.123))]
        XCTAssertEqual(parsedSignedFloatAL, expectedSignedFloatAL)
    }

    func testSingleQuotedStringAttribute() {
        // Quoted String
        let quotedStringAttribute = "NAME=\"VALUE\""
        let (parsedQuotedStringAL, _) = attributeList.run(quotedStringAttribute)!
        let expectedQuotedStringAL: AttributeList = ["NAME": AttributeValue.quotedString("VALUE")]
        XCTAssertEqual(parsedQuotedStringAL, expectedQuotedStringAL)
    }

    func testSingleStringAttribute() {
        // String
        let stringAttribute = "NAME=VALUE"
        let (parsedStringAL, _) = attributeList.run(stringAttribute)!
        let expectedStringAL: AttributeList = ["NAME": AttributeValue.enumeratedString(EnumeratedString(rawValue: "VALUE"))]
        XCTAssertEqual(parsedStringAL, expectedStringAL)
    }

    func testSingleDecimalResolutionAttribute() {
        // Decimal Resolution
        let resolutionAttribute = "NAME=12x13"
        let (parsedResolutionAL, _) = attributeList.run(resolutionAttribute)!
        let expectedResolutionAL: AttributeList = ["NAME": AttributeValue.decimalResolution(Resolution(width: 12, height: 13))]
        XCTAssertEqual(parsedResolutionAL, expectedResolutionAL)
    }

    func testMultipleAttributes() {
        var attributeListStrings: [String] = []
        var expectedAL: AttributeList = [:]

        // Integer
        attributeListStrings.append("INTNAME=12")
        expectedAL["INTNAME"] = AttributeValue.decimalInteger(12)

        // Hex
        attributeListStrings.append("HEXNAME=0x12")
        expectedAL["HEXNAME"] = AttributeValue.hexadecimalSequence(HexadecimalSequence(value: 0x12))

        // Float
        attributeListStrings.append("FLOATNAME=12.123")
        expectedAL["FLOATNAME"] = AttributeValue.decimalFloatingPoint(12.123)

        // Signed Float
        attributeListStrings.append("SIGNEDFLOATNAME=-12.123")
        expectedAL["SIGNEDFLOATNAME"] = AttributeValue.signedDecimalFloatingPoint(SignedFloat(rawValue: -12.123))

        // Quoted String
        attributeListStrings.append("QUOTEDNAME=\"VALUE\"")
        expectedAL["QUOTEDNAME"] = AttributeValue.quotedString("VALUE")

        // String
        attributeListStrings.append("STRINGNAME=VALUE")
        expectedAL["STRINGNAME"] = AttributeValue.enumeratedString(EnumeratedString(rawValue: "VALUE"))

        // Decimal Resolution
        attributeListStrings.append("RESOLUTIONNAME=12x13")
        expectedAL["RESOLUTIONNAME"] = AttributeValue.decimalResolution(Resolution(width: 12, height: 13))

        let (parsedAL, _) = attributeList.run(attributeListStrings.joined(separator: ","))!

        XCTAssertEqual(expectedAL, parsedAL)
    }

    static var allTests: [(String, (AttributeListTests) -> () throws -> Void)] {
        return [
            ("testSingleIntegerAttribute", testSingleIntegerAttribute),
            ("testSingleHexAttribute", testSingleHexAttribute),
            ("testSingleFloatAttribute", testSingleFloatAttribute),
            ("testSingleSignedFloatAttribute", testSingleSignedFloatAttribute),
            ("testSingleQuotedStringAttribute", testSingleQuotedStringAttribute),
            ("testSingleStringAttribute", testSingleStringAttribute),
            ("testSingleDecimalResolutionAttribute", testSingleDecimalResolutionAttribute),

            ("testMultipleAttributes", testMultipleAttributes)
        ]
    }
}
