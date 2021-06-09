//
//  AuthenticationModel.swift
//  VukkleExample
//
//  Created by Albert on 21.05.21.
//  Copyright © 2021 MAC_7. All rights reserved.
//

import Foundation
import CommonCrypto

struct AuthenticationModel: Encodable {

    let email: String
    let username: String
    private let publicKey: String
    private let signature: String

    init(email: String, username: String) {
        self.email = email
        self.username = username
        self.publicKey = PUBLISHER_PUBLIC_KEY
        self.signature = (email + "-" + PUBLISHER_PRIVATE_KEY).sha512().uppercased()
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case username
        case publicKey = "public_key"
        case signature
    }
}

extension String {
    func sha512() -> String {
        let data = self.data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        })
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }

}
