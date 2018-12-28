//
//  SandID.swift
//  SandID
//
//  Created by Aofei Sheng on 2018/11/3.
//  Copyright © 2018 Aofei Sheng. All rights reserved.
//

import Foundation

/// The ID of sand.
public class SandID: Comparable, Hashable {
	/// Zero SandID.
	static let zero = SandID(data: Data(repeating: 0, count: 16))!

	/// Lucky nibble.
	static let luckyNibble = UInt8.random(in: 0 ... 255)

	/// The data representation of the current SandID.
	public private(set) var data: Data

	/// The string representation of the current SandID.
	public var string: String {
		return data.base64EncodedString()
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
	}

	/// A Boolean value indicating whether the current SandID is zero.
	public var isZero: Bool {
		return self == SandID.zero
	}

	/// The hash value.
	public var hashValue: Int {
		return ObjectIdentifier(self).hashValue
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
		if string.count != 22 {
			return nil
		}

		guard let data = Data(base64Encoded: string.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/").appending("==")) else {
			return nil
		}

		self.data = data
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
