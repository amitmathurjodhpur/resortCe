import UIKit

class TextFieldClassViewController: UITextField {
    let  statusBarColor = UIColor(red: 59/255, green: 38/255, blue: 130/255, alpha: 1.0)
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    // Text color
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//        self.textColor = statusBarColor
//        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "",attributes: [NSAttributedStringKey.foregroundColor: statusBarColor])
//        
//    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}