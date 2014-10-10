---
layout: default
sel: blog
title: Java Clipboards and Data Transfer
---
(Ported from betaveros.stash. Wow, I get syntax highlighting and footnotes!)

A quick brief guide. At least, that's how I planned it.

A lot of stuff is in the package `java.awt.datatransfer`. Class `Toolkit` is in `java.awt`.

Some basic classes. The class `Clipboard` is a clipboard, obviously. Its content is/will be an instance of the class `Transferable`. Some content can be read as different types of objects depending on what you want; to choose which type you use an instance of `DataFlavor`. It provides three basic ones: `DataFlavor.imageFlavor`, `DataFlavor.javaFileListFlavor`, and `DataFlavor.stringFlavor`.

Okay, now step by step. This is the low-level method.

1. Get the default clipboard with `Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();`
2. Get a transferable with `Transferable content = clipboard.getContents(null);` [^1]
3. Check if `content` can be read as the kind of object you want with `(content != null) && content.isDataFlavorSupported(someFlavor)`
4. If it does, get the object with `content.getTransferData(someFlavor)` [^2].

For designing a Swing component, however, there are more integrated ways. This also allows drag-and-drop as well as cut-copy-paste, the conventional UI ideas. For many components (ex. `JTextField`) the mechanisms are pretty much in place, and you can call `setDragEnabled(true)` on them and be done. Further customizations are possible, particularly for complex things `JList, JTable, JTree`; I'll just skip them today. The first thing is defining/subclassing a `TransferHandler`, which will be asked to handle all of this stuff by Swing internals:

{% highlight java %}
class SomeTransferHandler extends TransferHandler {
    // Export actions: drag, cut/copy, callback
    int getSourceActions(JComponent c) {
        return COPY_OR_MOVE;
        // choose from COPY, MOVE, COPY_OR_MOVE, LINK, NONE
    }
    Transferable createTransferable(JComponent c) { /* ... */ }
    void exportDone(JComponent c, Transferable t, int action) { /* ... */ }

    // Import actions: drop, paste
    public boolean canImport(TransferSupport supp) { /* ... */ }
    public boolean importData(TransferSupport supp) { /* ... */ }
}
{% endhighlight %}

Note that you do not have to define all of the methods, only the ones you need. `TransferHandler` is not abstract, although directly instantiating one is probably not a good idea.

[`TransferHandler.TransferSupport`](http://docs.oracle.com/javase/6/docs/api/javax/swing/TransferHandler.TransferSupport.html) is[^3] a wrapper around `Transferable` containing also where the transfer is coming from and of what type it is. The transferable is extracted with `getTransferable()`, but the wrapper also directly has data-flavor compatibility checking methods[^4]. Go look its methods up.

Okay, now that you have a handler set up, how do you get it used? `someJComponent.setTransferHandler(someTransferHandler)` will allow the handler to handle the transfer events. For cc&p, you can get corresponding `Action`s from `TransferHandler.get[Cut|Copy|Paste]Action()` (yes, static method).

---

[^1]: The argument is a handler of type `ClipboardOwner` which needs one method `lostOwnership(Clipboard c, Transferable t)` that is called when the clipboard no longer contains your content. I guess you use it to free resources? I don't need it though.

[^2]: It throws checked exceptions `UnsupportedFlavorException` and `IOException`. My former self would hope that you have an IDE that would tell you that and salutes you if you don't. Now, I just think whatever, if you're writing Scala like me then you don't even care.

[^3]: At least I think of it as one, but I don't know if everybody's definition of "wrapper" matches mine. Oh well.

[^4]: `isDataFlavorSupported(DataFlavor)` and `getDataFlavors()`; the latter returns an array. The documentation says these are faster than extracting the `Transferable` and querying it.
