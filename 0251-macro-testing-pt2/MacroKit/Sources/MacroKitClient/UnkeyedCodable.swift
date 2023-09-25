import MacroKit

@UnkeyedCodable
public struct CodableModel {
    var a: String
    private var b: Int = 42
    //var c = true
    var b2: Int {
        return b + 1
    }
}

@UnkeyedDecodable
public struct DecodableModel {
    var a: String
    private var b: Int = 42
    //var c = true
    var b2: Int {
        return b + 1
    }
}

@UnkeyedEncodable
public struct EncodableModel {
    var a: String
    private var b: Int = 42
    //var c = true
    var b2: Int {
        return b + 1
    }
}
