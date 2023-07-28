//
//  ViewController.swift
//  base-64
//
//  Created by Nacho on 27-07-23.
//

import Cocoa

class MainController : NSViewController, NSWindowDelegate {
    
    // Prevent window close, just minimize
    override func viewWillAppear() {
        let window = self.view.window
        window!.delegate = self
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApplication.shared.hide(nil)  // just hide application
        return false                    // prevent closing.
    }


    func applicationDidBecomeActive(_ notification: Notification) {
        NSApplication.shared.unhide(nil)
    }
    
    
    // Pasteboard
    let pasteboard = NSPasteboard.general
    
    // Options Panel
    @IBOutlet weak var encdecSegControl: NSSegmentedControl!
    @IBOutlet weak var encodingPopUpBtn: NSPopUpButton!
    
    // Data Panel
    @IBOutlet var inputTextView: NSTextView!
    @IBOutlet var outputTextView: NSTextView!
    
    @IBAction func convertAction(_ sender: NSButton) {
        convert()
    }
    
    @IBAction func loadInputFromFileAction(_ sender: NSButton) {
        loadInputFromFile()
    }
    
    @IBAction func pasteFromClipboardAction(_ sender: NSButton) {
        pasteFromClipboard()
    }
    
    @IBAction func switchTextAction(_ sender: NSButton) {
        switchText()
    }
    
    @IBAction func clearAllAction(_ sender: NSButton) {
        clearAll()
    }
    
    @IBAction func copyToClipboardAction(_ sender: NSButton) {
        copyToClipboard()
    }
    
    
    /* * * * * * * * FUNCTIONS (LOGIC) * * * * * * * */
    
    // Options Panel
    func convert() {
        let selection = encdecSegControl.indexOfSelectedItem
        
        // check encode/decode switch
        if(selection == 0) {
            encode()
        } else {
            decode()
        }
    }
    
    // Data Panel
    func loadInputFromFile() {
        let panel = NSOpenPanel()
        
        // selection options
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        // run modal
        if(panel.runModal() != .OK) {
            return
        }
        
        // check if file selected
        if let fileURL = panel.url {
            do {
                let data = try String(contentsOf: fileURL.absoluteURL, encoding: .utf8) // get data from file
                inputTextView.string = data // set data from file to input textview
            } catch  {
                // TODO: handle errors if necessary
            }
        }
    }
    
    func pasteFromClipboard() {
        if let data: String = pasteboard.string(forType: .string) { // convert data to string
            inputTextView.string = data // set data from pasteboard to input
        }
        
    }
    
    func switchText() {
        let temp = inputTextView.string                 // save input data in temporal
        inputTextView.string = outputTextView.string    // set input data from output
        outputTextView.string = temp                    // set output data from temp
    }
    
    func clearAll() {
        inputTextView.string = ""   // clear input data
        outputTextView.string = ""  // clear output data
    }
    
    func copyToClipboard() {
        pasteboard.clearContents()                                      // clear clipboard
        pasteboard.setString(outputTextView.string, forType: .string)   // set output data to clipboard
    }
    
    // Encode/Decode functions
    func encode() {
        if let inputString = inputTextView.string.data(using: .utf8) {
            let encoded = inputString.base64EncodedString()
            outputTextView.string = encoded
        }
    }
    
    func decode() {
        if let inputData = Data(base64Encoded: inputTextView.string) {
            if let decoded = String(data: inputData, encoding: .utf8) {
                outputTextView.string = decoded
            }
        }
    }
}
