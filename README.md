# Godot Table Container

A Godot plugin that provides a container type that serves as a table.
I wrote this because the current options for tabular data were insufficient for my use cases.

`GridContainer` was close, but the fact that all the elements must be children of the container created some limitations.
First, there is no concept of discrete rows, so it was awkward to add sets of nodes as a row to it.
Second, because of the above, while I was able to instantiate a row scene and then reparent the children to it, the row itself, with any scripting I might have, would be lost.

Combining `VBoxContainer` and `HBoxContainer` is effectively what I do here, but the initial limitation is that the columns do not stay in alignment.
That's basically what this does.

## Features

* Keeps columns (i.e. `Control` nodes within each `HBoxContainer`) in alignment
* Has optional auto-update in the game and in the editor
* Has property to seet horizontal and vertical spacing overrides to the entire table

## Limitations

Anything that's not listed above.
Rows must be the same length.

## Development

I'm planning to put this to use in another project, and as I see the need, I may extend this.
It's primarily for my own use, but since I didn't see anything quite like it out there and I've seen it asked about, I figured I'd share!
