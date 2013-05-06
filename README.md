VPLCLIParser is a library for parsing command-line arguments in Objective-C. Its goal is to make processing common command-line patterns easy, while still providing a way to extend those patterns when necessary.

Development is just getting started and documentation is non-existent, but things are moving fast. If you're feeling adventurous, begin with VPLCLIInterface. That class provides a high-level entry point to the code base, and is built using the lower-level command-line matching classes (`VPLCLIMatcher`, `VPLCLIGroup`, and `VPLCLIOption`).

There are also a few sample tools used to test the library during development.