# ObjectiveC_Modernizer

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Once I started developing my skills in Objective-C, I've noticed that while many things were pretty easy to do, others could be heavily simplified. I started with a `NSUtilities` class, which later became lots of extensions splitted in `+Extension` files. At some point, I had a separated folder for extensions and classes which I would import to almost every Objective-C project that I was involved.

In order to improve that, I've decided to create a framework with those classes and extensions, in order to optimize my work. That was _ObjectiveC\_Extension_. Then I've cleaned the project, added some more functions based in modern languages, and that's how _ObjectiveC\_Modernizer_ was created.

## Compatibility
This is the best part of that framework. ObjectiveC_Modernizer is compatible with every version of macOS still compatible with Xcode 9, so it is compatible with macOS 10.6+. Obviously, that requires some workarounds and *hacks*. They will be listed in the end of the README.

## Extensions

### NSApplication

```objectivec
+(void)restart;
```

Restarts the application.

```objectivec
+(void)restartInLanguage:(nonnull NSString*)language;
```

Restarts the application in a different language (requires a valid locale identifier).

```objectivec
+(nullable VMMAppearanceName)appearance;
```

Returns the current appearance of the system. Returns null if the system version is below 10.10, or if \[NSApp appearance\] returns null.

```objectivec
+(BOOL)setAppearance:(nullable VMMAppearanceName)appearance;
```

Sets the current appearance of the system. Returns false if it fails, or if the system version is below 10.10. Returns true if the appearance is replaced properly.

### NSArray

```objectivec
-(BOOL)contains:(nonnull id)anObject;
```

Same as `containsObject:`.

```objectivec
-(BOOL)containsAll:(nonnull NSArray*)array;
```

Returns true if contains all the elements of array.

```objectivec
-(nullable ObjectType)get:(NSUInteger)index;
```

Same as `objectAtIndex:`.

```objectivec
-(nonnull NSMutableArray*)map:(_Nullable id (^_Nonnull)(id _Nonnull object))newObjectForObject;
```

Works like Javascript's array `map` function, or Java's Stream `map` function.

```objectivec
-(nonnull NSMutableArray*)mapWithIndex:(_Nullable id (^_Nonnull)(id _Nonnull object, NSUInteger index))newObjectForObject;
```

Works like Javascript's array `map` function, or Java's Stream `map` function, with `index` has the second argument.

```objectivec
-(nonnull NSMutableArray*)filter:(BOOL (^_Nonnull)(id _Nonnull object))newObjectForObject;
```

Works like Javascript's array `filter` function, or Java's Stream `filter` function.

```objectivec
-(nonnull NSMutableArray*)filterWithIndex:(BOOL (^_Nonnull)(id _Nonnull object, NSUInteger index))newObjectForObject;
```

Works like Javascript's array `filter` function, or Java's Stream `filter` function, with `index` has the second argument.

```objectivec
-(nonnull instancetype)forEach:(void (^_Nonnull)(id _Nonnull object))newObjectForObject;
```

Works like Javascript's array `forEach` function, or Java's List `forEach` function.

```objectivec
-(NSIndexSet* _Nonnull)indexesOf:(ObjectType _Nonnull)object;
```

Indexes of object inside array.

```objectivec
-(NSIndexSet* _Nonnull)indexesOf:(ObjectType _Nonnull)object inRange:(NSRange)range;
```

Indexes of object inside array, inside a specific range.

```objectivec
-(NSInteger)lastIndexOf:(ObjectType _Nonnull)object inRange:(NSRange)range;
```

Last index of object inside array, inside a specific range.

### NSAttributedString

```objectivec
-(instancetype)initWithHTMLData:(NSData*)data;
```

Init a `NSAttributedString` using a `NSData` with a HTML page inside.

```objectivec
-(instancetype)initWithHTMLString:(NSString*)string;
```

Init a `NSAttributedString` using a `NSString` with a HTML page.

```objectivec
-(NSString*)htmlString;
```

Returns an HTML page with the text and formatting of the `NSAttributedString` object.

