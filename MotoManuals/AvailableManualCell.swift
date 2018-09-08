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
    downloadManualFromS3()
  }
  
  var filename: String?
  let fileManager = FileManager.default

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
        self.saveFileToS3(data: data!)
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
  
  func saveFileToS3(data: Data) {
    do {
      let documentDirectory = try self.fileManager.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create:false
      )
      let fileURL = documentDirectory.appendingPathComponent(filename! + ".pdf")
      try data.write(to: fileURL)
    } catch {
      print("error 1")
      return
    }
  }
  
}
