//
//  AlertPresenter.swift
//  unsplash_practice
//
//  Created by Денис Петров on 29.09.2024.
//


import UIKit

struct AlertPresenter: AlertPresenterProtocol {
    
    private weak var alertDelegate: AlertPresenterDelegate?
    
    init(alertDelegate: AlertPresenterDelegate) {
        self.alertDelegate = alertDelegate
    }
    
    func presentAlertController(alert: AlertModel) {
        let customAlert = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert)
        
        customAlert.view.accessibilityIdentifier = "NetworkErrorAlert"
        
        let action = UIAlertAction(
            title: alert.buttonText,
            style: .cancel)
        
        customAlert.addAction(action)
        
        alertDelegate?.showAlert(alert: customAlert)
    }
}