### NSBundle

```objectivec
-(nonnull NSUserDefaults*)userDefaults;
```

Returns the user defaults for the bundle.

```objectivec
-(nonnull NSString*)bundleName;
```

Returns the name of the bundle. It returns the first non-nil value from those: CFBundleDisplayName from Info.plist, CFBundleName from Info.plist, `getprogname()`, the bundle path last component with no extension, `@"App"`.

```objectivec
-(nullable NSImage*)bundleIcon;
```

Returns the icon of the bundle.

```objectivec
-(BOOL)isAppTranslocationActive;
```

Checks if the app is being executed in App Translocation.

```objectivec
-(BOOL)disableAppTranslocation;
```

Disable App Translocation in the app at the bundle path. Is only useful if that bundle was returned by the method `realMainBundle`, or if you are trying to disable app translocation for another app.

```objectivec
+(nullable NSBundle*)realMainBundle;
```

Returns the `NSBundle` of the original bundle, not App Translocated, in case the app is App Translocated. If the app isn't App Translocated, it returns the `mainBundle`. If your macOS version is 10.15 or superior, that method won't work if the app is translocated, raising an exception.

### NSColor

```objectivec
RGBA(r,g,b,a)
```

Init a `NSColor` object with the specific levels of red, green, blue and alpha, from 0.0 to 255.0. Equivalent to `colorWithDeviceRed:green:blue:alpha:`, but with a much smaller size.

```objectivec
RGB(r,g,b)
```

Init a `NSColor` object with the specific levels of red, green and blue, from 0.0 to 255.0. Equivalent to `RGBA(r,g,b,255.0)`.

```objectivec
+(NSColor*)colorWithHexColorString:(NSString*)inColorString;
```

Init a `NSColor` object with the color specified by a RGB hex string. Example: "000000" returns the black color.

```objectivec
-(NSString*)hexColorString;
```

Returns a RGB hex string of the `NSColor` object. Example: The black color returns "000000".

### NSData

```objectivec
+(nullable NSData*)safeDataWithContentsOfFile:(nonnull NSString*)filePath;
```

Init a `NSData` with the contents of the file at the specified path. Equivalent to `alloc` + `initWithContentsOfFile:options:error:`, but automatically raises an exception in case any error happens, making your code cleaner and not ignoring errors.

```objectivec
-(nonnull NSString*)base64EncodedString;
```

Return the bytes of the data encoded as base64.

### NSDateFormatter

```objectivec
+(NSDate*)dateFromString:(NSString *)string withFormat:(NSString*)format;
```

Returns a `NSDate` object with the date specified in the string, which has the specified date format.

### NSFileManager

```objectivec
-(BOOL)createSymbolicLinkAtPath:(nonnull NSString *)path withDestinationPath:(nonnull NSString *)destPath;
```

Equivalent to `createSymbolicLinkAtPath:withDestinationPath:error:`, but automatically raises with any produced errors.

```objectivec
-(BOOL)createDirectoryAtPath:(nonnull NSString*)path withIntermediateDirectories:(BOOL)interDirs;
```

Equivalent to `createDirectoryAtPath:withIntermediateDirectories:attributes:error:`, but automatically raises any produced errors and uses no attributes.

```objectivec
-(BOOL)createEmptyFileAtPath:(nonnull NSString*)path;
```

Equivalent to `createFileAtPath:contents:attributes:`, but with no contents and no attributes.

```objectivec
-(BOOL)moveItemAtPath:(nonnull NSString*)path toPath:(nonnull NSString*)destination;
```

Equivalent to `moveItemAtPath:toPath:error:`, but automatically raises any produced errors.

```objectivec
-(BOOL)copyItemAtPath:(nonnull NSString*)path toPath:(nonnull NSString*)destination;
```

Equivalent to `copyItemAtPath:toPath:error:`, but automatically raises any produced errors.

```objectivec
-(BOOL)removeItemAtPath:(nonnull NSString*)path;
```

Equivalent to `removeItemAtPath:error:`, but automatically raises any produced errors.

