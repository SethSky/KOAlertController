//
//  ViewController.swift
//  Example
//
//  Created by Oleksandr Khymych on 21.12.2017.
//  Copyright © 2017 Oleksandr Khymych. All rights reserved.
//

import UIKit
import KOAlertController

class ViewController: UIViewController {
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Outlets -
    //––––––––––––––––––––––––––––––––––––––––
    @IBOutlet weak private var tableView: UITableView!
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Property -
    //––––––––––––––––––––––––––––––––––––––––
    /// Content array
    fileprivate var contentArray:Array<String> = ["Title and message",
                                                  "Title, message and image",
                                                  "Two buttons",
                                                  "Three buttons",
                                                  "With UITextField",
                                                  "With more text in message",
                                                  "Custom style alert",
                                                  "With header view",
                                                  "With custom UITextField"]
    // Text
    private let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer tincidunt nisi leo, sit amet volutpat justo placerat et. Morbi aliquam magna at odio mollis imperdiet. Nunc viverra elit velit posuere."
    
    /// More text
    private let moreTextMessage = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean nec consectetur lorem. Aenean ac erat quis turpis pretium dignissim a eget nulla. Duis at libero euismod, sodales lectus ac, volutpat dui. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis vestibulum condimentum ligula eu iaculis. Nullam hendrerit, risus pellentesque accumsan accumsan, enim eros ultrices leo, et tristique nulla massa a magna. In nibh velit, ultricies vitae erat sit amet, faucibus facilisis nisi. Suspendisse sapien sem, accumsan ac nulla vel, ultrices rutrum enim. Curabitur porttitor at tellus id feugiat. Fusce venenatis est non erat vulputate, vel cursus felis euismod. Quisque mattis est nec mauris rhoncus tristique. Donec sollicitudin lobortis leo eget fringilla. Aliquam tempor lacus et egestas volutpat. Donec id placerat neque, at eleifend est. Nulla facilisi. Donec aliquam dapibus nisl, ac consequat turpis lacinia et. Curabitur faucibus dolor vitae tellus euismod, eget rhoncus turpis tincidunt. Nulla urna libero, cursus sit amet malesuada quis, ultrices a libero. Sed egestas, urna eu finibus consequat, neque dui lobortis quam, sed dapibus lorem nibh ut magna. Aliquam condimentum tortor vel tortor imperdiet, eget molestie purus posuere. Nunc tristique turpis at mi posuere, et accumsan urna fermentum. Vivamus sed orci porta, luctus nisl volutpat, vehicula enim. Integer sollicitudin convallis arcu eget efficitur. Duis facilisis interdum dolor ut aliquet. Mauris semper sed ligula ac tristique. Duis id ligula vel erat tristique molestie eget nec nisi. Pellentesque nec consequat arcu, nec tempus libero. In sed nunc vulputate erat ornare dignissim vel at sapien. Nulla commodo eget magna et luctus. Donec ac porta est. Vivamus gravida leo vitae dui commodo, vel pellentesque tellus lobortis. Phasellus maximus dolor quis mattis ornare. Nulla et placerat risus. Nullam vel lacus bibendum, laoreet tellus ac, porttitor justo. Quisque bibendum lorem ut nunc finibus porta. Etiam sagittis dignissim ante, non finibus urna lobortis ac. Nullam eu dui quis mi efficitur vulputate id ut est. Donec dapibus turpis scelerisque ex eleifend, eu convallis erat rutrum. Nullam auctor, augue eget egestas mollis, nisl lectus bibendum risus, vel blandit ligula ex sit amet justo. Maecenas sem ante, sollicitudin ut neque ac, congue feugiat velit. Aenean id felis rhoncus, accumsan metus ac, faucibus ligula. Aliquam maximus eu urna eget fringilla."
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Show Alert -
    //––––––––––––––––––––––––––––––––––––––––
    fileprivate func showAlert(_ index:Int){
        switch index {
        case 0:
            self.alert_1(contentArray[index])
        case 1:
            self.alert_2(contentArray[index])
        case 2:
            self.alert_3(contentArray[index])
        case 3:
            self.alert_4(contentArray[index])
        case 4:
            self.alert_5(contentArray[index])
        case 5:
            self.alert_6(contentArray[index])
        case 6:
            self.alert_7(contentArray[index])
        case 7:
            self.alert_8(contentArray[index])
        case 8:
            self.alert_9(contentArray[index])
        default:
            break
        }
    }
    //––––––––––––––––––––––––––––––––––––––––
    //MARK: - Exemple creating alerts -
    //––––––––––––––––––––––––––––––––––––––––
    /// Title and message
    ///
    /// - Parameter title: String
    private func alert_1(_ title:String){
        let alertController = KOAlertController(title, self.message)
        alertController.addAction(KOAlertButton(.default, title:"Close")) {
            debugPrint("Action:Close")
        }
        self.present(alertController, animated: false) {}
    }
    /// Title, message and image
    ///
    /// - Parameter title: String
    private func alert_2(_ title:String){
        let alertController = KOAlertController(title, self.message, UIImage(named:"alert_image"))
        alertController.addAction(KOAlertButton(.default, title:"Close")) {debugPrint("Action:Close")}
        self.present(alertController, animated: false) {}
    }
    /// Two buttons
    ///
    /// - Parameter title: String
    private func alert_3(_ title:String){
        let alertController = KOAlertController(title, self.message, UIImage(named:"alert_image"))
        alertController.addAction(KOAlertButton(.default, title:"Ok")) {debugPrint("Action:Ok")}
        alertController.addAction(KOAlertButton(.cancel, title:"Cancel")) {debugPrint("Action:Cancel")}
        self.present(alertController, animated: false) {}
    }
    /// Three buttons
    ///
    /// - Parameter title: String
    private func alert_4(_ title:String){
        let alertController = KOAlertController(title, self.message, UIImage(named:"alert_image"))
        alertController.addAction(KOAlertButton(.default, title:"1")) {debugPrint("Action:1")}
        alertController.addAction(KOAlertButton(.cancel, title:"2")) {debugPrint("Action:2")}
        alertController.addAction(KOAlertButton(.default, title:"3")) {debugPrint("Action:3")}
        self.present(alertController, animated: false) {}
    }
    /// With UITextField
    ///
    /// - Parameter title: String
    private func alert_5(_ title:String){
        let alertController = KOAlertController(title, self.message)
        alertController.addTextField { (textField) in
            textField.placeholder = "Placeholder"
            textField.backgroundColor = .lightGray
        }
        alertController.addAction(KOAlertButton(.default, title:"Ok")) {
            debugPrint("Action:Ok")
        }
        alertController.addAction(KOAlertButton(.cancel, title:"Cancel")) {
            debugPrint("Action:Cancel")
        }
        self.present(alertController, animated: false) {}
    }
    //
    private func alert_6(_ title:String){
        let alertController = KOAlertController(title, self.moreTextMessage)
        alertController.addAction(KOAlertButton(.default, title:"Close")) {
            debugPrint("Action:Close")
        }
        self.present(alertController, animated: false) {}
    }
    /// Custom style alert
    ///
    /// - Parameter title: String
    private func alert_7(_ title:String){
        //Style alert
        let style                       = KOAlertStyle()
        style.backgroundColor           = UIColor.black
        style.cornerRadius              = 5
        style.messageColor              = UIColor.lightGray
        style.titleColor                = UIColor.white
        style.messageFont               = UIFont.systemFont(ofSize: 17)
        style.titleFont                 = UIFont.systemFont(ofSize: 30)
        //style button
        let defButton                   = KOAlertButton(.default, title:"ok")
        defButton.backgroundColor       = UIColor.white
        defButton.titleColor            = UIColor.black
        let cancelButton                = KOAlertButton(.cancel, title:"cancel")
        cancelButton.borderColor        = UIColor.white
        cancelButton.titleColor         = UIColor.white
        cancelButton.backgroundColor    = UIColor.black
        // Alert controller
        let alertController = KOAlertController(title, self.message, UIImage(named:"alert_image"))
        // Add custom alert style
        alertController.style = style
        // Add action
        alertController.addAction(defButton) {
            debugPrint("Action:OK")
        }
        // Add action
        alertController.addAction(cancelButton) {
            debugPrint("Action:Cancel")
        }
        self.present(alertController, animated: false) {}
    }
    /// Alert with header
    ///
    /// - Parameter title: String
    private func alert_8(_ title:String){
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 190, height: 25))
        button.setTitle("Header button", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitleColor(UIColor.blue.withAlphaComponent(0.25), for: .highlighted)
        button.contentHorizontalAlignment = .left
        headerView.addSubview(button)
        ///
        let alertController = KOAlertController(title, self.message)
        alertController.addHeaderView(headerView)
        alertController.addAction(KOAlertButton(.default, title:"Close")) {
            debugPrint("Action:Close")
        }
        self.present(alertController, animated: false) {}
    }
    /// Alert with custom UITextField
    ///
    /// - Parameter title: String
    private func alert_9(_ title:String){ 
        ///
        let alertController = KOAlertController(title, self.message)
        //Need create textField with frame and set height
        alertController.alertTextField = CustomTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        alertController.addTextField { (textField) in
            
        }
        alertController.addAction(KOAlertButton(.default, title:"Close")) {
            debugPrint("Action:Close")
        }
        self.present(alertController, animated: false) {}
    }
}
//––––––––––––––––––––––––––––––––––––––––
//MARK: - UITableViewDataSource -
//––––––––––––––––––––––––––––––––––––––––
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.contentArray.count 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell =  UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = contentArray[indexPath.row]
        return cell
    }
}
//––––––––––––––––––––––––––––––––––––––––
//MARK: - UITableViewDelegate -
//––––––––––––––––––––––––––––––––––––––––
extension  ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showAlert(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
