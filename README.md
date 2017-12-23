# DeclarativeLayout

[![Version](https://img.shields.io/cocoapods/v/DeclarativeLayout.svg?style=flat)](http://cocoapods.org/pods/DeclarativeLayout)
[![License](https://img.shields.io/cocoapods/l/DeclarativeLayout.svg?style=flat)](http://cocoapods.org/pods/DeclarativeLayout)
[![Platform](https://img.shields.io/cocoapods/p/DeclarativeLayout.svg?style=flat)](http://cocoapods.org/pods/DeclarativeLayout)

This library is a wrapper around UIKit/Autolayout that allows you to declaratively define the layout of your views. Redefine the layout of your views and the library will handle adding/removing subviews as well as activating and deactivating constraints as needed. 

---

## Usage

### Quick Start 

##### Initialize your `ViewLayout` 

You can do this in `viewDidLoad`, `awakeFromNib`, or anywhere that the view has been loaded 

```swift
viewLayout = ViewLayout(view: view)
```

##### Tell the `ViewLayout` you would like to update it

```swift
viewLayout.updateLayoutTo { (component) in 
	...
}
```

##### Add subviews to your layout and constrain

`layout` is of type `UIViewLayoutComponent`. There are a few important properties and methods to know about:
* `view: UIView`
    * Access the view for that layout. 
* `public func addView(_ subview: UIView, layoutClosure: ((UIViewSubviewLayoutComponent) -> Void)?)`
    * This is where you will define that you would like the view passed in added as a subview
* `public func addStackView(_ stackview: UIStackView, layoutClosure: ((UIStackViewSubviewLayoutComponent) -> Void)?)`
    * Similarly to the `add` method, here you can specifically add a `UIStackView`. This will allow you to add arranged subviews in the closure.
* `public func activate(_ constraints: @escaping @autoclosure () -> [NSLayoutConstraint])`
    * Here you can add all of your constraints as an array for that view. This will also activate the constraints. Make sure not to activate the constraints yourself, as if the views are not addded to the view hierarchy yet, which is managed by the `ViewLayout`, your app will crash.

There are a couple specialized forms of `UIViewLayoutComponent`, including a `UISubviewLayoutComponent`, which will add a property to access the `superView`, a `UIStackViewSubviewLayoutComponent`, which will add an `addArrangedView` method.

Here's an example of everything together. 

```swift
viewLayout.updateLayoutTo { (component) in
    
    component.addView(self.headerLabel) { (component) in
        
        // component.view is the headerLabel
        // component.superview is the VC's view
        component.activate([
            component.view.topAnchor.constraint(equalTo: component.superview.topAnchor, constant: 75),
            component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
            component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
        ])
    }
    
    component.addStackView(self.stackView) { (component) in
        
        component.activate([
            component.view.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 20),
            component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
            component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
        ])
        
        component.addArrangedView(self.redBox) { (component) in
            
            component.activate([
                component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor),
                component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor),
            ])
            
            component.addView(self.blueBox) { (component) in
                
                component.activate([
                    component.view.topAnchor.constraint(equalTo: component.superview.topAnchor, constant: 20),
                    component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                    component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
                    component.view.bottomAnchor.constraint(equalTo: component.superview.bottomAnchor, constant: -20),
                    component.view.heightAnchor.constraint(equalToConstant: 100)
                ])
            }
        }
        
        component.addArrangedView(self.greenBox) { (component) in
            
            component.activate([
                component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor),
                component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor),
                component.view.heightAnchor.constraint(equalToConstant: 300),
            ])
        }
    }
}
```

That will give you a view looking like this:  

<img src="/Resources/layout1.png" width=400 />

### Updating layouts 

 If you want to update to a new layout, just call the `updateLayoutTo` method again, defining what your layout should be. The framework will take care of adding, removing and moving views as well as activating, deactivating and changing constraints. 

 As an example, let's layout a view that goes from the layout above, to a new one that involves some of these things. When animating the change it looks like:

![Video animating change](/Resources/animateChange.gif)

```swift
viewLayout.updateLayoutTo { (component) in
    
    component.addView(self.headerLabel) { (component) in
        
        // component.view is the headerLabel
        // component.superview is the VC's view
        component.activate([
            component.view.topAnchor.constraint(equalTo: component.superview.topAnchor, constant: 75),
            component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
            component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
        ])
    }
    
    component.addStackView(self.stackView) { (component) in
        
        component.activate([
            component.view.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 20),
            component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
            component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
        ])
        
        component.addArrangedView(self.redBox) { (component) in
            
            component.activate([
                component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor),
                component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor),
            ])
            
            if self.layoutType == .layout1 { // In layout1 the blue box will be inside of the red box
                component.addView(self.blueBox) { (component) in
                    
                    component.activate([
                        component.view.topAnchor.constraint(equalTo: component.superview.topAnchor, constant: 20),
                        component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                        component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
                        component.view.bottomAnchor.constraint(equalTo: component.superview.bottomAnchor, constant: -20),
                        component.view.heightAnchor.constraint(equalToConstant: 100)
                    ])
                }
            } else {
                component.activate([
                    component.view.heightAnchor.constraint(equalToConstant: 200)
                ])
            }
        }
        
        if self.layoutType == .layout1 { // layout1 has a green box, layout 2 does not
            component.addArrangedView(self.greenBox) { (component) in
                
                component.activate([
                    component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor),
                    component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor),
                    component.view.heightAnchor.constraint(equalToConstant: 300),
                ])
            }
        }
        
        if self.layoutType == .layout2 { // In layout2 the blue box will be below the red box
            component.addArrangedView(self.blueBox) { (component) in
                
                component.activate([
                    component.view.heightAnchor.constraint(equalToConstant: 100)
                ])
            }
        }
    }
}
```

## Requirements

* iOS 9.0 or later 
* Xcode 8 or later 

## Installation

DeclarativeLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DeclarativeLayout"
```

## License

DeclarativeLayout is available under the MIT license. See the LICENSE file for more info.
