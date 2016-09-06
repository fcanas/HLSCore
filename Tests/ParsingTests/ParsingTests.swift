import XCTest
@testable import Parsing
import Types

class AttributeValueTests :XCTestCase {
    
    func testInt() {
        // Not a number
        XCTAssertNil(int.run("")?.0)
        XCTAssertNil(int.run("a")?.0)
        XCTAssertNil(int.run("abcdef")?.0)
        XCTAssertNil(int.run("-1")?.0)
        
        // Normal numbers in full range
        XCTAssertEqual(int.run(String(UInt.min))?.0, UInt.min)
        XCTAssertEqual(int.run("0")?.0, 0)
        XCTAssertEqual(int.run("1")?.0, 1)
        XCTAssertEqual(int.run("1234")?.0, 1234)
        // 2^64-1 (18446744073709551615)
        // Defined as the maximum for "decimal-integer" in HLS specification
        XCTAssertEqual(int.run("18446744073709551615")?.0, 18446744073709551615)
        XCTAssertEqual(int.run(String(UInt.max))?.0, UInt.max)
        
        // Starts with numbers
        XCTAssertEqual(int.run("0abcdef")?.0, 0)
        XCTAssertEqual(int.run("1-")?.0, 1)
        XCTAssertEqual(int.run("1234&234")?.0, 1234)
        XCTAssertEqual(int.run("18446744073709551615\n")?.0, 18446744073709551615)
    }
    
    func testHexSequence() {
        // Not a number
        XCTAssertNil(int.run("")?.0)
        XCTAssertNil(int.run("A")?.0)
        XCTAssertNil(int.run("ABCDEF")?.0)
        XCTAssertNil(int.run("-1")?.0)
        XCTAssertNil(hexSequence.run("0x")?.0)
        XCTAssertNil(hexSequence.run("0X")?.0)
        
        // Lower Case x
        XCTAssertEqual(hex.run("0x0")?.0, HexadecimalSequence(value: 0))
        XCTAssertEqual(hex.run("0x00000000")?.0, HexadecimalSequence(value: 0))
        XCTAssertEqual(hex.run("0x1")?.0, HexadecimalSequence(value: 1))
        XCTAssertEqual(hex.run("0x1234")?.0, HexadecimalSequence(value: 0x1234))
        XCTAssertEqual(hex.run("0xABCD")?.0, HexadecimalSequence(value: 0xabcd))
        XCTAssertEqual(hex.run("0xFFFFFFFF")?.0, HexadecimalSequence(value: 0xffffffff))
        
        // Upper Case X
        XCTAssertEqual(hex.run("0X0")?.0, HexadecimalSequence(value: 0))
        XCTAssertEqual(hex.run("0X00000000")?.0, HexadecimalSequence(value: 0))
        XCTAssertEqual(hex.run("0X1")?.0, HexadecimalSequence(value: 1))
        XCTAssertEqual(hex.run("0X1234")?.0, HexadecimalSequence(value: 0x1234))
        XCTAssertEqual(hex.run("0XABCD")?.0, HexadecimalSequence(value: 0xabcd))
        XCTAssertEqual(hex.run("0XFFFFFFFF")?.0, HexadecimalSequence(value: 0xffffffff))
        
    }
    
