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
    "2018 Yamaha MT-07",
    "2018 BMW R1200RS",
    "2018 Kawasaki KLX110",
    "2018 Triump Tiger",
    "2018 Zero S"
  ]
  
  let availableManualFilenames = [
    "2018_yamaha_mt07",
    "2018_bmw_r1200rs",
    "2018_kawasaki_klx110",
    "2018_triumph_tiger",
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
    } else {
    }
    myCell?.myLabel?.text = availableManualTitles[indexPath.row]
    myCell?.filename = availableManualFilenames[indexPath.row]
    return myCell!
  }
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if let indexPath = self.tableView.indexPath(for: (sender as? UITableViewCell)!) {
      let filename = availableManualFilenames[indexPath.row] + ".pdf"
      return fileManager.fileExists(atPath: DocumentsDirectory.path + "/" + filename)
    }
    return false
  }
}
