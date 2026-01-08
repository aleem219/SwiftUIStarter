//
//  DocumentPicker.swift
//  Astron
//
//  Created by Aaditya_Agarwal_Mac on 24/08/22.
//



import Foundation
import UIKit
import PDFKit
import MobileCoreServices


class DocumentPicker: NSObject, UINavigationControllerDelegate, UIDocumentPickerDelegate, UIDocumentMenuDelegate {

    typealias onPicked = (URL) -> ()

    var pickedListner : onPicked?

    static let sharedInstance = DocumentPicker()

    func getPdf(pickedListner : @escaping onPicked ) {

        self.pickedListner = pickedListner

        let types: [String] = [kUTTypePDF as String]

        let importMenu = UIDocumentPickerViewController(documentTypes: types, in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        //presentViewController(importMenu, animated: true, completion: nil)
        ez.topMostVC?.present(importMenu, animated: true, completion: nil)
    }

    // MARK: Document picker delegates
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if let listener = pickedListner{
            listener(url)
        }
    }

    @available(iOS 8.0, *)
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        //self.presentViewController(documentPicker, animated: true, completion: nil)
        ez.topMostVC?.present(documentPicker, animated: true, completion: nil)
    }


    func pdfThumbnail(url: URL, width: CGFloat = 240) -> UIImage? {
      guard let data = try? Data(contentsOf: url),
      let page = PDFDocument(data: data)?.page(at: 0) else {
        return nil
      }

      let pageSize = page.bounds(for: .mediaBox)
      let pdfScale = width / pageSize.width

      // Apply if you're displaying the thumbnail on screen
      let scale = UIScreen.main.scale * pdfScale
      let screenSize = CGSize(width: pageSize.width * scale,
                              height: pageSize.height * scale)

      return page.thumbnail(of: screenSize, for: .mediaBox)
    }
}

