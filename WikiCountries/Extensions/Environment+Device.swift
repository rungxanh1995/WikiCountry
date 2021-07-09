//
//  Environment+Device.swift
//  WikiCountry
//
//  Created by Joe Pham on 2021-06-02.
//

import UIKit
import CoreHaptics

extension UIDevice {
	/// Checks if we run in Mac Catalyst Optimized For Mac Idiom
	static var isCatalystMacIdiom: Bool {
		if #available(iOS 14, *) {
			return UIDevice.current.userInterfaceIdiom == .mac
		} else {
			return false
		}
	}
}

extension UIDevice {
	/// Custom Haptic code
	static var isHapticAvailable: Bool {
		return CHHapticEngine.capabilitiesForHardware().supportsHaptics
	}
	
	internal enum Haptic {
		case cell
		case button
	}
	
	static func hapticFeedback(from element: Haptic, isSuccessful: Bool = true) {
		switch element {
		case .cell:
			let generator = UIImpactFeedbackGenerator(style: isSuccessful ? .heavy : .soft)
			generator.impactOccurred(intensity: 1.0)
		case .button:
			let generator = UINotificationFeedbackGenerator()
			if isSuccessful {
				generator.notificationOccurred(.success)
			} else {
				generator.notificationOccurred(.error)
			}
		}
	}
}