```objectivec
-(BOOL)directoryExistsAtPath:(nonnull NSString*)path;
```

Equivalent to `fileExistsAtPath:isDirectory:`, but only returns true if the given path is a directory.

```objectivec
-(BOOL)regularFileExistsAtPath:(nonnull NSString*)path;
```

Equivalent to `fileExistsAtPath:isDirectory:`, but only returns true if the given path is not a directory.

```objectivec
-(nullable NSArray<NSString*>*)contentsOfDirectoryAtPath:(nonnull NSString*)path;
```

Equivalent to `contentsOfDirectoryAtPath:error:`, but automatically raises any produced errors.

```objectivec
-(nullable NSString*)destinationOfSymbolicLinkAtPath:(nonnull NSString *)path;
```

Equivalent to `destinationOfSymbolicLinkAtPath:error:`, but automatically raises any produced errors.

```objectivec
-(unsigned long long int)sizeOfRegularFileAtPath:(nonnull NSString*)path;
```

Returns the size of the file at the given path according to the value of `NSFileSize` in the dictionary returned by `attributesOfItemAtPath:error:`.

```objectivec
-(unsigned long long int)sizeOfDirectoryAtPath:(nonnull NSString*)path;
```

Returns the size of a directory by summing the size of regular files in subpaths inside the directory. Takes a longer time to run, but is much more precise.

```objectivec
-(nullable NSString*)checksum:(NSChecksumType)checksum ofFileAtPath:(nonnull NSString*)file;
```

Returns the checksum of the specified file. There are 14 possible cryptographies for `checksum`, including sha1, sha256, md5, etc.

### NSImage

```objectivec
+(NSImage*)imageWithData:(NSData*)data;
```

Init a `NSImage` with the contents of the `NSData` object.

```objectivec
+(NSImage*)quickLookImageFromFileAtPath:(NSString*)arquivo withMaximumSize:(int)size;
```

Init a `NSImage` with the QuickLook image of the file at the specified path with the specified size (or smaller).

```objectivec
+(NSImage*)quickLookImageFromFileAtPath:(NSString*)arquivo;
```

Init a `NSImage` with the contents of the image file at the specified path.

```objectivec
+(NSImage*)emptyImageWithSize:(NSSize)size;
```

Init a `NSImage` of an empty image with the specified size.

```objectivec
-(BOOL)writeToFile:(NSString*)file atomically:(BOOL)useAuxiliaryFile;
```

Write the existing `NSImage` at the specified path in the format specified by the extension of the last component of the given path. Compatible extensions are **icns**, **bmp**, **gif**, **jpg**, **jp2**, **png** and **tiff**.

Changes the color of an existing `NSMenu` to the dark color of the Dock right-click menu.

### NSMenuItem

```objectivec
+(NSMenuItem*)menuItemWithTitle:(NSString*)title andAction:(SEL)action forTarget:(id)target;
```

Equivalent to `alloc` + `initWithTitle:action:keyEquivalent:` + `setTarget:`, with key equivalent equals to `@""`. Used to make the code cleaner.

### NSMutableArray

```objectivec
-(void)add:(nonnull id)anObject;
```

Same as `addObject:`.

```objectivec
-(void)add:(nonnull id)anObject atIndex:(NSUInteger)index;
```

Same as `insertObject:atIndex:`.

```objectivec
-(void)addAll:(nonnull NSArray *)otherArray;
```

Same as `addObjectsFromArray:`.

```objectivec
-(void)clear;
```

Same as `removeAllObjects`.

```objectivec
-(nonnull NSMutableArray*)map:(_Nullable id (^_Nonnull)(id _Nonnull object))newObjectForObject;
```

Works like Javascript's array `map` function, or Java's Stream `map` function.

```objectivec
-(nonnull NSMutableArray*)mapWithIndex:(_Nullable id (^_Nonnull)(id _Nonnull object, NSUInteger index))newObjectForObject;
```

Works like Javascript's array `map` function, or Java's Stream `map` function, with `index` has the second argument.

