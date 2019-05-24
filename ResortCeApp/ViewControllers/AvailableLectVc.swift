//
//  AvailableLectVc.swift
//  ResortCeApp
//
//  Created by AJ12 on 13/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKLoginKit
import Alamofire
import GoogleSignIn
import SDWebImage
import Toaster
import PassKit
import Stripe
import StoreKit
struct ProductID
{
    static let ResortCeFirst = "ResortCeFirstProductIdConsumable"
    static let ResortCeSecond = "ResortCeSecondProductIdConsumable"
    static let ResortCeThird = "ResortCeThirdProductIdconsumable"
    static let ResortCeFourth = "ResortCeFourthProductIdconsumable"
    
}
class CellLectAvailable : UITableViewCell
{
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var HeartBtn: UIButton!
    @IBOutlet weak var Detailbtn: UIButton!
    @IBOutlet weak var Txt_LectReview: UILabel!
    @IBOutlet weak var BuyBtn: UIButton!
    @IBOutlet weak var LblLectName: UILabel!
}
class AvailableLectVc: UIViewController {
    @IBOutlet weak var navigationHeight: NSLayoutConstraint!
    {
        didSet
        {
            if IdentifyIphone() == iPhoneX
            {
                navigationHeight.constant = 100.0
            }
        }
    }
    
