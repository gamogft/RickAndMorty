import Foundation

enum HTTPParameter: CustomStringConvertible, Decodable {
	case string(String)
	case bool(Bool)
	case int(Int)
	case double(Double)

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		if let string = try? container.decode(String.self) {
			self = .string(string)
		} else if let bool = try? container.decode(Bool.self) {
			self = .bool(bool)
		} else if let int = try? container.decode(Int.self) {
			self = .int(int)
		} else if let double = try? container.decode(Double.self) {
			self = .double(double)
		} else {
			throw "APIClient error decoding"
		}
	}

	var description: String {
		switch self {
		case .string(let string):
			string
		case .bool(let bool):
			String(describing: bool)
		case .int(let int):
			String(describing: int)
		case .double(let double):
			String(describing: double)
		}
	}
}

extension String: Error {}
