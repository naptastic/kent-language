# kent-language
The well-intentioned, but unintentionally carcinogenic scripting language.

In the late 1940's and '50's, the world was starting to learn that setting aflame a small pile of tar and breathing in the fumes was harmful to humans health. Tobacco companies, ever eager to do the right thing, attempted to create safer cigarettes. One such attempt was the Kent, which added a filter that cut out 80% of tar, but preserved the taste smokers wanted!

The filters were made of asbestos.

I approach the design of this language with no doubt the same honest, good intentions, and no ulterior motives... and despite my well-meaning, it will probably give everyone cancer.

# Priorities (in no particular order)
Everything matters, and there are some things you can't do later.
* Performance (concurrency, in particular) matters. It doesn't have to be fast now, but it has to be able to go fast.
* Security matters. Good crypto matters. Anti-XSS tools matter.
* Good debugging matters.
* A good toolchain matters.
* Targets matter.
* Interfaces matter.
* Libraries matter.
* Distribution of libraries matters.

# Ideas
* Multi-paradigm. Specifically, this is a functional language masquerading as an object-oriented, structured, procedural, imperative language.
* "Everything is an object."
* The compiler and AST are available and mutable* during execution.
* "Reflexive" method calls (where an object mutates itself) are done with Read-Copy-Update.
* "Non-reflexive" method calls can't mutate anything. Anything changes are copied locally and only visible deeper in the call stack.
* A few things have to be global--STDIO in particular.
* Input is asynchronous and callback-driven.
* Output... will probably be FIFO and you have to either lock or redirect output for your callees if you need safety.
