//
//  AvailableManualsViewController.swift
//  MotoManuals
//
//  Created by Phillip Ayers on 9/8/18.
//  Copyright © 2018 Phillip Ayers. All rights reserved.
//

import Foundation
import UIKit

class AvailableManualsViewController: UITableViewController {
  @IBOutlet weak var myProgressView: UIProgressView!
  let fileManager = FileManager.default
  let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  
  let availableManualTitles = [
//    "2018 Yamaha MT-07",
    "2018 BMW R1200RS",
//    "2018 Kawasaki KLX110",
    "2018 Triumph Tiger 800",
    "2018 Zero S",
    "2018 Zero SR",
    "2018 Zero DS",
    "2018 Zero DSR"
  ]
  
  let availableManualFilenames = [
//    "2018_yamaha_mt07",
    "2018_bmw_r1200rs",
//    "2018_kawasaki_klx110",
    "2018_triumph_tiger800",
    "2018_zero_s-sr-ds-dsr",
    "2018_zero_s-sr-ds-dsr",
    "2018_zero_s-sr-ds-dsr",
    "2018_zero_s-sr-ds-dsr"
  ]

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return availableManualTitles.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? AvailableManualCell
    if fileManager.fileExists(atPath: DocumentsDirectory.path + "/" + availableManualFilenames[indexPath.row] + ".pdf") {
      myCell?.myButton?.isHidden = true
      myCell?.accessoryType = .disclosureIndicator
    } else {}
    myCell?.myLabel?.text = availableManualTitles[indexPath.row]
    myCell?.filename = availableManualFilenames[indexPath.row]
    return myCell!
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