```objectivec
-(nonnull NSMutableArray*)filter:(BOOL (^_Nonnull)(id _Nonnull object))newObjectForObject;
```

Works like Javascript's array `filter` function, or Java's Stream `filter` function.

```objectivec
-(nonnull NSMutableArray*)filterWithIndex:(BOOL (^_Nonnull)(id _Nonnull object, NSUInteger index))newObjectForObject;
```

Works like Javascript's array `filter` function, or Java's Stream `filter` function, with `index` has the second argument.

```objectivec
-(void)removeAll:(nonnull NSArray*)array;
```

Same as `removeObjectsInArray:`.

```objectivec
-(void)sortBySelector:(SEL _Nonnull)selector usingComparator:(NSInteger (^_Nonnull)(id _Nonnull object1, id _Nonnull object2))comparator;
```

Sort array using comparator by selector.

### NSMutableString

```objectivec
-(void)replace:(nonnull NSString *)target with:(nonnull NSString *)replacement;
```

Replace occurences of string with another string.

```objectivec
-(void)replaceRegex:(nonnull NSString *)target with:(nonnull NSString *)replacement;
```

Replace occurences of regex with string.

```objectivec
-(nonnull NSMutableString*)trim;
```

Trims the mutable string.


## New Classes (misc)

### VMMAlert

```objectivec
-(NSUInteger)runThreadSafeModal;
```

Equivalent to `runModal`, but always runs `VMMAlert` in the main thread, avoiding concurrency problems.

```objectivec
+(NSUInteger)runThreadSafeModalWithAlert:(VMMAlert* (^)(void))alert;
```

Lets you declared a `VMMAlert` inside a block (which will run in the main thread) and returns its value. Equivalent to `runThreadSafeModal`, but lets you declare objects needed by your `VMMAlert` in the main thread as well, avoiding concurrency problems.

```objectivec
+(void)showAlertMessageWithException:(NSException*)exception;
```

Creates an "Ok alert" with the useful information of a `NSException`. Very useful to reduce the size of `catch`es in try/catch. That alert uses the thread safe modal.

```objectivec
+(void)showAlertOfType:(VMMAlertType)alertType withMessage:(NSString*)message;
```

Creates an "Ok alert" with the specified message, with a title and an icon defined by the `alertType` (Sucess, Warning, Error, Critical and Custom). That alert uses the thread safe modal.

```objectivec
+(void)showAlertMessage:(NSString*)message withTitle:(NSString*)title withSettings:(void (^)(VMMAlert* alert))optionsForAlert;
```

Creates an "Ok alert" with the specified message and title, and lets you do anything with the alert in the block before running its modal. That alert uses the thread safe modal.

```objectivec
+(void)showAlertAttributedMessage:(NSAttributedString*)message withTitle:(NSString*)title withSubtitle:(NSString*)subtitle;
```

Creates an "Ok alert" with the specified title, subtitle and message, where the message is an attributed string. That alert uses the thread safe modal.

```objectivec
+(BOOL)showBooleanAlertMessage:(NSString*)message withTitle:(NSString*)title withDefault:(BOOL)yesDefault;
```

Creates an "Yes/No alert" with the specified title, message and default value (which will be the selectable key by pressing Return). That alert uses the thread safe modal.

```objectivec
+(BOOL)showBooleanAlertOfType:(VMMAlertType)alertType withMessage:(NSString*)message withDefault:(BOOL)yesDefault;
```

Creates an "Yes/No alert" with the specified message and default value (which will be the selectable key by pressing Return), with a title and an icon defined by the `alertType` (Sucess, Warning, Error, Critical and Custom). That alert uses the thread safe modal.

```objectivec
+(BOOL)showBooleanAlertMessage:(NSString*)message withTitle:(NSString*)title withDefault:(BOOL)yesDefault withSettings:(void (^)(VMMAlert* alert))setAlertSettings;
```

Creates an "Yes/No alert" with the specified title, message and default value (which will be the selectable key by pressing Return), and lets you do anything with the alert in the block before running its modal. That alert uses the thread safe modal.

