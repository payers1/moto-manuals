//
//  PDFViewController.swift
//  MotoManuals
//
//  Created by Phillip Ayers on 9/6/18.
//  Copyright © 2018 Phillip Ayers. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
  var pdfFileName: String?
  var fileURLs = [URL]()
  var page: Int? = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareFileURLs()
    let pdfView = configurePdfView()
    self.view.addSubview(pdfView)
  }
  
  func prepareFileURLs() {
    let fileURL = DocumentsDirectory.path + "/" + pdfFileName!
    if FileManager.default.fileExists(atPath: fileURL) {
      fileURLs.append(URL(fileURLWithPath: fileURL))
    }
  }
  
  func configurePdfView() -> UIView {
    let defaultRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    let pdfView = PDFView(frame: defaultRect)
    pdfView.document = PDFDocument(url: fileURLs[0])
    pdfView.displayMode = .singlePageContinuous
    pdfView.autoScales = true
    pdfView.go(
      to: CGRect(x: 0, y: 40, width: self.view.frame.width, height: self.view.frame.height),
      on: (pdfView.document?.page(at: page! - 1))!)
    return pdfView
  }
}
