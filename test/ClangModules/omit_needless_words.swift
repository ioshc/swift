// RUN: %target-swift-frontend(mock-sdk: %clang-importer-sdk) -parse -verify -Womit-needless-words -enable-infer-default-arguments %s

// REQUIRES: objc_interop

import Foundation
import AppKit

func dropDefaultedNil(array: NSArray, sel: Selector,
       body: ((AnyObject!, Int, UnsafeMutablePointer<ObjCBool>) -> Void)?) {
  array.makeObjectsPerformSelector(sel, withObject: nil) // expected-warning{{'makeObjectsPerformSelector(_:withObject:)' could be named 'makeObjectsPerform(_:object:)'}}{{9-35=makeObjectsPerform}}{{39-56=}}
  array.makeObjectsPerformSelector(sel, withObject: nil, withObject: nil) // expected-warning{{'makeObjectsPerformSelector(_:withObject:withObject:)' could be named 'makeObjectsPerform(_:object:object:)'}}{{9-35=makeObjectsPerform}}{{39-73=}}
  array.enumerateObjectsRandomlyWithBlock(nil) // expected-warning{{'enumerateObjectsRandomlyWithBlock' could be named 'enumerateObjectsRandomly(body:)'}}{{9-42=enumerateObjectsRandomly}}{{43-46=}}
  array.enumerateObjectsRandomlyWithBlock(body) // expected-warning{{'enumerateObjectsRandomlyWithBlock' could be named 'enumerateObjectsRandomly(body:)'}}{{9-42=enumerateObjectsRandomly}}{{43-43=body: }}
}

func dropDefaultedOptionSet(array: NSArray) {
  array.enumerateObjectsWithOptions([]) { obj, idx, stop in print("foo") } // expected-warning{{'enumerateObjectsWithOptions(_:usingBlock:)' could be named 'enumerateObjects(options:usingBlock:)'}}{{9-36=enumerateObjects}}{{36-40=}}
  array.enumerateObjectsWithOptions([], usingBlock: { obj, idx, stop in print("foo") }) // expected-warning{{'enumerateObjectsWithOptions(_:usingBlock:)' could be named 'enumerateObjects(options:usingBlock:)'}}{{9-36=enumerateObjects}}{{37-41=}}
  array.enumerateObjectsWhileOrderingPizza(true, withOptions: [], usingBlock: { obj, idx, stop in print("foo") }) // expected-warning{{'enumerateObjectsWhileOrderingPizza(_:withOptions:usingBlock:)' could be named 'enumerateObjectsWhileOrderingPizza(_:options:usingBlock:)'}}{{48-65=}}
}

func dropDefaultedWithoutRename(domain: String, code: Int, array: NSArray) {
  let _ = NSError(domain: domain, code: code, userInfo: nil) // expected-warning{{call to 'init(domain:code:userInfo:)' has extraneous arguments that could use defaults}}{{45-60=}}
  array.enumerateObjectsHaphazardly(nil) // expected-warning{{call to 'enumerateObjectsHaphazardly' has extraneous arguments that could use defaults}}{{37-40=}}
  array.optionallyEnumerateObjects([], usingBlock: { obj, idx, stop in print("foo") }) // expected-warning{{call to 'optionallyEnumerateObjects(_:usingBlock:)' has extraneous arguments that could use defaults}}{{36-40=}}
}

func dontDropUnnamedSetterArg(str: NSString) {
  str.setTextColor(nil) // don't drop this
}
