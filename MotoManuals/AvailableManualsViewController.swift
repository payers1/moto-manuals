//
//  AvailableManualsViewController.swift
//  MotoManuals
//
//  Created by Phillip Ayers on 9/8/18.
//  Copyright © 2018 Phillip Ayers. All rights reserved.
//

import UIKit

class AvailableManualsViewController: UITableViewController {
  @IBOutlet weak var editButton: UIBarButtonItem!
  
  @IBAction func editButtonPress(_ sender: UIButton) {
    if (self.tableView.isEditing) {
      self.tableView.setEditing(false, animated: true)
      self.editButton.title = "Edit"
    } else {
      self.tableView.setEditing(true, animated: true)
      self.editButton.title = "Done"
    }
  }
  
  let fileManager = FileManager.default
  
  let availableManuals = [
    ["2017 Yamaha FZ07","2017_yamaha_fz07"],
    ["2018 BMW G310GS", "2018_bmw_g310gs"],
    ["2018 BMW R1200RS", "2018_bmw_r1200rs"],
    ["2018 Ducati Monster 797", "2018_ducati_monster_797"],
    ["2018 Kawasaki Concours 14 ABS", "2018_kawasaki_concours_14_abs"],
    ["2018 Kawasaki KLR650", "2018_kawasaki_KLR650"],
    ["2018 Kawasaki KLX110", "2018_kawasaki_KLX110"],
    ["2018 Kawasaki KLX140", "2018_kawasaki_KLX140"],
    ["2018 Kawasaki KLX250", "2018_kawasaki_KLX250"],
    ["2018 Kawasaki KX65", "2018_kawasaki_KX65"],
    ["2018 Kawasaki KX85", "2018_kawasaki_KX85"],
    ["2018 Kawasaki KX100", "2018_kawasaki_KX85"],
    ["2018 Kawasaki KX250F", "2018_kawasaki_KX250F"],
    ["2018 Kawasaki KX450F", "2018_kawasaki_KX450F"],
    ["2018 Kawasaki Ninja 400", "2018_kawasaki_ninja_400"],
    ["2018 Kawasaki Ninja 650", "2018_kawasaki_ninja_650"],
    ["2018 Kawasaki Ninja 1000", "2018_kawasaki_ninja_1000"],
    ["2018 Kawasaki Ninja H2", "2018_kawasaki_h2"],
    ["2018 Triumph Tiger 800", "2018_triumph_tiger800"],
    ["2018 Yamaha MT07", "2018_yamaha_mt07"],
    ["2018 Zero S", "2018_zero_s-sr-ds-dsr"],
    ["2018 Zero S","2018_zero_s-sr-ds-dsr"],
    ["2018 Zero SR","2018_zero_s-sr-ds-dsr"],
    ["2018 Zero DS","2018_zero_s-sr-ds-dsr"],
    ["2018 Zero DSR","2018_zero_s-sr-ds-dsr"],
    ["2019 Indian Scout", "2019_indian_scout"]
  ]

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return availableManuals.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let availableManualCell = tableView.dequeueReusableCell(withIdentifier: "availableManualCell") as? AvailableManualCell
    if fileManager.fileExists(atPath: DocumentsDirectory.path + "/" + availableManuals[indexPath.row][1] + ".pdf") {
      availableManualCell?.downloadButton?.isHidden = true
      availableManualCell?.accessoryType = .disclosureIndicator
    } else {
      availableManualCell?.downloadButton?.isHidden = false
      availableManualCell?.accessoryType = .none
    }
    availableManualCell?.myLabel?.text = availableManuals[indexPath.row][0]
    availableManualCell?.filename = availableManuals[indexPath.row][1]
    return availableManualCell!
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showTOC" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let tocFileName = availableManuals[indexPath.row][1] + "_TOC.json"
        let pdfFileName = availableManuals[indexPath.row][1] + ".pdf"
        let destinationViewController = segue.destination as! TableOfContentsViewController
        destinationViewController.tocFilename = tocFileName
        destinationViewController.pdfFilename = pdfFileName
      }
    }
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if let indexPath = self.tableView.indexPath(for: (sender as? UITableViewCell)!) {
      let filename = availableManuals[indexPath.row][1] + ".pdf"
      return fileManager.fileExists(atPath: DocumentsDirectory.path + "/" + filename)
    }
    return false
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      let tocFilename = DocumentsDirectory.path + "/" + availableManuals[indexPath.row][1] + "_TOC.json"
      let pdfFilename = DocumentsDirectory.path + "/" + availableManuals[indexPath.row][1] + ".pdf"
      do {
        try fileManager.removeItem(atPath: tocFilename)
        try fileManager.removeItem(atPath: pdfFilename)
        self.tableView.reloadData()
      } catch {
        print(error)
      }
    }
  }
  
}
