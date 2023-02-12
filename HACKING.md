# How to add your own mods!

Adding your own mods to Mandela is a simple process, given you know what to do. First, you want to make a new group in the Mandela/Views folder. Then, create a SwiftUI view. 

I **strongly** recommend using the included copy of the CVE-2022-46689 PoC, since adding your own versions might break things. 

You can overwrite files with the following function:
```swift
OverwriteFile(newData, /path/to/file)
```

If you need to change the value of a key in a plist, use one of the following:
```swift
plistChangeStr(plistPath: String, key: String, value: String)
plistChangeInt(plistPath: String, key: String, value: Int)
```

You can also provide an alert for showing if the tweak applied successfully or unsuccessfully with this (make sure your tweak's function returns a bool):
```swift
alertStatus(tweakName: "Your Tweak", succeeded: YourFunction())
```

Happy modding!
