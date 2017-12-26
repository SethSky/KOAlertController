## Usage

### Example usage KOAlertController

```swift
import KOAlertController
//
let alertController = KOAlertController("title", "message")
self.present(alertController, animated: false) {}
```
### Adds  action

```swift
let alertController = KOAlertController("title", "message")
alertController.addAction(KOAlertButton(.default, title:"Close")) {

}
self.present(alertController, animated: false) {}
```
### Adds a text field to an alert.

```swift
let alertController = KOAlertController("title", "message")
alertController.addTextField { (textField) in
textField.placeholder = "Placeholder"
textField.backgroundColor = .lightGray
}
alertController.addAction(KOAlertButton(.default, title:"Ok")) {

}
alertController.addAction(KOAlertButton(.cancel, title:"Cancel")) {

}
self.present(alertController, animated: false) {}
```
### Add image.

```swift
KOAlertController("title", "message", UIImage(named:"alert_image")) 
```
###  Custom style alert.
```swift
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
let alertController = KOAlertController("title", "message", UIImage(named:"alert_image"))
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
```
