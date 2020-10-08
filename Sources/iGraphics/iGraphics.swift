//
//  iGraphics.swift
//  iSwiftUITesting
//
//  Created by Benjamin Sage on 10/8/20.
//

import SwiftUI

@available(iOS 13.0, *)
struct iGraphicsBox: View {
    private var textSize: CGFloat = 12
    private var flipped: Bool = false
    private var photoSize: CGFloat = 60
    private var cardSize: CGFloat = 150
    
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
    
    public enum Style {
        case photo, paragraph, card, caption
    }
    
    private var style: Style = .photo
    
    var body: some View {
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
extension iGraphicsBox {
    func flip() -> iGraphicsBox {
        var view = self
        view.flipped.toggle()
        return view
    }
    
    func textSize(_ size: CGFloat) -> iGraphicsBox {
        var view = self
        view.textSize = size
        return view
    }
    
    func photoSize(_ size: CGFloat) -> iGraphicsBox {
        var view = self
        view.photoSize = size
        return view
    }
    
    func style(_ style: Style) -> iGraphicsBox {
        var view = self
        view.style = style
        return view
    }
    
    func stack(_ number: Int,
               alternating: Bool = false) -> some View
    {
        VStack(spacing: 0) {
            ForEach(0..<number, id: \.self) { i in
                if alternating && i % 2 != 0 {
                    iGraphicsBox()
                        .style(style)
                        .flip()
                } else {
                    iGraphicsBox()
                        .style(style)
                }
            }
        }
    }
    
    func stack(_ styles: [Style],
               alternating: Bool = false) -> some View
    {
        VStack(spacing: 0) {
            ForEach(0..<styles.count, id: \.self) { i in
                if alternating && i % 2 != 0 {
                    iGraphicsBox()
                        .style(styles[i])
                        .flip()
                } else {
                    iGraphicsBox()
                        .style(styles[i])
                }
            }
        }
        
    }
}

@available(iOS 13.0, *)
struct iGraphicsText: View {
    private var style: iGraphicsSwipeView.Style
    
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
    
    var body: some View {
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
struct iGraphicsImage: View {
    private var style: iGraphicsSwipeView.Style
    
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
    
    var body: some View {
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
struct iGraphicsSwipeView: View {
    private var style: Style
    public enum Style { case first, second, third }
    
    public init(_ style: Style = .first) {
        self.style = style
    }
    
    var body: some View {
        VStack(spacing: 0) {
            iGraphicsImage(style)
            iGraphicsText(style)
        }
    }
}