```objectivec
+(BOOL)confirmationDialogWithTitle:(NSString*)prompt message:(NSString*)message withSettings:(void (^)(VMMAlert* alert))setAlertSettings;
```

Creates an "Ok/Cancel alert" with the specified title and message, and lets you do anything with the alert in the block before running its modal. That alert uses the thread safe modal.

```objectivec
+(NSString*)inputDialogWithTitle:(NSString*)prompt message:(NSString*)message defaultValue:(NSString*)defaultValue;
```

Creates an "Ok/Cancel input alert" with the specified title, message and default value (which will be the initial value of the text input field of the alert). Any input provided in the field will be returned by the function. That alert uses the thread safe modal.

```objectivec
+(NSString*)showAlertWithButtonOptions:(NSArray*)options withTitle:(NSString*)title withText:(NSString*)text withIconForEachOption:(NSImage* (^)(NSString* option))iconForOption;
```

Creates an "Multiple buttons alert" with the specified title, message and options (which will become squared buttons with the icon specified in the block). The selected option will be returned by the function. That alert uses the thread safe modal.

### VMMComputerInformation
Used to retrieve informations about the computer hardware and software.

```objectivec
+(long long int)hardDiskSize;
```

Hard disk size in bytes. Requires non-sandboxed application.

```objectivec
+(long long int)hardDiskFreeSize;
```

Hard disk free size (available space) in bytes. Requires non-sandboxed application.

```objectivec
+(long long int)hardDiskUsedSize;
```

Hard disk used size (non-available space) in bytes. Requires non-sandboxed application.

```objectivec
+(long long int)ramMemorySize;
```

RAM memory size in bytes.

```objectivec
+(long long int)ramMemoryFreeSize
```

RAM memory free size (available space) in bytes. Requires non-sandboxed application.

```objectivec
+(long long int)ramMemoryUsedSize
```

RAM memory used size (non-available space) in bytes. Requires non-sandboxed application.

```objectivec
+(nullable NSString*)processorNameAndSpeed;
```

Processor name and speed. Requires non-sandboxed application.

```objectivec
+(double)processorUsage;
```

Processor usage percentage (from 0.0 to 1.0). Requires non-sandboxed application.

```objectivec
+(nullable NSString*)macModel;
```

Mac model. Requires non-sandboxed application.

```objectivec
+(NSString*)macOsVersion;
```

macOS version. Example: "10.13". Requires non-sandboxed application.

```objectivec
+(nullable NSString*)completeMacOsVersion;
```

macOS complete version. Example: "10.13.1". Requires non-sandboxed application.

```objectivec
+(NSString*)macOsBuildVersion;
```

macOS build version. Example: "17C60c". Requires non-sandboxed application.

```objectivec
+(BOOL)isSystemMacOsEqualOrSuperiorTo:(NSString*)version;
```

True if the user macOS version is equal or superior to the specified version. Requires non-sandboxed application.

```objectivec
IS_SYSTEM_MAC_OS_10_7_OR_SUPERIOR
IS_SYSTEM_MAC_OS_10_8_OR_SUPERIOR
IS_SYSTEM_MAC_OS_10_9_OR_SUPERIOR
IS_SYSTEM_MAC_OS_10_10_OR_SUPERIOR
IS_SYSTEM_MAC_OS_10_11_OR_SUPERIOR
IS_SYSTEM_MAC_OS_10_12_OR_SUPERIOR
IS_SYSTEM_MAC_OS_10_13_OR_SUPERIOR
```

Defines that use `isSystemMacOsEqualOrSuperiorTo:`. Requires non-sandboxed application.

```objectivec
+(BOOL)isUserMemberOfUserGroup:(VMMUserGroup)userGroup;
```

True if the user is member of a specific user group in his computer.

```objectivec
+(NSArray<VMMVideoCard*>* _Nonnull)videoCards;
```

List of the computer video cards. Possibly requires non-sandboxed application.

```objectivec
+(VMMVideoCard* _Nullable)bestVideoCard;
```

