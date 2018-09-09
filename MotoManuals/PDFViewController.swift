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
  let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  var pdfFileName: String?
  var fileURLs = [URL]()
  var page: Int? = 1
  
  func prepareFileURLs() {
    let fileURL = DocumentsDirectory.path + "/" + pdfFileName!
    if FileManager.default.fileExists(atPath: fileURL) {
      fileURLs.append(URL(fileURLWithPath: fileURL))
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