    @IBOutlet weak var LblLectTitle: UILabel!
    @IBOutlet weak var RestoreBtn: UIButton!
    var nameArray : [[String:Any]] = []
    var overViewArray : [String] = []
    var detail : String = ""
    var getGroupId = ""
    var BtnType = Int()
    var buyBtnTYpe = ""
    var PostReview = ""
    var DatahotelDict : [String:Any] = [:]
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex,PKPaymentNetwork.discover]
    let ApplePaySwagMerchantID = "merchant.cqlsys.ResortceNewId"
    var CourseName = ""
    var CourseFee : NSDecimalNumber!
    var StringCourseFee = ""
    @IBOutlet weak var tblVwAvailLect: UITableView!
    var shouldShowBuyBtn: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
      PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: SupportedPaymentNetworks)
        print(DatahotelDict)
    }
    
    @IBAction func restoreAction(_ sender: UIButton) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden  = true
        self.getOneCourseList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         if self.shouldShowBuyBtn {
            SKPaymentQueue.default().remove(self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.shouldShowBuyBtn {
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
    }
   
    func getOneCourseList() {
        if let authKey = UserDefaults.standard.value(forKey: "auth_key") as? String {
            ActivityIndicator.shared.show(self.view)
            print(detail)
            DataManager.postAPIWithParameters(urlString: API.one_course_list, jsonString: Request.oneCourseId(authKey,  detail) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                if let nameArr = sucess["body"] as? [[String:Any]] {
                    self.nameArray = nameArr
                    self.tblVwAvailLect.reloadData()
                }
                
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
    }
    
    func PostaddToBuy() {
        getGroupId = detail
        if let authKey = UserDefaults.standard.value(forKey: "authKey") as? String, let hotelId = DatahotelDict["HotelId"] as? String, let hotelName = DatahotelDict["HotelName"] as? String, let hotelAddress = DatahotelDict["HotelAddress"] as? String, let hotelLat = DatahotelDict["HotelLatitude"] as? String, let hotelLong = DatahotelDict["HotelLongitude"] as? String, let hotelWeb = DatahotelDict["HotelWebsite"] as? String, let hotelPhone = DatahotelDict["HotelPhone"] as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.course_add_to_buy, jsonString: Request.AddtoBuy(authKey,detail,buyBtnTYpe,getGroupId, hotelId, hotelName, hotelAddress, hotelLat, hotelLong, hotelWeb, hotelPhone) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                self.getOneCourseList()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LectReviewVc") as! LectReviewVc
                vc.getReview = self.PostReview
                self.navigationController?.pushViewController(vc, animated: true)
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
        
     }
    
    ////////////
    
    func PostApplePayStripe(_ token:String,completion: @escaping (_: PKPaymentAuthorizationStatus) -> Void) {
        if let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
            ActivityIndicator.shared.show(self.view)
            DataManager.postAPIWithParameters(urlString: API.PaymentStripeApplePay, jsonString: Request.StripeApplePay(authKey, detail,token,StringCourseFee) as [String : AnyObject], success: {
                sucess in
                ActivityIndicator.shared.hide()
                completion(.success)
                self.PostaddToBuy()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LectReviewVc") as! LectReviewVc
                vc.getReview = self.PostReview
                self.navigationController?.pushViewController(vc, animated: true)
                
            }, failure: {
                fail in
                ActivityIndicator.shared.hide()
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ActnHeartBtn(_ sender: UIButton)
    {
        
    }
  //  func AppleBtnAction ()
//    {
//         let request = Stripe.paymentRequest(withMerchantIdentifier: ApplePaySwagMerchantID, country: "US", currency: "USD")
//        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: SupportedPaymentNetworks)
//        {
//      //  request.merchantIdentifier = ApplePaySwagMerchantID
//        request.supportedNetworks = SupportedPaymentNetworks
//            request.merchantCapabilities = .capability3DS
//
//       // request.countryCode = "US"
//        //request.currencyCode = "USD"
//        request.paymentSummaryItems = [
//            PKPaymentSummaryItem(label: CourseName, amount: CourseFee)]
//        request.requiredShippingAddressFields = PKAddressField.email
//        request.requiredBillingAddressFields = PKAddressField.phone
//        }
//        if Stripe.canSubmitPaymentRequest(request)
//        {
//        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
//        applePayController?.delegate = self
//        self.present(applePayController!, animated: true, completion: nil)
//        }else{
//             UIAlertController.show(self, "Payment", "Cant Make Payment Now")
//        }
//    }
    @IBAction func ActnBuyBtn(_ sender: UIButton) {
        if sender.currentTitle == "Buy" {
           // self.AppleBtnAction()
            if (SKPaymentQueue.canMakePayments()) {
                detail = String(sender.tag)
                buyBtnTYpe = "1"
                ActivityIndicator.shared.show(self.view)
                let productID:NSSet = NSSet(objects: ProductID.ResortCeFirst,ProductID.ResortCeSecond,ProductID.ResortCeThird,ProductID.ResortCeFourth)
                let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
                productsRequest.delegate = self
                productsRequest.start()
                print("Fetching Products")
            } else {
                print("can't make purchases")
            }
        } else if sender.currentTitle == "No Product" {
            Toast(text: "No Product Found").show()
        } else {
            Toast(text: "Already Purchased").show()
        }
    }
    
    func buyProduct(product: SKProduct) {
        ActivityIndicator.shared.hide()
        print("Sending the Payment Request to Apple")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    @IBAction func ActnDetailBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Lect1Detail") as! Lect1Detail
        vc.detail = String(sender.tag)
        vc.groupid = getGroupId
        vc.DatahotelDict = DatahotelDict
        vc.StringCourseFee = StringCourseFee
        vc.shouldShowBuyBtn = shouldShowBuyBtn
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ActnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension AvailableLectVc : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellLectAvailable") as? CellLectAvailable
        let values = nameArray[indexPath.row]
        cell?.LblLectName.text = values["name"] as? String
        //let ItunesId = values["itune_product_id"] as? String
        let fee = values["fee"] as? String
        CourseFee = NSDecimalNumber(string: fee)
        CourseName = (values["name"] as? String)!
        StringCourseFee = (values["fee"] as? String)!
        print("Course Fees ID: \(StringCourseFee)")
        PostReview = (values["id"] as? String)!
        detail = (values["id"] as? String)!
        cell?.Detailbtn.tag = Int(detail)!
        cell?.BuyBtn.tag = Int(detail)!
        cell?.Txt_LectReview.text = values["overview"] as? String
        let photo = values["image"] as? String
        if (photo != ""){
         cell?.imageVw.sd_setImage(with: URL(string: photo!), placeholderImage: UIImage(named: "Bed"))
        }
        BtnType = Int(values["favourite"] as! String)!
        buyBtnTYpe = values["buy"] as! String
        if BtnType == 1 {
            cell?.HeartBtn.setImage(#imageLiteral(resourceName: "RedHeart"), for: .normal)
        } else {
            cell?.HeartBtn.setImage(#imageLiteral(resourceName: "BLackHeart"), for: .normal)
        }
        
        if buyBtnTYpe == "1" {
            cell?.BuyBtn.setTitle("Purchased", for: .normal)
        } else {
          //  if product_id  == ItunesId
          //  {
                cell?.BuyBtn.setTitle("Buy", for: .normal)
            //cell?.BuyBtn.isEnabled = Stripe.deviceSupportsApplePay()
           // }
           // else
           // {
               // cell?.BuyBtn.setTitle("No Product", for: .normal)
           // }
        }
        
        if self.shouldShowBuyBtn {
            cell?.BuyBtn.isHidden = false
        } else {
            cell?.BuyBtn.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let values = nameArray[indexPath.row]
         if self.shouldShowBuyBtn {
            if let val = values["buy"] as? String {
                buyBtnTYpe = val
                if buyBtnTYpe == "1" {
                    PostReview = values["id"] as? String ?? ""
                    let vc = storyboard?.instantiateViewController(withIdentifier: "LectReviewVc") as! LectReviewVc
                    vc.getReview = PostReview
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    UIAlertController.show(self, "Message", "Buy Course First")
                }
            }
         } else {
           /* PostReview = values["id"] as? String ?? ""
            let vc = storyboard?.instantiateViewController(withIdentifier: "LectReviewVc") as! LectReviewVc
            vc.getReview = PostReview
            self.navigationController?.pushViewController(vc, animated: true)*/
        }
       
    }
}
extension AvailableLectVc: SKProductsRequestDelegate,SKPaymentTransactionObserver{
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        print(response.products)
        var ProductIndex = Int()
        var productIdIndex = ""
        if let Course_Fees = Int(StringCourseFee) {
            if Course_Fees >= 1 ||  Course_Fees <= 9 {
                ProductIndex = 0
                productIdIndex = ProductID.ResortCeFirst
            } else if Course_Fees >= 10 || Course_Fees <= 19 {
                ProductIndex = 2
                productIdIndex = ProductID.ResortCeSecond
            } else if Course_Fees >= 20 || Course_Fees <= 29 {
                ProductIndex = 3
                productIdIndex = ProductID.ResortCeThird
            } else if Course_Fees >= 30 || Course_Fees <= 39 {
                ProductIndex = 1
                productIdIndex = ProductID.ResortCeFourth
            }
            
            let count : Int = response.products.count
            if (count > 0) {
                let validProduct: SKProduct = response.products[ProductIndex] as SKProduct
                if (validProduct.productIdentifier == productIdIndex as String) {
                    print(validProduct.localizedTitle)
                    print(validProduct.localizedDescription)
                    print(validProduct.price)
                    self.buyProduct(product: validProduct)
                } else {
                    ActivityIndicator.shared.hide()
                    print(validProduct.productIdentifier)
                }
            } else {
                ActivityIndicator.shared.hide()
                print("nothing")
            }
        }
        
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("request fail error: \(error.localizedDescription)")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("restored")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("transaction Removed")

    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
           // self.PostaddToBuy()
            if let trans = transaction as? SKPaymentTransaction {
                 ActivityIndicator.shared.hide()
                switch trans.transactionState {
                case .purchasing:
                    print("purchasing")
                    break
                
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
                    SKPaymentQueue.default().restoreCompletedTransactions()
                     self.PostaddToBuy()
                    break
                default: break
                }}}
    }
}
//extension AvailableLectVc: PKPaymentAuthorizationViewControllerDelegate
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
//
//            }
//
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




