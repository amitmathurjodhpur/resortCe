//
//  Lect1Detail.swift
//  ResortCeApp
//
//  Created by AJ12 on 13/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
import PassKit
import Toaster
import StoreKit
import Stripe
struct ProductIDs
{
    static let ResortCeFirst = "ResortCeFirstProductIdConsumable"
    static let ResortCeSecond = "ResortCeSecondProductIdConsumable"
    static let ResortCeThird = "ResortCeThirdProductIdconsumable"
    static let ResortCeFourth = "ResortCeFourthProductIdconsumable"
}
class Lect1Detail: UIViewController {
   
    var detail : String = ""
    var groupid = ""
    var favBtnType : String = ""
    var buyBtnTYpe : String = ""
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    let product_id = "ResortCeIAP"
    var ItunesId : String?
   // let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex,PKPaymentNetwork.discover]
  //  let ApplePaySwagMerchantID = "merchant.cqlsys.ResortceNewId"
    var CourseName = ""
    var CourseFee : NSDecimalNumber!
    var StringCourseFee = ""
    var DatahotelDict : [String:Any] = [:]
    var shouldShowBuyBtn: Bool = false
    @IBOutlet weak var LblHeading: UILabel!
    @IBOutlet weak var TxtVwDetails: UITextView!
    @IBOutlet weak var LectTitle: UILabel!
    @IBOutlet weak var CalenderBtn: UIButton!
    @IBOutlet weak var HeartBtn: UIButton!
    @IBOutlet weak var credits: UILabel!
    @IBOutlet weak var BuyBtn: UIButton!
    @IBOutlet weak var RestoreBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: SupportedPaymentNetworks)
    }
    @IBAction func restoreAction(_ sender: UIButton) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOneCourseList()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // SKPaymentQueue.default().remove(self)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldShowBuyBtn {
            self.BuyBtn.isHidden = false
        } else {
            self.BuyBtn.isHidden = true
        }
        
        //SKPaymentQueue.default().add(self)
    }
    func getOneCourseList() {
        if let authKey = UserDefaults.standard.value(forKey: "auth_key") as? String {
            ActivityIndicator.shared.show(self.view)
            print(detail)
            DataManager.postAPIWithParameters(urlString: API.one_course_list, jsonString: Request.oneCourseId(authKey, detail) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                let dict  = (sucess["body"] as? [[String:Any]])!
                print(dict)
                let values = dict[0]
                self.TxtVwDetails.text = values["overview"] as? String
                self.credits.text = values["credit"] as? String
                self.LblHeading.text = values["name"] as? String
                self.favBtnType = values["favourite"] as! String
                self.buyBtnTYpe = values["buy"] as! String
                self.ItunesId = values["itune_product_id"] as? String
                let fee = values["fee"] as? String
                self.CourseFee = NSDecimalNumber(string: fee)
                self.CourseName = (values["name"] as? String)!
                self.setHeartBtn()
                self.setBuyBtn()
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
    
    func addToFAv() {
         if let authKey = UserDefaults.standard.value(forKey: "auth_key") as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.course_add_to_favourite, jsonString: Request.AddtoFav(authKey, detail, favBtnType) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                let user_dict = sucess.value(forKey: "body") as! [String:Any]
                print(user_dict)
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
    
    func PostaddToBuy() {
         if let authKey = UserDefaults.standard.value(forKey: "auth_key") as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.course_add_to_buy, jsonString: Request.AddtoBuy(authKey,detail,buyBtnTYpe,groupid,DatahotelDict["HotelId"] as! String, DatahotelDict["HotelName"] as! String, DatahotelDict["HotelAddress"] as! String, DatahotelDict["HotelLatitude"] as! String, DatahotelDict["HotelLongitude"] as! String, DatahotelDict["HotelWebsite"] as! String, DatahotelDict["HotelPhone"] as! String) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                self.BuyBtn.setTitle("Purchased", for: .normal)
                
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
    
    //////
    func PostApplePayStripe(_ token:String,completion: @escaping (_: PKPaymentAuthorizationStatus) -> Void) {
        if let authKey = UserDefaults.standard.value(forKey: "auth_key") as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.PaymentStripeApplePay, jsonString: Request.StripeApplePay(authKey,detail,token,StringCourseFee) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                self.PostaddToBuy()
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
    
    func  setHeartBtn() {
        print(self.favBtnType)
        if  self.favBtnType == "1" {
            HeartBtn.setImage(#imageLiteral(resourceName: "RedHeart"), for: .normal)
        } else {
            HeartBtn.setImage(#imageLiteral(resourceName: "heraticon"), for: .normal)
        }
    }
    
    func setBuyBtn() {
        if shouldShowBuyBtn {
            self.BuyBtn.isHidden = false
            if  self.buyBtnTYpe == "1" {
                BuyBtn.setTitle("Purchased", for: .normal)
            } else {
                BuyBtn.setTitle("Buy", for: .normal)
            }
        } else {
            self.BuyBtn.isHidden = true
        }
    }
    
    @IBAction func ActnHeartBtn(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "heraticon") {
            sender.setImage(#imageLiteral(resourceName: "RedHeart"), for: .normal)
            favBtnType = "1"
            self.addToFAv()
        } else {
            sender.setImage(#imageLiteral(resourceName: "heraticon"), for: .normal)
            favBtnType = "2"
            self.addToFAv()
        }
    }
  //  func AppleBtnAction ()
//    {
//        let request = Stripe.paymentRequest(withMerchantIdentifier: ApplePaySwagMerchantID, country: "US", currency: "USD")
//        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: SupportedPaymentNetworks)
//        {
//            //  request.merchantIdentifier = ApplePaySwagMerchantID
//            request.supportedNetworks = SupportedPaymentNetworks
//            request.merchantCapabilities = PKMerchantCapability.capability3DS
//            // request.countryCode = "US"
//            //request.currencyCode = "USD"
//            request.paymentSummaryItems = [
//                PKPaymentSummaryItem(label: CourseName, amount: CourseFee)]
//            request.requiredShippingAddressFields = PKAddressField.email
//            request.requiredBillingAddressFields = PKAddressField.phone
//        }
//        if Stripe.canSubmitPaymentRequest(request)
//        {
//            let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
//            applePayController?.delegate = self
//            self.present(applePayController!, animated: true, completion: nil)
//        }
//        else{
//            UIAlertController.show(self, "Payment", "Cant Make Payment Now")
//        }
//    }

    @IBAction func ActnBuyBtn(_ sender: UIButton) {
        if sender.currentTitle == "Buy"  {
            ActivityIndicator.shared.show(self.view)
            // self.AppleBtnAction()
            if (SKPaymentQueue.canMakePayments()) {
                let productID:NSSet = NSSet(objects: ProductIDs.ResortCeFirst,ProductIDs.ResortCeSecond,ProductIDs.ResortCeThird,ProductIDs.ResortCeFourth)
                let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
                productsRequest.delegate = self;
                productsRequest.start();
                print("Fetching Products");
            } else {
                print("can't make purchases");
            }
            detail = String(sender.tag)
            buyBtnTYpe = "1"
        }
        else if sender.currentTitle == "No Product" {
            Toast(text: "No Product Found").show()
        } else {
            Toast(text: "Already Purchased").show()
        }
    }
    
    func buyProduct(product: SKProduct) {
        print("Sending the Payment Request to Apple")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
         ActivityIndicator.shared.hide()
    }
    
    @IBAction func ActnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension Lect1Detail: SKProductsRequestDelegate,SKPaymentTransactionObserver{
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        print(response.products)
        var ProductIndex = Int()
        var productIdIndex = ""
        if StringCourseFee == "1" {
            ProductIndex = 0
            productIdIndex = ProductID.ResortCeFirst
        } else if StringCourseFee == "10" {
            ProductIndex = 1
            productIdIndex = ProductID.ResortCeFourth
        } else if StringCourseFee == "20" {
            ProductIndex = 2
            productIdIndex = ProductID.ResortCeSecond
        } else if StringCourseFee == "30" {
            ProductIndex = 3
            productIdIndex = ProductID.ResortCeThird
        }
        let count : Int = response.products.count
        if (count>0) {
            let validProduct: SKProduct = response.products[ProductIndex] as SKProduct
            if (validProduct.productIdentifier == productIdIndex as String) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                self.buyProduct(product: validProduct)
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("request fail")
    }
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("error")
    }
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("restored")
    }
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("transaction Removed")
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        if SKPaymentQueue.canMakePayments() {
            print("Yes")
        } else {
            print("no")
        }
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    self.PostaddToBuy()
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    print("purchasedblocked")
                    break
                case .failed:
                    print("failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    print("restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                default: break
                }}}
    }
}
//extension Lect1Detail: PKPaymentAuthorizationViewControllerDelegate
//{
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController)
//    {
//        controller.dismiss(animated: true, completion: nil)
//    }
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void)
//    {
//        STPAPIClient.shared().createToken(with: payment) { (token: STPToken?, error: Error?) in
//            guard let token = token, error == nil else {
//                // Present error to user...
//                return
//            }
//            self.createBackendCharge(with: token, completion: completion)
//            //completion(PKPaymentAuthorizationStatus.success)
//        }
//    }
//    func createBackendCharge(with token: STPToken, completion: @escaping (_: PKPaymentAuthorizationStatus) -> Void) {
//        //We are printing Stripe token here, you can charge the Credit Card using this token from your backend.
//        print("Stripe Token is \(token)")
//        //call Api to pass token to backend
//        let StringToken = String(describing: token)
//        self.PostApplePayStripe(StringToken, completion: completion)
//       // completion(.success)
//    }
//}

