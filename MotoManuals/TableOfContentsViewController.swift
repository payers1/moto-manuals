//
//  MyTableViewController.swift
//  MotoManuals
//
//  Created by Phillip Ayers on 9/6/18.
//  Copyright © 2018 Phillip Ayers. All rights reserved.
//

import Foundation
import UIKit

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

var TOC: TableOfContents = TableOfContents(sections: [])

class TableOfContentsViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadTableOfContentsFromJSON()
  }
  
  func loadTableOfContentsFromJSON() {
    let decoder = JSONDecoder()
    do {
      if let fileURL = Bundle.main.url(forResource: "TOC", withExtension: "json") {
        if FileManager.default.fileExists(atPath: fileURL.path) {
          let contentData = FileManager.default.contents(atPath: fileURL.path)
          TOC = try decoder.decode(TableOfContents.self, from: contentData!)
        }
      }
    } catch {}
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let section = TOC.sections[indexPath.section]
        let chapter = section.chapters[indexPath.row]
        let destinationViewController = segue.destination as! PDFViewController
        destinationViewController.page = chapter.page
      }
    }
  }
}

extension TableOfContentsViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return TOC.sections.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return TOC.sections[section].chapters.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell")
    myCell?.textLabel?.text = TOC.sections[indexPath.section].chapters[indexPath.row].title
    return myCell!
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return TOC.sections[section].title
  }
}
