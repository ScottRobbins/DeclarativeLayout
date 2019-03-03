
![Declarative Layout Banner](/Resources/githubBanner.png)

[![Version](https://img.shields.io/cocoapods/v/DeclarativeLayout.svg?style=flat)](http://cocoapods.org/pods/DeclarativeLayout)
[![License](https://img.shields.io/cocoapods/l/DeclarativeLayout.svg?style=flat)](http://cocoapods.org/pods/DeclarativeLayout)
[![Platform](https://img.shields.io/cocoapods/p/DeclarativeLayout.svg?style=flat)](http://cocoapods.org/pods/DeclarativeLayout)

# Declarative Layout

A declarative, expressive and efficient way to lay out your views.

---

| |Summary |
--------------------------|------------------------------------------------------------
**Declarative** | Tell the framework what the layout of your views should be and let the framework intelligently add/modify/remove constraints and views for you.
**Expressive** | Let your code visually express the hierarchy of your views.
**Flexible** | Write the same constraints you already do, using whatever autolayout constraint DSL you prefer.
**Small** | Small and readable Swift 4 codebase.

---

## Usage

Import Declarative Layout at the top of the file you would like to layout your views in

```swift
import DeclarativeLayout
```

You will define and update your layout through the `ViewLayout` object, so your first step should be creating one and storing it in a property.

Make sure that it is being initialized after your view has loaded. A place like `viewDidLoad` would work, or consider intializing the property lazily.

```swift
viewLayout = ViewLayout(view: view)
```

Tell your `ViewLayout` you would like to update it

```swift
viewLayout.updateLayoutTo { (component) in
    ...
}
```

Use the layout components to define new views that should be in the hierarchy, as well as the constraints that should be active.

Here is an example:

```swift
viewLayout.updateLayoutTo { (component) in
    component.addStackView(self.stackView) { (component) in
        component.activate([
            component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor),
            component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor),
            component.view.topAnchor.constraint(equalTo: component.superview.safeAreaLayoutGuide.topAnchor,
                                                constant: 35),
        ])
        component.view.axis = .vertical
        component.addArrangedView(self.redView) { (component) in
            component.activate([
                component.view.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        component.addSpace(20)
        component.addArrangedView(self.orangeView) { (component) in
            component.activate([
                component.view.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        component.addSpace(20)
        component.addArrangedView(self.yellowView) { (component) in
            component.activate([
                component.view.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        component.addSpace(20)
        component.addArrangedView(self.greenView) { (component) in
            component.activate([
                component.view.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        component.addSpace(20)
        component.addArrangedView(self.blueView) { (component) in
            component.activate([
                component.view.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        component.addSpace(20)
        component.addArrangedView(self.purpleView) { (component) in
            component.activate([
                component.view.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
}
```

That will give you a view looking like this:

<img src="/Resources/layout1.png" width=400 />

If you want to update to a new layout, just call the `updateLayoutTo` method
again, defining what your layout should be. The framework will take care of
adding, removing and moving views as well as activating, deactivating and
modifying constraints.

As an example, let's randomly order these views, the spacing inbetween them and
their height, re-updating the layout in this way every few seconds. The result
will look like this:

![Video animating change](/Resources/animateChange.gif)

```swift
let views = [redView,
             orangeView,
             yellowView,
             greenView,
             blueView,
             purpleView]

viewLayout.updateLayoutTo { (component) in
    component.addStackView(self.stackView) { (component) in
        component.activate([
            component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor),
            component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor),
            component.view.topAnchor.constraint(equalTo: component.superview.safeAreaLayoutGuide.topAnchor,
                                                constant: 35),
        ])
        component.view.axis = .vertical
        for view in views.shuffled() {
            component.addArrangedView(view) { (component) in
                let random = CGFloat(Int.random(in: 20..<100))
                component.activate([
                    component.view.heightAnchor.constraint(equalToConstant: random)
                ])
            }
            component.addSpace(CGFloat(Int.random(in: 0..<50)))
        }
    }
}
```

## Installation

DeclarativeLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DeclarativeLayout"
```

## Requirements

* iOS 9.0 or later
* Xcode 9 or later
* Supports Swift 4.2

## Building on top of DeclarativeLayout

Every method that adds a new layout component (ex: `addView`) will also return a
layout component. Using the component passed into the optional closure is
optional. This is done to make it easy for more opinionated layout frameworks to
be built on top of DeclarativeLayout and take advantage of its constraint and
view hierarchy diffing.

## License

DeclarativeLayout is available under the MIT license. See the LICENSE file for
more info.

