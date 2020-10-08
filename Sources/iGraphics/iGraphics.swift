//
//  iGraphics.swift
//  iSwiftUITesting
//
//  Created by Benjamin Sage on 10/8/20.
//

import SwiftUI

@available(iOS 13.0, *)
/**
 Dummy gray box graphics to simulate text, images, or other content.
 
 Comes with several different style options:
 1. **Photo**: A small square photo with simulated text on its left or right
 2. **Paragraph**: A long rectangle with about 3:1 aspect ratio
 3. **Card**: A large and tall, almost square rounded box
 4. **Caption**: A long rectangle like paragraph but thinner, as if simulating less text
 
 Boxes can be easily stacked with proper spacing and padding by using the `.stack(_::)` modifier.
 
 */
public struct iGraphicsBox: View {
    private var textSize: CGFloat = 12
    private var flipped: Bool = false
    private var photoSize: CGFloat = 60
    private var cardSize: CGFloat = 150
    
    /**
     The style of the gray dummy boxes. Default is `.photo`.
     
     Comes with several options:
     1. **Photo**: A small square photo with simulated text on its left or right
     2. **Paragraph**: A long rectangle with about 3:1 aspect ratio
     3. **Card**: A large and tall, almost square rounded box
     4. **Caption**: A long rectangle like paragraph but thinner, as if simulating less text
    */
    public enum Style { case photo, paragraph, card, caption }
    private var style: Style
    
    /// Creates a new `iGraphicsBox` object in a desired style
    /// - Parameter style: Optional parameter for the graphics box style. Defaults to `.photo`.
    public init(_ style: Style = .photo) {
        self.style = style
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    private var color: Color {
        colorScheme == .dark ? darkColor : lightColor
    }
    private var lightColor = Color(red: 230 / 255,
                                   green: 230 / 255,
                                   blue: 230 / 255)
    private var darkColor = Color(hue: 0,
                                  saturation: 0,
                                  brightness: 25/100)
    
    private func square(_ g: GeometryProxy) -> some View {
        Rectangle()
            .cornerRadius(10)
            .frame(width: g.size.height,
                   height: g.size.height)
            .padding(flipped ? .leading : .trailing)
    }
    
    private var line: some View {
        Rectangle()
            .cornerRadius(10)
            .frame(height: textSize * 2)
            .padding(.bottom)
    }
    
    private var paragraph: some View {
        Rectangle()
            .cornerRadius(10)
    }
    
    public var body: some View {
        GeometryReader { g in
            switch style {
            case .photo:
                HStack(spacing: 0) {
                    if !flipped { square(g) }
                    VStack(spacing: 0) {
                        line
                        line
                        Spacer()
                    }
                    if flipped { square(g) }
                }
            case .paragraph:
                paragraph
            case .card:
                paragraph
                    .frame(height: cardSize * 2)
            case .caption:
                paragraph
                    .padding(.vertical)
            }
        }
        .frame(height: style == .card ? cardSize * 2 : photoSize * 2)
        .padding().padding(.horizontal)
        .foregroundColor(color)
    }
}

@available(iOS 13.0, *)
public extension iGraphicsBox {
    
    /// Flips the of `iGraphicsBox` across its horizontal axis, so the image is on the right and the text is on the left.
    /// Applies only to the `Style.photo` style, since the others are symmetrical.
    /// - Returns: A modified graphics box view flipped horizontally
    func flip() -> iGraphicsBox {
        var view = self
        view.flipped.toggle()
        return view
    }

    /**
     Modifies the text size that the boxes of words are meant to simulate.
     
     Passing a large number will make these boxes taller, and passing a small number will make the boxes shorter.
     Applies only to the `.photo` box size, since it's the only one that has simulated lines of text.
     
     - Parameter size: The size of the simulated font, in points.
     - Returns: A simulated graphics box with updated text size settings.
     */
    func textSize(_ size: CGFloat) -> iGraphicsBox {
        var view = self
        view.textSize = size
        return view
    }

    /**
     Modifies the photo size that the boxes are meant to simulate.
     
     Passing a large number will make these photo boxes larger, and passing a small number will make the photo boxes smaller.
     Applies only to the `.photo` box size, since it's the only one that has simulated a photo.

     - Parameter size: The size of the simulated photos, in points.
     - Returns: A simulated graphics box with updated photo size settings.
     */
    func photoSize(_ size: CGFloat) -> iGraphicsBox {
        var view = self
        view.photoSize = size
        return view
    }
    
