//
//  ApplePay.swift
//  ResortCeApp
//
//  Created by AJ12 on 04/05/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
import PassKit
import Stripe

class ApplePay: UIViewController {
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let ApplePaySwagMerchantID = "merchant.cqlsys.ResortceNewId" // Fill in your merchant ID here!


    override func viewDidLoad()
    {
        super.viewDidLoad()
       //applePayButton.hidden = !PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(SupportedPaymentNetworks)
    }
    
    func buttonaction ()
    {
        let request = PKPaymentRequest()
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        request.merchantIdentifier = ApplePaySwagMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "set name", amount: 10),
            PKPaymentSummaryItem(label: "Razeware", amount: 10)
        ]
        request.requiredShippingAddressFields = PKAddressField.all

        applePayController?.delegate = self
        self.present(applePayController!, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

extension ApplePay: PKPaymentAuthorizationViewControllerDelegate
{
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void)
    {
        completion(PKPaymentAuthorizationStatus.success)
    }
}
