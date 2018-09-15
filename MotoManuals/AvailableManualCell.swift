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
  @IBOutlet weak var myProgressView: UIProgressView!

  @IBAction func downloadManual(_ sender: UIButton) {
    downloadFiles()
  }
  
  var filename: String?
  let fileManager = FileManager.default

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
        print(error!)
      }
    }
    
    let transferUtility = AWSS3TransferUtility.default()
    transferUtility.downloadData(
      forKey: "public/" + filename! + "_TOC.json",
      expression: expression,
      completionHandler: completionHandler
    )
  }

  func downloadManualFromS3() {
    myProgressView.isHidden = false
    let expression = AWSS3TransferUtilityDownloadExpression()
    expression.progressBlock = {(task, progress) in
      print("progress \(progress) \(task.progress)")
      DispatchQueue.main.async {
        self.myProgressView.progress = Float(task.progress.fractionCompleted)
      }
    }
    var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
    completionHandler = { (task, URL, data, error) -> Void in
      if (error == nil) {
        print("done")
        self.saveFileToLocalStorage(data: data!, name: "\(self.filename!).pdf")
        DispatchQueue.main.async {
          self.downloadButton?.isHidden = true
          self.accessoryType = .disclosureIndicator
          self.myProgressView.isHidden = true
        }
      } else {
        print(error!)
      }
    }
    let transferUtility = AWSS3TransferUtility.default()
    transferUtility.downloadData(
      forKey: "public/" + filename! + ".pdf",
      expression: expression,
      completionHandler: completionHandler
    )
  }
  
  func saveFileToLocalStorage(data: Data, name: String) {
    let fileURL = DocumentsDirectory.appendingPathComponent(name)
    do {
      try data.write(to: fileURL)
    } catch {
      print(error)
      return
    }
  }
}