    /**
     Modifies how many graphics boxes are stacked on top of each other.
     
     Allows you to easily stack simulated graphics without worrying about spacing creating your own `VStack` object.
     
     Will stack based on the style specificied in the constructor. To stack different types of boxes, use the other `.stack(_::)` modifier.
     
     - Parameters:
        - number: The number of graphics boxes that should be stacked on top of each other
        - alternating: Whether or not alternating boxes should be flipped.
     - Seealso: `iGraphicsBox.flip(_:)`
     - Returns: A simulated graphics view with a specified number of stacked boxes.
     */
    func stack(_ number: Int,
               alternating: Bool = false) -> some View
    {
        VStack(spacing: 0) {
            ForEach(0..<number, id: \.self) { i in
                if alternating && i % 2 != 0 {
                    self
                        .flip()
                } else {
                    self
                }
            }
        }
    }

    /**
     Modifies how many graphics boxes are stacked on top of each other.
     
     Allows you to easily stack simulated graphics without worrying about spacing creating your own `VStack` object.
     
     Will stack based on the styles specificied in the `styles` parameter.
     
     - Parameters:
        - styles: An array of the box styles that you would like to be stacked, in order.
        - alternating: Whether or not alternating boxes should be flipped.
     - Seealso: `iGraphicsBox.flip(_:)`
     - Returns: A simulated graphics view with a specified sequence of stacked boxes.
     */
    func stack(_ styles: [Style],
               alternating: Bool = false) -> some View
    {
        VStack(spacing: 0) {
            ForEach(0..<styles.count, id: \.self) { i in
                if alternating && i % 2 != 0 {
                    iGraphicsBox(styles[i])
                        .flip()
                } else {
                    iGraphicsBox(styles[i])
                }
            }
        }

    }
}

@available(iOS 13.0, *)
/**
 A view that easily creates great-looking dummy text to be used for placeholding.
 
 Automatically adapts to light or dark theme.
 */
public struct iGraphicsText: View {
    private var style: iGraphicsSwipeView.Style
    
    /// Creates new dummy text object with specified style.
    /// - Parameter style: Which number in a sequence of dummy images that should be displayed.
    public init(_ style: iGraphicsSwipeView.Style = .first) {
        self.style = style
    }
    
    private var weight: Font.Weight {
        colorScheme == .dark ? .semibold : .thin
    }
    private var color: Color {
        colorScheme == .dark ? darkColor : lightColor
    }
    private var lightColor = Color(red: 24 / 255,
                                   green: 24 / 255,
                                   blue: 24 / 255)
    private var darkColor = Color(red: 255 / 255,
                                  green: 255 / 255,
                                  blue: 255 / 255)
    
    @Environment(\.colorScheme) var colorScheme
    
    private let blurb1 = "Here's to the crazy ones.\nThe misfits.\nThe rebels."
    private let blurb2 = "The ones who see things differently."
    private let blurb3 = "They're not fond of rules.\nAnd they have no respect for the status quo."
    private var text: String {
        switch style {
        case .first:
            return blurb1
        case .second:
            return blurb2
        case .third:
            return blurb3
        }
    }
    
    public var body: some View {
        Text(text)
            .font(.system(size: 16, weight: weight, design: .rounded))
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .foregroundColor(color)
            .frame(width: 210)
            .padding()
    }
}

@available(iOS 13.0.0, *)
/// A great-looking dummy-image view displays as a square, and can show a number of different images.
public struct iGraphicsImage: View {
    private var style: iGraphicsSwipeView.Style
    
    /// Creates a new dummy image view from a specified style of image.
    /// - Parameter style: Which number in a sequence of dummy images that should be displayed.
    public init(_ style: iGraphicsSwipeView.Style = .first) {
        self.style = style
    }
    
    private var name: String {
        switch style {
        case .first: return "iGraphicsImage1"
        case .second: return "iGraphicsImage2"
        case .third: return "iGraphicsImage3"
        }
    }
    
    public var body: some View {
        GeometryReader { g in
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .position(x: g.size.width / 2,
                          y: g.size.height / 2)
        }
        .aspectRatio(contentMode: .fit)
    }
}

@available(iOS 13.0.0, *)
/// A great-looking dummy combined image and text view.
/// Comes in several different styles created from a sequence. Ideal for display in a page view.
public struct iGraphicsSwipeView: View {
    private var style: Style
    /// Which number in a sequence of dummy views that should be displayed.
    public enum Style { case first, second, third }
    
    /// Creates a new dummy swipe view from a specified style of image.
    /// - Parameter style: Which number in a sequence of dummy views that should be displayed.
    public init(_ style: Style = .first) {
        self.style = style
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            iGraphicsImage(style)
            iGraphicsText(style)
        }
    }
}
