image-search-exploration
========================

Exploring infinite scrolling on iOS using Google's depracated image API that allows you to load 8 images at a time.

Uses cocoapods, so open the workspace, not the project.

Some notes / todo's:

* The collection view doesn't really handle broken images well. To fix this, images would need to be pre-loaded or broken images would need to be swapped out on the fly with upcoming data.
* New pages are instructed to be fetched when very close to the end of all loaded data to show off continuous loading. Otherwise we'd run out of the 64 images Google's API will provide us immediately.
* To be a full fledged infinite scroller, memory should be managed (e.g. previous images thrown out of memory by persisting to disc)