    func testFloatingPoint() {
        XCTAssertNil(float.run("")?.0)
        XCTAssertNil(float.run("A0.1")?.0)
        XCTAssertNil(float.run("\n0.1")?.0)
        XCTAssertNil(float.run("1")?.0)
        XCTAssertNil(float.run("0")?.0)
        XCTAssertNil(float.run("-1")?.0)
        XCTAssertNil(float.run("-1.1")?.0)
        
        XCTAssertEqualWithAccuracy(float.run("0.1")!.0, 0.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(float.run("1.1")!.0, 1.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(float.run("18446744073709551615.18446744073709551615")!.0, 18446744073709551615.18446744073709551615, accuracy: 0.0001)
    }
    
    func testSignedFloatingPoint() {
        XCTAssertNil(signedFloat.run("")?.0)
        XCTAssertNil(signedFloat.run("A0.1")?.0)
        XCTAssertNil(signedFloat.run("\n0.1")?.0)
        XCTAssertNil(signedFloat.run("1")?.0)
        XCTAssertNil(signedFloat.run("0")?.0)
        XCTAssertNil(signedFloat.run("-1")?.0)
        
        XCTAssertEqualWithAccuracy(signedFloat.run("0.1")!.0.value, 0.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(signedFloat.run("1.1")!.0.value, 1.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(signedFloat.run("18446744073709551615.18446744073709551615")!.0.value, 18446744073709551615.18446744073709551615, accuracy: 0.0001)
        
        XCTAssertEqualWithAccuracy(signedFloat.run("-0.1")!.0.value, -0.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(signedFloat.run("-1.1")!.0.value, -1.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(signedFloat.run("-18446744073709551615.18446744073709551615")!.0.value, -18446744073709551615.18446744073709551615, accuracy: 0.0001)
    }
    
    func testQuotedString() {
        XCTAssertNil(quoteString.run("something"))
        XCTAssertNil(quoteString.run("something\""))
        XCTAssertNil(quoteString.run("\"something\nelse\""))
        XCTAssertNil(quoteString.run("\"something\relse\""))
        XCTAssertNil(quoteString.run("\"something\r\nelse\""))
        
        XCTAssertEqual(quoteString.run("\"\"")?.0, "")
        XCTAssertEqual(quoteString.run("\"something\"")?.0, "something")
        XCTAssertEqual(quoteString.run("\"something\" else")?.0, "something")
    }
    
    func testEnumeratedString() {
        XCTAssertNil(enumString.run("")?.0)
        XCTAssertNil(enumString.run("\n")?.0)
        XCTAssertEqual(enumString.run("A B")?.0.value, "A")
        XCTAssertEqual(enumString.run("A\nB")?.0.value, "A")
        XCTAssertEqual(enumString.run("A\rB")?.0.value, "A")
        XCTAssertEqual(enumString.run("A\tB")?.0.value, "A")
        XCTAssertEqual(enumString.run("A\"B")?.0.value, "A")
        XCTAssertEqual(enumString.run("A,B")?.0.value, "A")
        
        XCTAssertEqual(enumString.run("Abcd efg")?.0.value, "Abcd")
        XCTAssertEqual(enumString.run("Abcd\nefg")?.0.value, "Abcd")
        XCTAssertEqual(enumString.run("Abcd\refg")?.0.value, "Abcd")
        XCTAssertEqual(enumString.run("Abcd\tefg")?.0.value, "Abcd")
        XCTAssertEqual(enumString.run("Abcd\"efg")?.0.value, "Abcd")
        XCTAssertEqual(enumString.run("Abcd,efg")?.0.value, "Abcd")
    }
    
    func testDecimalResolution() {
        XCTAssertNil(decimalResolution.run("1234x")?.0)
        XCTAssertNil(decimalResolution.run("1234x")?.0)
        
        XCTAssertEqual(resolution.run("1x1")?.0, Resolution(width: 1, height: 1))
        XCTAssertEqual(resolution.run("1x2")?.0, Resolution(width: 1, height: 2))
        XCTAssertEqual(resolution.run("1234x5678")?.0, Resolution(width: 1234, height: 5678))
        XCTAssertEqual(resolution.run("1920x1080")?.0, Resolution(width: 1920, height: 1080))
    }
    
    static var allTests : [(String, (AttributeValueTests) -> () throws -> Void)] {
        return [
            ("testInt", testInt),
            ("testHexSequence", testHexSequence),
            ("testFloatingPoint", testFloatingPoint),
            ("testSignedFloatingPoint", testSignedFloatingPoint),
            ("testQuotedString", testQuotedString),
            ("testEnumeratedString", testEnumeratedString),
            ("testDecimalResolution", testDecimalResolution),
        ]
    }
}
