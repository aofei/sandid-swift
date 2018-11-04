//
//  SandID.swift
//  SandID
//
//  Created by Aofei Sheng on 2018/11/3.
//  Copyright © 2018 Aofei Sheng. All rights reserved.
//

import Foundation

/// The ID of sand.
public class SandID: Comparable {
	/// Zero SandID.
	static let zero = SandID(data: Data(repeating: 0, count: 16))!

	/// Lucky nibble.
	static let luckyNibble = UInt8.random(in: 0 ... 255)

	/// The data representation of the current SandID.
	public private(set) var data: Data

	/// The string representation of the current SandID.
	public var string: String {
		return data.map { String(format: "%02hhx", $0) }.joined()
	}

	/// A Boolean value indicating whether the current SandID is zero.
	public var isZero: Bool {
		return self == SandID.zero
	}

	/// Initialize.
	public init() {
		var uuid = [UInt8](repeating: 0, count: 16)
		uuid_generate_time(&uuid)

		data = Data(repeating: 0, count: 16)
		data[0] = uuid[6] << 4 | uuid[7] >> 4
		data[1] = uuid[7] << 4 | uuid[4] >> 4
		data[2] = uuid[4] << 4 | uuid[5] >> 4
		data[3] = uuid[5] << 4 | uuid[0] >> 4
		data[4] = uuid[0] << 4 | uuid[1] >> 4
		data[5] = uuid[1] << 4 | uuid[2] >> 4
		data[6] = uuid[2] << 4 | uuid[3] >> 4
		data[7] = uuid[3] << 4 | SandID.luckyNibble >> 4
		data.replaceSubrange(8..., with: uuid[8...])
	}

	/// Initialize.
	///
	/// - Parameters:
	///   - data: The data representation of the SandID to be initialized.
	public init?(data: Data) {
		guard data.count == 16 else {
			return nil
		}

		self.data = data
	}

	/// Initialize.
	///
	/// - Parameters:
	///   - string: The string representation of the SandID to be initialized.
	public init?(string: String) {
		if string.count != 32 {
			return nil
		}

		data = Data()

		var sum = 0
		for (index, c) in string.utf8CString.enumerated() {
			var intC = Int(c.byteSwapped)
			if intC == 0 {
				break
			} else if intC >= 48 && intC <= 57 {
				intC -= 48
			} else if intC >= 65 && intC <= 70 {
				intC -= 55
			} else if intC >= 97 && intC <= 102 {
				intC -= 87
			} else {
				return nil
			}

			sum = sum * 16 + intC
			if index % 2 != 0 {
				data.append(UInt8(sum))
				sum = 0
			}
		}
	}

	/// Reports whether two values are equal.
	///
	/// - Parameters:
	///   - lhs: A value to compare.
	///   - rhs: Another value to compare.
	///
	/// - Returns: The result of the comparison.
	public static func == (lhs: SandID, rhs: SandID) -> Bool {
		return lhs.data == rhs.data
	}

	/// Reports whether two values are not equal.
	///
	/// - Parameters:
	///   - lhs: A value to compare.
	///   - rhs: Another value to compare.
	///
	/// - Returns: The result of the comparison.
	public static func != (lhs: SandID, rhs: SandID) -> Bool {
		return !(lhs == rhs)
	}

	/// Reports whether the value of the first argument is less than that of the second argument.
	///
	/// - Parameters:
	///   - lhs: A value to compare.
	///   - rhs: Another value to compare.
	///
	/// - Returns: The result of the comparison.
	public static func < (lhs: SandID, rhs: SandID) -> Bool {
		for index in 0 ..< 16 {
			if lhs.data[index] >= rhs.data[index] {
				return false
			}
		}

		return true
	}

	/// Reports whether the value of the first argument is less than or equal to that of the second argument.
	///
	/// - Parameters:
	///   - lhs: A value to compare.
	///   - rhs: Another value to compare.
	///
	/// - Returns: The result of the comparison.
	public static func <= (lhs: SandID, rhs: SandID) -> Bool {
		return lhs == rhs || lhs < rhs
	}

	/// Reports whether the value of the first argument is greater than or equal to that of the second argument.
	///
	/// - Parameters:
	///   - lhs: A value to compare.
	///   - rhs: Another value to compare.
	///
	/// - Returns: The result of the comparison.
	public static func > (lhs: SandID, rhs: SandID) -> Bool {
		return !(lhs <= rhs)
	}

	/// Reports whether the value of the first argument is greater than that of the second argument.
	///
	/// - Parameters:
	///   - lhs: A value to compare.
	///   - rhs: Another value to compare.
	///
	/// - Returns: The result of the comparison.
	public static func >= (lhs: SandID, rhs: SandID) -> Bool {
		return !(lhs < rhs)
	}
}
