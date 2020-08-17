import Foundation

struct MockResponse: Decodable {
    let array: [Int]
}

let mockResponse = """
{
     "array": [1,2,3,4,5]
}
"""
