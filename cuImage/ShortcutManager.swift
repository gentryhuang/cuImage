//
//  ShortcutManager.swift
//  cuImage
//
//  Created by HuLizhen on 06/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Foundation
import MASShortcut

// MARK: - ShortcutManager
final class ShortcutManager {
    static let shared = ShortcutManager()
    
    private init() {
        // Set the value transformer for MASShortcut.
        let transformer = ValueTransformer(forName: .keyedUnarchiveFromDataTransformerName)!
        MASShortcutBinder.shared().bindingOptions = [NSValueTransformerBindingOption: transformer]
        
        bindShortcuts()
    }
    
    private func bindShortcuts() {
        MASShortcutBinder.shared().bindShortcut(withDefaultsKey: PreferenceKeys.uploadImageShortcut.rawValue,
                                                toAction: uploadImageOnPasteboard)
    }
}

// MARK: - Shortcut Actions
extension ShortcutManager {
    fileprivate func uploadImageOnPasteboard() {
        UploadController.shared.uploadImageOnPasteboard()
    }
}