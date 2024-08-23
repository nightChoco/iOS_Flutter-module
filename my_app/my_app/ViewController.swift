//
//  ViewController.swift
//  my_app
//
//  Created by Choco on 21/8/2567 BE.
//

import UIKit
import Flutter


class ViewController: UIViewController {
	
	@IBOutlet weak var messageTextField: UITextField!
	@IBOutlet weak var resultLabel: UILabel!
	@IBOutlet weak var flutterModuleButton: UIButton!
	
	let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
	var flutterViewController: FlutterViewController?
	var flutterMethodChannel: FlutterMethodChannel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		setupUI()
		setupButton()
		setupTextField()
		handleMethodChannel()
	}
}

// MARK: - set up
extension ViewController {
	func setupUI() {
		
	}
		
	func setupButton() {
		flutterModuleButton.addTarget(self, action: #selector(flutterModuleTabButton), for: .touchUpInside)
	}
	
	func setupTextField() {
		
	}
}

// MARK: - action
extension ViewController {
	@IBAction func flutterModuleTabButton(_ sender: Any) {
		showFlutter()
	}
}

// MARK: - flutter
extension ViewController {
	
	func handleMethodChannel() {
		flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
		flutterMethodChannel = FlutterMethodChannel(name: "samples.flutter.dev/channel"
												  , binaryMessenger: flutterEngine.binaryMessenger)
		
		flutterMethodChannel?.setMethodCallHandler({
			(call: FlutterMethodCall, result: FlutterResult) in
			
			switch call.method {
			case "backToNative":
				guard let text: String = call.arguments as? String else { return }
				self.resultLabel.text = "Flutter message: " + text
				self.flutterViewController?.dismiss(animated: true)
			default:
				result(FlutterMethodNotImplemented)
			}
		})
	}
	
	func showFlutter() {
		let text = messageTextField.text
		
		flutterMethodChannel?.invokeMethod("sendToFlutter", arguments: text)
		present(flutterViewController!, animated: true, completion: nil)

	}
}
