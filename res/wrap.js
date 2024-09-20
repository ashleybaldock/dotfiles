/**
   *

let update = (objWrapper, newvalue) => objWrapper.valueOf = objWrapper.toSource = objWrapper.toString = () => newvalue
o = {get a() {return this._a}, set a(to) {this._a ? update(this._a, to) : this._a = Object(a)}}


ooo = {_a: Object(undefined), get a() {return this._a}, set a(to) {this._a =  updateOrWrap(this._a, to)}}



 updateOrWrap = (obj, val) => obj === undefined ? Object(val) : (obj.valueOf = obj.toSource = obj.toString = () => val) && obj
oooo = {_a: Object(undefined), get a() {return this._a}, set a(to) {this._a =  updateOrWrap(this._a, to)}}


let l = Object('meh')
l.__proto__
oooo.a.toSource()
oooo.a.toString()
oooo.a.valueOf()
l.toString = l.toSource = l.getValue = () => 'bleh'

*/
