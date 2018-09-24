//
//  TableOfContents.swift
//  MotoManuals
//
//  Created by Phillip Ayers on 9/24/18.
//  Copyright © 2018 Phillip Ayers. All rights reserved.
//

import Foundation

struct TableOfContents: Codable {
  var sections: [Section]
}

struct Section: Codable {
  var title: String?
  var chapters: [Chapter]
}

struct Chapter: Codable {
  var title: String
  var page: Int
}
