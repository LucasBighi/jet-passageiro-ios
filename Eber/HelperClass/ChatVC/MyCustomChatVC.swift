//
//  MyCustomChatVC.swift
//  Qatch Driver
//
//  Created by Elluminati on 03/05/18.
//  Copyright © 2018 Elluminati Mini Mac 5. All rights reserved.
//

import UIKit
import FirebaseAuth
import IQKeyboardManagerSwift

class MyCustomChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource,MessageRecivedDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
   
    // MARK:-
    // MARK:- Outlet and Variable
    
    @IBOutlet weak var viewForNavigation: UIView!
    @IBOutlet weak var btnBack: UIButton!
   
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var tblChat: UITableView!
    
    @IBOutlet var txtMessage: UITextView!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var constraintForTextView: NSLayoutConstraint!
   
    private var arrMessages:[FirebaseMessage] = []
   
    var keyboardHeight = 60
    
    let ChatRef = DBProvider.Instance.dbRef.child(CurrentTrip.shared.tripId).child(CONSTANT.DBPROVIDER.MESSAGES)
    // MARK:-
    // MARK:- Life Cycle
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MessageHandler.Instace.delegate = self
        MessageHandler.Instace.removeObserver()
        MessageHandler.Instace.observeMessage()
        MessageHandler.Instace.observeUpdateMessage()
        
        tblChat.estimatedRowHeight = 90
        tblChat.rowHeight = UITableView.automaticDimension
        preferenceHelper.setChatName(CurrentTrip.shared.tripId)
        constraintForTextView.constant = 40
        txtMessage.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        txtMessage.backgroundColor = UIColor.themeViewBackgroundColor
        txtMessage.textColor = UIColor.themeTextColor
        txtMessage.tintColor = UIColor.themeTextColor
        btnSend.backgroundColor = UIColor.themeButtonBackgroundColor
        btnSend.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnSend.setTitle("TXT_SEND".localizedCapitalized, for: .normal)
        txtMessage.text = "PLACE_HOLDER_ENTER_MESSAGE".localized
        
        lblTitle.text = "TXT_CHAT_WITH".localized + CurrentTrip.shared.tripStaus.trip.providerFirstName + " " +  CurrentTrip.shared.tripStaus.trip.providerLastName
        
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        btnBack.setupBackButton()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        

        
        IQKeyboardManager.shared.enable = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        Utility.hideLoading()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnSend.setRound(withBorderColor: .clear, andCornerRadious: btnSend.frame.height/2, borderWidth: 1.0)
        viewForNavigation.navigationShadow()
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = Int(keyboardRectangle.height)
            self.view.frame.origin.y = CGFloat(-keyboardHeight)
        }
    }
    
    
    @objc func keyboardWillHide(_ notification: Notification)
        {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                keyboardHeight = Int(keyboardRectangle.height + 10)
                self.view.frame.origin.y = 0
            }
            
    }
    // MARK:-
    // MARK:- Tableview Data Source and delegate Method
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
        let message:FirebaseMessage = arrMessages[indexPath.row]
        
        if message.type == CONSTANT.TYPE_USER
        {
            let cell:SenderCell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as! SenderCell
            cell.setCellData(dict: message)
            return cell
        }
        else
        {
            
            let cell:ReciverCell = tableView.dequeueReusableCell(withIdentifier: "reciverCell", for: indexPath) as! ReciverCell
            cell.setCellData(dict: message)
            if message.isRead == false
            {
                MessageHandler.Instace.readMessage(id: message.id)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }

   
    
    
    // MARK:-
    // MARK:- Message Recived Delegate
    
    func messageRecived(data: FirebaseMessage)
    {
        if let index = arrMessages.firstIndex(where: { (message) -> Bool in
            message.id == data.id
        })
        {
         printE(index)
        }
        else
        {
            arrMessages.append(data)
        }
        
        tblChat.reloadData()
        scrollToBottom()
    }
    
    func messageUpdated(data: FirebaseMessage)
    {
        if let index = arrMessages.firstIndex(where: { (message) -> Bool in
            message.id == data.id
        })
        {
            arrMessages[index].isRead = true
        }
        tblChat.reloadData()
        scrollToBottom()
    }
    
    
    // MARK:-
    // MARK:- TextView Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if txtMessage.text == "PLACE_HOLDER_ENTER_MESSAGE".localized
        {
            txtMessage.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
       
        if txtMessage.text == ""
        {
            txtMessage.text = "PLACE_HOLDER_ENTER_MESSAGE".localized
            
        }
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
      
        
    }
    
    // MARK:-
    // MARK:- Tap Gesture Delegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: tblChat))! {
            return true
        }
        return true
    }
    
    @IBAction func onClickBtnMenu(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK:-
    // MARK:- Button Click Method
    
    @IBAction func onClickBtnAttachment(_ sender: Any)
    {
        self.performSegue(withIdentifier:"segueToCreateTrip", sender: self)
    }
    
    @IBAction func onClickBtnSend(_ sender: Any)
    {
        btnSend.isEnabled = false
        if !txtMessage.text.isEmpty() && txtMessage.text != "PLACE_HOLDER_ENTER_MESSAGE".localized
        {
            MessageHandler.Instace.sendMessage(text: txtMessage.text, time:
            Date().toString(withFormat: DateFormat.WEB, timeZone: "UTC"))
            
            txtMessage.endEditing(true)
            txtMessage.text = "PLACE_HOLDER_ENTER_MESSAGE".localized
           
         
            if arrMessages.count > 0
            {
                self.scrollToBottom()
            }
            btnSend.isEnabled = true
            
        }
        else
        {
            self.txtMessage.endEditing(true)
            btnSend.isEnabled = true
        }
    }
   
    @IBAction func onClickBtnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //    MARK:-
    //    MARK:- User Define Method
    
   
    
    func scrollToBottom()
    {
        DispatchQueue.main.async
        { [unowned self] in
            let indexPath = IndexPath(row: (self.arrMessages).count - 1, section:0)
            self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
        self.txtMessage.endEditing(true)
    }
    //    MARK:-
    //    MARK:- Memory Management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:-
    // MARK:- Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {

    }
    @IBAction func onClickBtnNavBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}