Most powerful video card of the computer. Possibly requires non-sandboxed application.

### VMMJSON

```objectivec
+(nullable NSString*)serializeToString:(nonnull id)object;
```

Returns the contents of a JSON file based in an object (which may be a NSString, a NSArray, a NSDictionary or a NSNumber).

```objectivec
+(nullable NSData*)serializeToData:(nonnull id)object;
```

Returns a `NSData` with the contents of a JSON file based in an object (which may be a NSString, a NSArray, a NSDictionary or a NSNumber).

```objectivec
+(nullable id)deserializeFromData:(nonnull NSData*)data;
```

Returns an object based in the `NSData` object, which is the contents of a JSON file.

### VMMVideoCard
Model that stores information about a specific video card.

```objectivec
-(nonnull NSDictionary*)dictionary;
```

Dictionary with the informations about the video card.

```objectivec
-(nullable NSString*)name;
```

Name (model) of the video card.

```objectivec
-(nullable NSString*)type;
```

Type of the video card (Intel HD, Intel Iris, Intel Iris Pro, Intel Iris Plus, Intel GMA, NVIDIA or ATI/AMD).

```objectivec
-(nullable NSString*)bus;
```

Bus of the video card (Built-In, PCI or PCIe).

```objectivec
-(nullable NSString*)deviceID;
```

Device ID of the video card.

```objectivec
-(nullable NSString*)vendorID;
```

Vendor ID of the video card.

```objectivec
-(nullable NSString*)vendor;
```

Vendor of the video card (NVIDIA, ATI/AMD, Intel, etc).

```objectivec
-(nullable NSNumber*)memorySizeInMegabytes;
```

Memory size of the video card.

```objectivec
-(BOOL)supportsMetal;
```

Returns true if the video card supports Metal.

```objectivec
-(VMMMetalFeatureSet)metalFeatureSet;
```

Returns the MTLFeatureSet value of the video card, without using the Metal framework. Although, the returned values are equivalent to their MTLFeatureSet counterparts.

```objectivec
-(nonnull NSString*)descriptorName;
```

Identifier of the video card. It contains the model, type, vendor or vendor ID (depending of which ones is available) and the memory size, if available.

```objectivec
-(BOOL)isReal;
```

Returns true if the video card vendor is Intel, ATI/AMD or NVIDIA.

```objectivec
-(BOOL)isComplete;
```
Returns true if it was possible to retrieve the most relevant informations about the video card (name, device ID and memory size).

```objectivec
-(BOOL)isVirtualMachineVideoCard;
```
Returns true if the video card is a mock created by a virtual machine, like VirtualBox, VMware, Parallels Desktop or Qemu.

### VMMParentalControls
Used to check if there is any Parental Control restrictions to the actual user.

```objectivec
+(BOOL)isEnabled;
```

Check if Parental Controls are enabled for the actual users.

```objectivec
+(BOOL)iTunesMatureGamesAllowed;
```

Return `true` if the user is allowed to play mature rated games.

```objectivec
+(VMMParentalControlsItunesGamesAgeRestriction)iTunesAgeRestrictionForGames;
```

Return the user age restriction for games (None, 4+, 9+, 12+ or 17+).

```objectivec
+(BOOL)isAppRestrictionEnabled;
```

Return `true` if the user is restricted to use only specific apps.

```objectivec
+(BOOL)isAppUseRestricted:(NSString*)appPath;
```

Return `false` if the user is allowed to use the app at the specified path.

```objectivec
+(BOOL)isInternetUseRestricted;
```

Return `true` if the user internet access is restricted in some way.

```objectivec
+(BOOL)isWebsiteAllowed:(NSString*)websiteAddress;
```

Return `true` if the user can access a specific web address.


### VMMUserNotificationCenter
Replacement for `NSUserNotificationCenter`, which uses `NSUserNotificationCenter` if available, but still shows the message in macOS 10.6 and 10.7.

```objectivec
+(nonnull instancetype)defaultUserNotificationCenter;
```

Shared instance of `VMMUserNotificationCenter`.

