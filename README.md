# Salon

Salon provides conditionally-applied, composible, and type-safe UIView styles using functions.

This framework is heavily inspired by [this post](https://medium.cobeisfresh.com/composable-type-safe-uiview-styling-with-swift-functions-8be417da947f) by [Marin Benčević](https://medium.cobeisfresh.com/@marinbenc). All credit should go to him.

## Compatibility

Salon is written and tested for Swift 4.0 and above.

## Installation

Installation is via Carthage at the moment. A CocoaPod may be published later, and you can't use Swift Package Manager with iOS apps yet so no point there.

You can also clone the repo and import it to your project manually - its not very big.

### Carthage 

Salon is [Carthage](https://github.com/Carthage/Carthage) compatible. Just add it as a dependency in your Cartfile:

```ruby
github "unsignedapps/Salon"
```

## Basic Usage

Salon is designed to try and separate how you set style-related properties on your UIView (and related) objects from your normal code.

(If you haven't read [this post](https://medium.cobeisfresh.com/composable-type-safe-uiview-styling-with-swift-functions-8be417da947f) by [Marin Benčević](https://medium.cobeisfresh.com/@marinbenc), that might be a good place to start).

Here is a basic example of it in use:

```swift
let label = UILabel()
label.apply { label in
	label.textColor = .red
	label.font = .systemFont(ofSize: 14)
}
```

Note that you can basically do anything inside your style closure, so it is really powerful - but it can also be easily abused. This framework is designed to help separate view styling code from your regular code, if you choose to abuse that the potential mess that follows is entirely your responsibility 🙂.

So we've compartmentalised the style code into its own function, but its not very separate. Fortunately it is wrapped into a `ViewStyle` struct, so you can take it anywhere:

```swift
let style = ViewStyle<UILabel> { label in
	label.textColor = .red
	label.font = .systemFont(ofSize: 14)
}

let label = UILabel()
label.apply(style: style)
```

So that means you can separate it out into its own file and maintain them separately:

**MyStyles.swift:**
```swift
extension ViewStyle {

    // Nice easy to use static var
    static var myNiceRedLabel: ViewStyle<MyNiceLabel> {
        return ViewStyle<MyNiceLabel> { label in
            label.textColor = .red
            label.font = .systemFont(ofSize: 14)
        }
	}
}
```

**MyNiceLabel.swift:**
```swift
final class MyNiceLabel: UILabel {
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.apply(style: .myNiceRedLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.apply(style: .myNiceRedLabel)
    }
}
```

### Convenience

Littering your code with `ViewStyle<MyViewClass>` references is verbose, tedious and repetitive, so Salon includes a couple of wrappers to keep your code cleaner.
	
Any `Styleable` item (i.e. `UIView` and `CALayer`) includes a `Style` typealias that references `ViewStyle<Self>`. Additionally, there is the `ViewStyle.style` static method for initialisation.
	
So this:

```swift
extension ViewStyle {
    static var myNiceRedLabel: ViewStyle<MyNiceLabel> {
        return ViewStyle<MyNiceLabel> { label in
            label.textColor = .red
            label.font = .systemFont(ofSize: 14)
        }
    }
}
```

becomes this:

```swift
extension ViewStyle {
    static var myNiceRedLabel: MyNiceLabel.Style {
        return .style { label in
            label.textColor = .red
            label.font = .systemFont(ofSize: 14)
        }
    }
}
```

## Conditional Styles

Salon also supports conditional styles - styles that you might only apply under certain circumstances. For example, when a control is selected or highlighted, or when you working on a universal app and you want to target different horizontal and vertical size classes.

```swift
let style = ViewStyle<UILabel>(when: .horizontalSizeClass(equals: .regular)) { label in
    label.textColor = .red
    label.font = .systemFont(ofSize: 14)
}

let label = UILabel()
label.apply(style: style)
```

Or more directly:

```swift
let button = UIButton()
button.apply(when: .controlState(equals: .disabled)) { button in
    button.backgroundColor = .black
}
```

(Note: Its not the intention of this framework to replace your usage of the `UIControl.setTitleColor(_:for:)` methods either - they will be updated automatically as the state changes, these styles won't.)

### Creating Conditions

A full list of the provided conditions can be found in `Conditions.swift`, but it basically covers all of the different `UITraitCollection` options, `UIControlState` and computed states for `UICollectionViewCell` and `UITableViewCell`.

You can also create your own conditions. It is just another closure that accepts the item to be styled and returns Bool whether to apply that style or not.

Here is an example of a `Condition` that matches depending on whether you installed the app on the Simulator, in a debug session on your device, via TestFlight or via the App Store. (Its not part of the framework so YMMV)

```swift
extension ViewStyle.Condition {
    static func appDeploymentMethod (equals method: UIApplication.DeploymentMethod) -> ViewStyle.Condition {
        return ViewStyle.Condition { _ in
            return UIApplication.shared.deploymentMethod == method
        }
    }
}

extension UIApplication {
    enum DeploymentMethod {
        case debug, testFlight, simulator, appStore
    }

    var deploymentMethod: DeploymentMethod {
        #if arch(i386) || arch(x86_64)
        return .simulator
        #elseif DEBUG
        return .debug
        #else
        if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
            return .testFlight
        } else {
            return .appStore
        }
        #endif
    }
}
```

## Composing Styles

The real power of Salon comes in when you start combining and composing your conditional styles:

```swift
final class MyButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.applyStyles()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.applyStyles()
    }

	// Normally you'd put your styles in a separate file
    func applyStyles () {
        self.apply(styles:

            // Our base style (`.style` is a convenience static var so you don't have to type `ViewStyle<UIButton>` repeatedly)
            .style { button in
                button.backgroundColor = .red
                button.setTitleColor(.white, for: .normal)
                button.setTitleColor(.red, for: .highlighted)
                button.setTitleColor(.darkGray, for: .disabled)
            },

            // When disabled
            .style(when: .controlState(equals: .disabled)) { button in
                button.backgroundColor = .lightGray
            },

            // When highlighted
            .style(when: .controlState(equals: .highlighted)) { button in
                button.backgroundColor = .white
            }
        )
    }

    // Mark: Overrides

    override var isEnabled: Bool {
        didSet {
            self.applyStyles()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            self.applyStyles()
        }
    }
}
```

Or when building universal apps:

```swift
extension ViewStyle {
    static var myNavigationStack: UIStackView.Style {
        return .compose(

            // Common
            .style { view in
                view.axis = .horizontal
                view.alignment = .firstBaseline
                view.distribution = .fill
                view.spacing = 36
            },

            // overrides for phone-based devices
            .style(when: .horizontalSizeClass(equals: .compact)) { view in
                view.axis = .vertical
                view.spacing = 8
            }
        )
    }
}
```

### Style Re-use

One of the objectives of Salon is to enable style re-use across your app, but with composition rather than inheritance:

```swift
extension ViewStyle {
    
    // global style that all buttons should use
    static var allButtons: UIButton.Style {
        return .style { button in
            button.layer.cornerRadius = 8
        }
    }
    
    // our form submit button should be bold
    static var submitButton: UIButton.Style {
        return .compose(
            .allButtons,
            .style { button in
                button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
            }
        )
    }
}
```

## Author

Rob Amos - [@bok_](https://twitter.com/bok_)

## License

Salon is available under the MIT license. See the LICENSE file for more info.