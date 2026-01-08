//
//  SnackBar.swift
//  Plasso_Plastics
//
//  Created by Admin on 11/01/22.
//

import Foundation

import UIKit

class SnackBarView: UIView {
        
    private var label = { () -> UILabel in
        let label = UILabel()
        label.numberOfLines = 0
        label.tag = 94321
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize:15)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var button = { () -> UIButton in
        let button = UIButton()
       // button.setTitleColor(R.color.orange(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize:15)
        button.setTitle("DONE", for: .normal)
        button.addTarget(self, action:#selector(btnDoneAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()
    
    var action:(()->())?
    var message:String?{
        didSet{
            label.text = message
        }
    }
    
    init(message:String?){
        super.init(frame: .zero)
        
        tag = 943210
        layer.cornerRadius = 0
        clipsToBounds = true
        backgroundColor = .darkGray
        translatesAutoresizingMaskIntoConstraints = false
        
        label.text = message
        
        let stack = UIStackView(arrangedSubviews: [label,button])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(stack)
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        addSubview(view)
        
        view.heightAnchor.constraint(equalToConstant: (UIApplication.shared.windows.last?.safeAreaInsets.bottom ?? 0) + 8).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func showSnackBar(action:(()->())?){
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        layoutIfNeeded()
        self.action = action
        let height = frame.height + 100
        transform = CGAffineTransform(translationX: 0, y: height)
        
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.transform = .identity
        }) { (finished) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if let _ = self.superview{
                    self.removeSnackBar()
                }
            }
        }
    }
    
    
    private func removeSnackBar(){
        layoutIfNeeded()
        let height = frame.height + 100
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.transform = .init(translationX: 0, y: height)
        }) { (finished) in
            isSnackBarShown = false
            self.layer.removeAllAnimations()
            self.layoutIfNeeded()
            self.removeFromSuperview()
        }
    }
    
    @objc func btnDoneAction(){
        action?()
        removeSnackBar()
    }
    
    deinit {
        print("Removed",self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//import Toast_Swift
    
    var isSnackBarShown = false
    
    public func showSnackBar(message:String?,action:(()->())? = nil){
        
//        var style = ToastStyle()
//
//        style.messageColor = .white
//        style.titleColor = .white
//        style.imageSize = .init(width: 30, height: 30)
//        style.backgroundColor = R.color.orange() ?? .darkGray
//        style.maxWidthPercentage = 1
//        style.verticalPadding = 10
//
//
//        ez.topMostVC?.view.makeToast(message, duration: 2.0, position: .top,title:"Livrit",image: UIImage(systemName: "info.circle"),style:style)
        
        isSnackBarShown = false
        guard let window = UIApplication.shared.windows.last else {return}
                            guard !isSnackBarShown else {
                                if let snackBarView = window.viewWithTag(943210) as? SnackBarView{
                                    snackBarView.message = message
                                    snackBarView.action = action
                                }
                                return
                            }

        let snackBarView = SnackBarView(message: message)

        window.addSubview(snackBarView)

        snackBarView.leadingAnchor.constraint(equalTo: window.leadingAnchor,constant: 0).isActive = true
        snackBarView.trailingAnchor.constraint(equalTo: window.trailingAnchor,constant: 0).isActive = true
        snackBarView.bottomAnchor.constraint(equalTo: window.bottomAnchor,constant: 0).isActive = true


        snackBarView.showSnackBar(action:action)
        
        
        
    }
    
