
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
viewLayout.updateLayoutTo { (component, view) in
    ...
}
```

Use the layout components to define new views that should be in the hierarchy, as well as the constraints that should be active.

Here is an example:

```swift
viewLayout.updateLayoutTo { (component, view) in

    component.addView(self.headerLabel) { (component, view, superview) in

        // view is the headerLabel
        // superview is the VC's view
        component.activate([
            view.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: 10),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
        ])
    }

    component.addStackView(self.stackView) { (component, view, superview) in

        component.activate([
            view.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 20),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
        ])

        component.addArrangedView(self.redBox) { (component, view, superview) in

            component.activate([
                view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            ])

            component.addView(self.blueBox) { (component, view, superview) in

                component.activate([
                    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 20),
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
                    view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -20),
                    view.heightAnchor.constraint(equalToConstant: 100)
                ])
            }
        }

        component.addArrangedView(self.greenBox) { (component, view, superview) in

            component.activate([
                view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                view.heightAnchor.constraint(equalToConstant: 300),
            ])
        }
    }
}
```

That will give you a view looking like this:

<img src="/Resources/layout1.png" width=400 />

 If you want to update to a new layout, just call the `updateLayoutTo` method again, defining what your layout should be. The framework will take care of adding, removing and moving views as well as activating, deactivating and modifying constraints.

 As an example, let's layout a view that goes from the layout above, to a new one that involves some of the same views but in different places. When animating the change it looks like:

![Video animating change](/Resources/animateChange.gif)

Imagine that `self.layoutType` was changed inbetween calls to update the layout.

```swift
viewLayout.updateLayoutTo { (component, view) in

    component.addView(self.headerLabel) { (component, view, superview) in

        // view is the headerLabel
        // superview is the VC's view
        component.activate([
            view.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: 10),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
        ])
    }

    component.addStackView(self.stackView) { (component, view, superview) in

        component.activate([
            view.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 20),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
        ])

        component.addArrangedView(self.redBox) { (component, view, superview) in

            component.activate([
                view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            ])

            if self.layoutType == .layout1 { // In layout1 the blue box will be inside of the red box
                component.addView(self.blueBox) { (component, view, superview) in

                    component.activate([
                        view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 20),
                        view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
                        view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
                        view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -20),
                        view.heightAnchor.constraint(equalToConstant: 100)
                    ])
                }
            } else {
                component.activate([
                    view.heightAnchor.constraint(equalToConstant: 200)
                ])
            }
        }

        if self.layoutType == .layout1 { // layout1 has a green box, layout 2 does not
            component.addArrangedView(self.greenBox) { (component, view, superview) in

                component.activate([
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                    view.heightAnchor.constraint(equalToConstant: 300),
                ])
            }
        }

        if self.layoutType == .layout2 { // In layout2 the blue box will be below the red box
            component.addArrangedView(self.blueBox) { (component, view, superview) in

                component.activate([
                    view.heightAnchor.constraint(equalToConstant: 100)
                ])
            }
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

## License

DeclarativeLayout is available under the MIT license. See the LICENSE file for more info.
