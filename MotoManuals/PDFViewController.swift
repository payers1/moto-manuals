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
  var pdfView: PDFView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareFileURLs()
    self.pdfView = configurePdfView()
    self.view?.addSubview(self.pdfView!)

  }
  
  func prepareFileURLs() {
    let fileURL = DocumentsDirectory.path + "/" + pdfFileName!
    if FileManager.default.fileExists(atPath: fileURL) {
      fileURLs.append(URL(fileURLWithPath: fileURL))
    }
  }
  
  func configurePdfView() -> PDFView {
    let defaultRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    let pdfView = PDFView(frame: defaultRect)
    pdfView.document = PDFDocument(url: fileURLs[0])
    pdfView.autoScales = true
    pdfView.go(
      to: CGRect(x: 0, y: 40, width: self.view.frame.width, height: self.view.frame.height),
      on: (pdfView.document?.page(at: page! - 1))!)
    return pdfView
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    self.pdfView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height + 40)
    self.pdfView?.sizeToFit()
  }
}
