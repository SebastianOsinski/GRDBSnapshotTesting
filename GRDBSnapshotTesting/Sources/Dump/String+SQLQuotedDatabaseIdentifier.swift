//
//  String+SQLQuotedDatabaseIdentifier.swift
//  GRDBSnapshotTesting
//
//  Created by Sebastian Osiński on 05/01/2020.
//  Copyright © 2020 Sebastian Osiński. All rights reserved.
//

extension String {
    var sqlQuotedDatabaseIdentifier: String {
        // See https://www.sqlite.org/lang_keywords.html
        return "\"\(self)\""
    }
}
