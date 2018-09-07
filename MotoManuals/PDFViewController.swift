//
//  PDFViewController.swift
//  MotoManuals
//
//  Created by Phillip Ayers on 9/6/18.
//  Copyright © 2018 Phillip Ayers. All rights reserved.
//

import Foundation
import UIKit
import PDFKit


class PDFViewController: UIViewController {
  let fileNames = ["2018_MT07.pdf"]
  var fileURLs = [URL]()
  var page: Int?
  
  func prepareFileURLs() {
    for file in fileNames {
      let fileParts = file.components(separatedBy: ".")
      if let fileURL = Bundle.main.url(forResource: fileParts[0], withExtension: fileParts[1]) {
        if FileManager.default.fileExists(atPath: fileURL.path) {
          fileURLs.append(fileURL as URL)
        }
      }
    }
  }
  
  func configurePdfView() -> UIView {
    let pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 50))
    pdfView.document = PDFDocument(url: fileURLs[0])
    pdfView.displayMode = .singlePageContinuous
    pdfView.autoScales = true
//    pdfView.maxScaleFactor = 0.81
    pdfView.go(to: (pdfView.document?.page(at: page! - 1))!)
    return pdfView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareFileURLs()
    let pdfView = configurePdfView()
    self.view.addSubview(pdfView)
  }
}
