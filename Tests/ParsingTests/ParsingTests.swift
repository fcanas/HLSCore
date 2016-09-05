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
        XCTAssertEqual(hexSequence.run("0x0")?.0, HexadecimalSequence(value: 0))
        XCTAssertEqual(hexSequence.run("0x00000000")?.0, HexadecimalSequence(value: 0))
        XCTAssertEqual(hexSequence.run("0x1")?.0, HexadecimalSequence(value: 1))
        XCTAssertEqual(hexSequence.run("0x1234")?.0, HexadecimalSequence(value: 0x1234))
        XCTAssertEqual(hexSequence.run("0xABCD")?.0, HexadecimalSequence(value: 0xabcd))
        XCTAssertEqual(hexSequence.run("0xFFFFFFFF")?.0, HexadecimalSequence(value: 0xffffffff))
        
        // Upper Case X
        XCTAssertEqual(hexSequence.run("0X0")?.0, HexadecimalSequence(value: 0))
        XCTAssertEqual(hexSequence.run("0X00000000")?.0, HexadecimalSequence(value: 0))
        XCTAssertEqual(hexSequence.run("0X1")?.0, HexadecimalSequence(value: 1))
        XCTAssertEqual(hexSequence.run("0X1234")?.0, HexadecimalSequence(value: 0x1234))
        XCTAssertEqual(hexSequence.run("0XABCD")?.0, HexadecimalSequence(value: 0xabcd))
        XCTAssertEqual(hexSequence.run("0XFFFFFFFF")?.0, HexadecimalSequence(value: 0xffffffff))
        
    }
    
    func testFloatingPoint() {
        XCTAssertNil(decimalFloatingPoint.run("")?.0)
        XCTAssertNil(decimalFloatingPoint.run("A0.1")?.0)
        XCTAssertNil(decimalFloatingPoint.run("\n0.1")?.0)
        XCTAssertNil(decimalFloatingPoint.run("1")?.0)
        XCTAssertNil(decimalFloatingPoint.run("0")?.0)
        XCTAssertNil(decimalFloatingPoint.run("-1")?.0)
        XCTAssertNil(decimalFloatingPoint.run("-1.1")?.0)
        
        XCTAssertEqualWithAccuracy(decimalFloatingPoint.run("0.1")!.0, 0.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(decimalFloatingPoint.run("1.1")!.0, 1.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(decimalFloatingPoint.run("18446744073709551615.18446744073709551615")!.0, 18446744073709551615.18446744073709551615, accuracy: 0.0001)
    }
    
    func testSignedFloatingPoint() {
        XCTAssertNil(signedDecimalFloatingPoint.run("")?.0)
        XCTAssertNil(signedDecimalFloatingPoint.run("A0.1")?.0)
        XCTAssertNil(signedDecimalFloatingPoint.run("\n0.1")?.0)
        XCTAssertNil(signedDecimalFloatingPoint.run("1")?.0)
        XCTAssertNil(signedDecimalFloatingPoint.run("0")?.0)
        XCTAssertNil(signedDecimalFloatingPoint.run("-1")?.0)
        
        XCTAssertEqualWithAccuracy(signedDecimalFloatingPoint.run("0.1")!.0, 0.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(signedDecimalFloatingPoint.run("1.1")!.0, 1.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(signedDecimalFloatingPoint.run("18446744073709551615.18446744073709551615")!.0, 18446744073709551615.18446744073709551615, accuracy: 0.0001)
        
        XCTAssertEqualWithAccuracy(signedDecimalFloatingPoint.run("-0.1")!.0, -0.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(signedDecimalFloatingPoint.run("-1.1")!.0, -1.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(signedDecimalFloatingPoint.run("-18446744073709551615.18446744073709551615")!.0, -18446744073709551615.18446744073709551615, accuracy: 0.0001)
    }
    
    func testQuotedString() {
        XCTAssertNil(quotedString.run("something"))
        XCTAssertNil(quotedString.run("something\""))
        XCTAssertNil(quotedString.run("\"something\nelse\""))
        XCTAssertNil(quotedString.run("\"something\relse\""))
        XCTAssertNil(quotedString.run("\"something\r\nelse\""))
        
        XCTAssertEqual(quotedString.run("\"\"")?.0, "")
        XCTAssertEqual(quotedString.run("\"something\"")?.0, "something")
        XCTAssertEqual(quotedString.run("\"something\" else")?.0, "something")
    }
    
    func testEnumeratedString() {
        XCTAssertNil(enumeratedString.run("")?.0)
        XCTAssertNil(enumeratedString.run("\n")?.0)
        XCTAssertEqual(enumeratedString.run("A B")?.0, "A")
        XCTAssertEqual(enumeratedString.run("A\nB")?.0, "A")
        XCTAssertEqual(enumeratedString.run("A\rB")?.0, "A")
        XCTAssertEqual(enumeratedString.run("A\tB")?.0, "A")
        XCTAssertEqual(enumeratedString.run("A\"B")?.0, "A")
        XCTAssertEqual(enumeratedString.run("A,B")?.0, "A")
        
        XCTAssertEqual(enumeratedString.run("Abcd efg")?.0, "Abcd")
        XCTAssertEqual(enumeratedString.run("Abcd\nefg")?.0, "Abcd")
        XCTAssertEqual(enumeratedString.run("Abcd\refg")?.0, "Abcd")
        XCTAssertEqual(enumeratedString.run("Abcd\tefg")?.0, "Abcd")
        XCTAssertEqual(enumeratedString.run("Abcd\"efg")?.0, "Abcd")
        XCTAssertEqual(enumeratedString.run("Abcd,efg")?.0, "Abcd")
    }
    
    func testDecimalResolution() {
        XCTAssertNil(decimalResolution.run("1234x")?.0)
        XCTAssertNil(decimalResolution.run("1234x")?.0)
        
        XCTAssertEqual(decimalResolution.run("1x1")?.0, Resolution(width: 1, height: 1))
        XCTAssertEqual(decimalResolution.run("1x2")?.0, Resolution(width: 1, height: 2))
        XCTAssertEqual(decimalResolution.run("1234x5678")?.0, Resolution(width: 1234, height: 5678))
        XCTAssertEqual(decimalResolution.run("1920x1080")?.0, Resolution(width: 1920, height: 1080))
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
