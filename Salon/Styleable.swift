//
// The MIT License (MIT) - Copyright © 2018 Unsigned Apps Pty Ltd
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

/// A convenience protocol that allows you to easily apply ViewStyle's directly to
/// conforming objects such as `UIView` or `CALayer`.
public protocol Styleable {

    associatedtype ViewType: NSObject

    /// This should apply the specified ViewStyle to the receiving item.
    ///
    /// The default implementation of this calls `ViewStyle.apply(to:)`
    ///
    /// - Parameters:
    ///   - style: A single ViewStyle of the same type as the receiver that will be applied to the receiver.
    ///
    func apply (style: ViewStyle<ViewType>)

    /// This should apply the specified ViewStyles to the receiving item.
    ///
    /// The default implementation of this creates a composite ViewStyle calls `ViewStyle.apply(to:)`.
    ///
    /// - Parameters:
    ///   - styles: One or more ViewStyles of the same type as the receiver that will be applied to the receiver.
    ///
    func apply (styles: ViewStyle<ViewType>...)

    /// This should conditionally apply the specified styler closure to the receiver if one or more of the
    /// specified conditions are true.
    ///
    /// The default implementation of this creates a ViewStyle and calls `ViewStyle.apply(to:)`.
    ///
    /// - Parameters:
    ///   - when: One or more `Condition`s that will be evaluated prior to applying the styler closure.
    ///   - styler: An escaping closure that accepts the item to be styled as
    ///             its only parameter and should be used to set the appropriate
    ///             style-related properties of the item.
    ///
    func apply (when conditions: ViewStyle<ViewType>.Condition..., styler: @escaping ViewStyle<ViewType>.Styler)
}

// MARK: - Default Implementation

extension Styleable {
    typealias Style = ViewStyle<Self>
    public func apply (style: ViewStyle<Self>) {
        style.apply(to: self)
    }

    public func apply (styles: ViewStyle<Self>...) {
        let style = ViewStyle.compose(styles)
        style.apply(to: self)
    }

    public func apply (when conditions: ViewStyle<Self>.Condition..., styler: @escaping ViewStyle<Self>.Styler) {
        let style = ViewStyle(stylers: [ (conditions: conditions, styler: styler) ])
        style.apply(to: self)
    }
}

// MARK: - Styleable Conformance

extension UIView: Styleable {}
extension CALayer: Styleable {}


// MARK: - Convenience Initialisers

extension Styleable where Self: UIView {
    
    /// Initialises the UIView (or subclass) with a .zero frame and applies the given style.
    ///
    /// Note: if you want to init your UIView (or subclass) with a non-zero rect or some other initialiser, this convenience init is not for you.
    ///
    /// - Parameters:
    ///   - style: A single ViewStyle of the same type as the receiver that will be applied to the receiver.
    ///
    public init (style: ViewStyle<Self>) {
        self.init(frame: .zero)
        style.apply(to: self)
    }
    
    /// Initialises the UIView (or subclass) with a .zero frame and applies the given styles.
    ///
    /// Note: if you want to init your UIView (or subclass) with a non-zero rect or some other initialiser, this convenience init is not for you.
    ///
    /// - Parameters:
    ///   - styles: One or more ViewStyles of the same type as the receiver that will be applied to the receiver.
    ///
    public init (styles: ViewStyle<Self>...) {
        self.init(frame: .zero)
        let style = ViewStyle.compose(styles)
        style.apply(to: self)
    }

    /// Initialises the UIView (or subclass) and applies the specified styler closure to the receiver.
    ///
    /// Note: if you want to init your UIView (or subclass) with a non-zero rect or some other initialiser, this convenience init is not for you.
    ///
    /// - Parameters:
    ///   - styler: An escaping closure that accepts the item to be styled as
    ///             its only parameter and should be used to set the appropriate
    ///             style-related properties of the item.
    ///
    public init (styler: @escaping ViewStyle<Self>.Styler) {
        self.init(frame: .zero)
        let style = ViewStyle(stylers: [ (conditions: nil, styler: styler) ])
        style.apply(to: self)
    }

    /// Initialises the UIView (or subclass) and conditionally applies the specified styler closure
    /// to the receiver if one or more of the specified conditions are true.
    ///
    /// Note: if you want to init your UIView (or subclass) with a non-zero rect or some other initialiser, this convenience init is not for you.
    ///
    /// - Parameters:
    ///   - when: One or more `Condition`s that will be evaluated prior to applying the styler closure.
    ///   - styler: An escaping closure that accepts the item to be styled as
    ///             its only parameter and should be used to set the appropriate
    ///             style-related properties of the item.
    ///
    public init (when conditions: [ViewStyle<Self>.Condition]?, styler: @escaping ViewStyle<Self>.Styler) {
        self.init(frame: .zero)
        let style = ViewStyle(stylers: [ (conditions: conditions, styler: styler) ])
        style.apply(to: self)
    }
}

extension Styleable where Self: CALayer {

    /// Initialises the CALayer (or subclass) and applies the given style.
    ///
    /// Note: if you want to init your CALayer (or subclass) with an initaliser other than `init()`, this convenience init is not for you.
    ///
    /// - Parameters:
    ///   - style: A single ViewStyle of the same type as the receiver that will be applied to the receiver.
    ///
    public init (style: ViewStyle<Self>) {
        self.init()
        style.apply(to: self)
    }
    
    /// Initialises the CALayer (or subclass) and applies the given styles.
    ///
    /// Note: if you want to init your UIView (or subclass) with a non-zero rect or some other initialiser, this convenience init is not for you.
    ///
    /// - Parameters:
    ///   - styles: One or more ViewStyles of the same type as the receiver that will be applied to the receiver.
    ///
    public init (styles: ViewStyle<Self>...) {
        self.init()
        let style = ViewStyle.compose(styles)
        style.apply(to: self)
    }
    
    /// Initialises the CALayer (or subclass) and applies the specified styler closure to the receiver.
    ///
    /// Note: if you want to init your UIView (or subclass) with a non-zero rect or some other initialiser, this convenience init is not for you.
    ///
    /// - Parameters:
    ///   - styler: An escaping closure that accepts the item to be styled as
    ///             its only parameter and should be used to set the appropriate
    ///             style-related properties of the item.
    ///
    public init (styler: @escaping ViewStyle<Self>.Styler) {
        self.init()
        let style = ViewStyle(stylers: [ (conditions: nil, styler: styler) ])
        style.apply(to: self)
    }

    /// Initialises the CALayer (or subclass) and conditionally applies the specified styler closure
    /// to the receiver if one or more of the specified conditions are true.
    ///
    /// Note: if you want to init your UIView (or subclass) with a non-zero rect or some other initialiser, this convenience init is not for you.
    ///
    /// - Parameters:
    ///   - when: One or more `Condition`s that will be evaluated prior to applying the styler closure.
    ///   - styler: An escaping closure that accepts the item to be styled as
    ///             its only parameter and should be used to set the appropriate
    ///             style-related properties of the item.
    ///
    public init (when conditions: [ViewStyle<Self>.Condition]?, styler: @escaping ViewStyle<Self>.Styler) {
        self.init()
        let style = ViewStyle(stylers: [ (conditions: conditions, styler: styler) ])
        style.apply(to: self)
    }
}
