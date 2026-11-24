// Standalone entrypoint for the bundled letmeout package.
//
// Import this file directly to use letmeout without itemplate's shell:
//   #import "@preview/itemplate:1.1.0/letmeout.typ": *
//   #show: letmeout
//
// Importing the package root (`@preview/itemplate:1.1.0`) also exports
// `letmeout` and `letmeout-extras`.
#import "src/letmeout/document.typ": letmeout
#import "letmeout-extras.typ"
