//
//  AvailableManualsViewController.swift
//  MotoManuals
//
//  Created by Phillip Ayers on 9/8/18.
//  Copyright © 2018 Phillip Ayers. All rights reserved.
//

import UIKit

class AvailableManualsViewController: UITableViewController {
  let fileManager = FileManager.default
  
  let availableManualTitles = [
    "2017 Yamaha FZ07",
    "2018 BMW G310GS",
    "2018 BMW R1200RS",
    "2018 Triumph Tiger 800",
    "2018 Yamaha MT07",
    "2018 Zero S",
    "2018 Zero SR",
    "2018 Zero DS",
    "2018 Zero DSR",
    "2019 Indian Scout"
  ]
  
  let availableManualFilenames = [
    "2017_yamaha_fz07",
    "2018_bmw_g310gs",
    "2018_bmw_r1200rs",
    "2018_triumph_tiger800",
    "2018_yamaha_mt07",
    "2018_zero_s-sr-ds-dsr",
    "2018_zero_s-sr-ds-dsr",
    "2018_zero_s-sr-ds-dsr",
    "2018_zero_s-sr-ds-dsr",
    "2019_indian_scout"
  ]

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return availableManualTitles.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let availableManualCell = tableView.dequeueReusableCell(withIdentifier: "availableManualCell") as? AvailableManualCell
    if fileManager.fileExists(atPath: DocumentsDirectory.path + "/" + availableManualFilenames[indexPath.row] + ".pdf") {
      availableManualCell?.downloadButton?.isHidden = true
      availableManualCell?.accessoryType = .disclosureIndicator
    }
    availableManualCell?.myLabel?.text = availableManualTitles[indexPath.row]
    availableManualCell?.filename = availableManualFilenames[indexPath.row]
    return availableManualCell!
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showTOC" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let tocFileName = availableManualFilenames[indexPath.row] + "_TOC.json"
        let pdfFileName = availableManualFilenames[indexPath.row] + ".pdf"
        let destinationViewController = segue.destination as! TableOfContentsViewController
        destinationViewController.tocFilename = tocFileName
        destinationViewController.pdfFilename = pdfFileName
      }
    }
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if let indexPath = self.tableView.indexPath(for: (sender as? UITableViewCell)!) {
      let filename = availableManualFilenames[indexPath.row] + ".pdf"
      return fileManager.fileExists(atPath: DocumentsDirectory.path + "/" + filename)
    }
    return false
  }
}