```objectivec
@property (nonatomic, nullable) id<VMMUserNotificationCenterDelegate> delegate;
```

Delegate of the `VMMUserNotificationCenter` instance.

```objectivec
+(BOOL)isGrowlEnabled;
```

Checks if the use of Growl to send notifications is enabled or not. Growl is enabled by default only if the macOS version is 10.7- and Growl is available.

```objectivec
+(void)setGrowlEnabled:(BOOL)enabled;
```

Force `VMMUserNotificationCenter` to use Growl. That may result in an error if Growl is unavailable.

```objectivec
+(BOOL)isGrowlAvailable;
```

Check if Growl is installed in the user machine.

```objectivec
-(BOOL)deliverGrowlNotificationWithTitle:(nullable NSString*)title message:(nullable NSString*)message icon:(nullable NSImage*)icon;
```

Sends Growl notification with a specific title, message and icon. An icon can only be used in macOS 10.6. The function returns `true` if the notification was shown succesfully.

```objectivec
-(void)deliverNotificationWithTitle:(nullable NSString*)title message:(nullable NSString*)message userInfo:(nullable NSObject*)info icon:(nullable NSImage*)icon actionButtonText:(nullable NSString*)actionButton;
```

Sends a notification with a specific title, message and icon, with an user information and a title for the action button. It sends a Growl notification only if it's enabled. If it's disabled, a `NSUserNotificationCenter`  notification if it's available; otherwise, it shows a regular `NSAlert` with the message. That function warranties that the user will receive the message.

#### VMMUserNotificationCenterDelegate (Protocol)
Protocol for `VMMUserNotificationCenter`  delegate.

```objectivec
-(void)actionButtonPressedForNotificationWithUserInfo:(nullable NSObject*)userInfo;
```

If `NSUserNotificationCenter` or `NSAlert` is used, that function is called when the action button is pressed, and the user information is provided.

### VMMLogUtility

```objectivec
NSDebugLog(NSString *format, ...)
```

In Debug, prints a log like `NSLog`, but it doesn't have the `NSLog` prefix, and also prints the log to a `debug.log` file in your Desktop. In Release, does nothing.

```objectivec
NSStackTraceLog()
```

Prints the stacktrace log like in `[NSThread callStackSymbols]`, but using `NSDebugLog`.

```objectivec
measureTime(__message){}
```

Based in `LOOProfiling.h`'s `LOO_MEASURE_TIME` (https://gist.github.com/sfider/3072143). Measure the time that its block takes to run and print it using `NSDebugLog`.

## Workarounds and Hacks

### - [(NSOpenPanel*)panel setWindowTitle:title] (macOS >= 10.11)
From macOS 10.11 and on, the `setTitle:` function does nothing to `NSOpenPanel`'s. Considering that, this function uses `setMessage:` for macOS 10.11+ and `setTitle:` for macOS 10.10-.

### - [(VMMUserNotificationCenter*)notificationCenter deliverNotificationWithTitle:title message:message userInfo:info icon:icon actionButtonText:actionButton] (macOS <= 10.7)
Since `NSUserNotification` was only introduced in macOS 10.8, macOS 10.7 and below require a different approach. In those systems, `VMMUserNotificationCenter` uses Growl instead, if it can found. If it don't, it shows a simple `NSAlert` instead of a notification. So you still have notifications in macOS 10.6 and 10.7, but only if you have Growl. Considering that, that function has two ratings.

### - [(NSString*)string findAll:regex] (macOS = 10.6)
This is the dirtiest hack of them all. Since `NSRegularExpression` was introduced in macOS 10.7, the only method that I found to do that (since the `RegexKit` framework do not compile anymore) is using Python. In macOS 10.6 only, that function will create a temporary file with `string` and a temporary python script which should parse `string` and return the components matching with `regex`. It's very slow in comparison to `NSRegularExpression`, and should not be used multiple times in sequence (however, it can be used simultaneously in the latest versions), but at least it works using the same kind of regex of `NSRegularExpression` ... please, forgive me.

