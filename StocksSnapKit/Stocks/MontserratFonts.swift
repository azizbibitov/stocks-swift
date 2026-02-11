//
//  MontserratFonts.swift
//  StocksSnapKit
//
//  Created by Aziz Bibitov on 06/08/2025.
//

import UIKit

/// A utility class for easy access to Montserrat fonts
class MontserratFonts {
    
    // MARK: - Font Names
    
    /// Montserrat font family name
    static let familyName = "Montserrat"
    
    /// Available Montserrat font names
    enum FontName: String, CaseIterable {
        case black = "Montserrat-Black"
        case blackItalic = "Montserrat-BlackItalic"
        case bold = "Montserrat-Bold"
        case boldItalic = "Montserrat-BoldItalic"
        case extraBold = "Montserrat-ExtraBold"
        case extraBoldItalic = "Montserrat-ExtraBoldItalic"
        case extraLight = "Montserrat-ExtraLight"
        case extraLightItalic = "Montserrat-ExtraLightItalic"
        case italic = "Montserrat-Italic"
        case light = "Montserrat-Light"
        case lightItalic = "Montserrat-LightItalic"
        case medium = "Montserrat-Medium"
        case mediumItalic = "Montserrat-MediumItalic"
        case regular = "Montserrat-Regular"
        case semiBold = "Montserrat-SemiBold"
        case semiBoldItalic = "Montserrat-SemiBoldItalic"
        case thin = "Montserrat-Thin"
        case thinItalic = "Montserrat-ThinItalic"
    }
    
    // MARK: - Font Creation Methods
    
    /// Creates a UIFont with the specified Montserrat font name and size
    /// - Parameters:
    ///   - fontName: The Montserrat font variant to use
    ///   - size: The font size in points
    /// - Returns: A UIFont instance, or system font as fallback
    static func font(_ fontName: FontName, size: CGFloat) -> UIFont {
        return UIFont(name: fontName.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    /// Creates a UIFont with the specified Montserrat font name and text style
    /// - Parameters:
    ///   - fontName: The Montserrat font variant to use
    ///   - textStyle: The preferred text style
    /// - Returns: A UIFont instance, or system font as fallback
    static func font(_ fontName: FontName, textStyle: UIFont.TextStyle) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        let size = descriptor.pointSize
        return UIFont(name: fontName.rawValue, size: size) ?? UIFont.preferredFont(forTextStyle: textStyle)
    }
    
    // MARK: - Convenience Methods for Common Fonts
    
    /// Regular Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-Regular font
    static func regular(size: CGFloat) -> UIFont {
        return font(.regular, size: size)
    }
    
    /// Bold Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-Bold font
    static func bold(size: CGFloat) -> UIFont {
        return font(.bold, size: size)
    }
    
    /// Medium Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-Medium font
    static func medium(size: CGFloat) -> UIFont {
        return font(.medium, size: size)
    }
    
    /// Light Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-Light font
    static func light(size: CGFloat) -> UIFont {
        return font(.light, size: size)
    }
    
    /// SemiBold Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-SemiBold font
    static func semiBold(size: CGFloat) -> UIFont {
        return font(.semiBold, size: size)
    }
    
    /// Black Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-Black font
    static func black(size: CGFloat) -> UIFont {
        return font(.black, size: size)
    }
    
    /// Thin Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-Thin font
    static func thin(size: CGFloat) -> UIFont {
        return font(.thin, size: size)
    }
    
    /// ExtraLight Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-ExtraLight font
    static func extraLight(size: CGFloat) -> UIFont {
        return font(.extraLight, size: size)
    }
    
    /// ExtraBold Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-ExtraBold font
    static func extraBold(size: CGFloat) -> UIFont {
        return font(.extraBold, size: size)
    }
    
    // MARK: - Italic Variants
    
    /// Regular Italic Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-Italic font
    static func italic(size: CGFloat) -> UIFont {
        return font(.italic, size: size)
    }
    
    /// Bold Italic Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-BoldItalic font
    static func boldItalic(size: CGFloat) -> UIFont {
        return font(.boldItalic, size: size)
    }
    
    /// Medium Italic Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-MediumItalic font
    static func mediumItalic(size: CGFloat) -> UIFont {
        return font(.mediumItalic, size: size)
    }
    
    /// Light Italic Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-LightItalic font
    static func lightItalic(size: CGFloat) -> UIFont {
        return font(.lightItalic, size: size)
    }
    
    /// SemiBold Italic Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-SemiBoldItalic font
    static func semiBoldItalic(size: CGFloat) -> UIFont {
        return font(.semiBoldItalic, size: size)
    }
    
    /// Black Italic Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-BlackItalic font
    static func blackItalic(size: CGFloat) -> UIFont {
        return font(.blackItalic, size: size)
    }
    
    /// Thin Italic Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-ThinItalic font
    static func thinItalic(size: CGFloat) -> UIFont {
        return font(.thinItalic, size: size)
    }
    
    /// ExtraLight Italic Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-ExtraLightItalic font
    static func extraLightItalic(size: CGFloat) -> UIFont {
        return font(.extraLightItalic, size: size)
    }
    
    /// ExtraBold Italic Montserrat font
    /// - Parameter size: Font size in points
    /// - Returns: Montserrat-ExtraBoldItalic font
    static func extraBoldItalic(size: CGFloat) -> UIFont {
        return font(.extraBoldItalic, size: size)
    }
    
    // MARK: - Utility Methods
    
    /// Checks if Montserrat fonts are available
    /// - Returns: True if Montserrat fonts are loaded
    static func areFontsAvailable() -> Bool {
        return UIFont.familyNames.contains(familyName)
    }
    
    /// Gets all available Montserrat font names
    /// - Returns: Array of available Montserrat font names
    static func availableFontNames() -> [String] {
        return UIFont.fontNames(forFamilyName: familyName)
    }
    
    /// Prints all available Montserrat fonts for debugging
    static func printAvailableFonts() {
        print("=== Montserrat Fonts Availability ===")
        if areFontsAvailable() {
            let fontNames = availableFontNames()
            print("✅ Montserrat fonts are available (\(fontNames.count) fonts):")
            for fontName in fontNames.sorted() {
                print("  - \(fontName)")
            }
        } else {
            print("❌ Montserrat fonts are NOT available")
            print("Available font families:")
            for family in UIFont.familyNames.sorted() {
                print("  - \(family)")
            }
        }
        print("=====================================")
    }
}

// MARK: - UIFont Extensions

extension UIFont {
    
    /// Creates a Montserrat font with the specified variant and size
    /// - Parameters:
    ///   - montserratFont: The Montserrat font variant
    ///   - size: Font size in points
    /// - Returns: A UIFont instance
    static func montserrat(_ montserratFont: MontserratFonts.FontName, size: CGFloat) -> UIFont {
        return MontserratFonts.font(montserratFont, size: size)
    }
    
    /// Creates a Montserrat font with the specified variant and text style
    /// - Parameters:
    ///   - montserratFont: The Montserrat font variant
    ///   - textStyle: The preferred text style
    /// - Returns: A UIFont instance
    static func montserrat(_ montserratFont: MontserratFonts.FontName, textStyle: UIFont.TextStyle) -> UIFont {
        return MontserratFonts.font(montserratFont, textStyle: textStyle)
    }
} 