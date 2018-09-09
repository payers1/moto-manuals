//
//  AvailableManualCell.swift
//  MotoManuals
//
//  Created by Phillip Ayers on 9/8/18.
//  Copyright © 2018 Phillip Ayers. All rights reserved.
//

import Foundation
import UIKit
import AWSS3

class AvailableManualCell: UITableViewCell {
  @IBOutlet weak var myButton: UIButton?
  @IBOutlet weak var myLabel: UILabel?
  @IBAction func downloadManual(_ sender: UIButton) {
    downloadFiles()
  }
  
  var filename: String?
  let fileManager = FileManager.default
  let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  
  func downloadFiles() {
    downloadTableOfContentsFromS3()
    downloadManualFromS3()
  }
  
  func downloadTableOfContentsFromS3() {
    let expression = AWSS3TransferUtilityDownloadExpression()
    var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
    completionHandler = { (task, URL, data, error) -> Void in
      if (error == nil) {
        print("done")
        self.saveFileToLocalStorage(data: data!, name: "\(self.filename!)_TOC.json")
      } else {
        print("error")
      }
    }
    
    let transferUtility = AWSS3TransferUtility.default()
    _ = transferUtility.downloadData(
      forKey: "public/" + filename! + "_TOC.json",
      expression: expression,
      completionHandler: completionHandler
    )
  }

  func downloadManualFromS3() {
    let expression = AWSS3TransferUtilityDownloadExpression()
    expression.progressBlock = {(task, progress) in
      print("progress \(progress) \(task.progress)")
      //      DispatchQueue.main.async {
      //        self.myProgressView.progress = Float(task.progress.fractionCompleted)
      //      }
    }
    var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
    completionHandler = { (task, URL, data, error) -> Void in
      if (error == nil) {
        print("done")
        self.saveFileToLocalStorage(data: data!, name: "\(self.filename!).pdf")
        DispatchQueue.main.async {
          self.myButton?.isHidden = true
          self.accessoryType = .disclosureIndicator
        }
      } else {
        print("error")
      }
    }
    let transferUtility = AWSS3TransferUtility.default()
    _ = transferUtility.downloadData(
      forKey: "public/" + filename! + ".pdf",
      expression: expression,
      completionHandler: completionHandler
    )
  }
  
  func saveFileToLocalStorage(data: Data, name: String) {
    do {
      let fileURL = DocumentsDirectory.appendingPathComponent(name)
      try data.write(to: fileURL)
    } catch {
      print("error 1")
      return
    }
  }
}
