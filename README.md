# madlib-storage-simple
[![Build Status](https://travis-ci.org/Qwerios/madlib-storage-simple.svg?branch=master)](https://travis-ci.org/Qwerios/madlib-storage-simple) [![NPM version](https://badge.fury.io/js/madlib-storage-simple.png)](http://badge.fury.io/js/madlib-storage-simple) [![Built with Grunt](https://cdn.gruntjs.com/builtwith.png)](http://gruntjs.com/)

[![Npm Downloads](https://nodei.co/npm/madlib-storage-simple.png?downloads=true&stars=true)](https://nodei.co/npm/madlib-storage-simple.png?downloads=true&stars=true)

A wrapper for localstorage that also works on titanium and nodejs


## acknowledgments
The Marviq Application Development library (aka madlib) was developed by me when I was working at Marviq. They were cool enough to let me publish it using my personal github account instead of the company account. We decided to open source it for our mutual benefit and to ensure future updates should I decide to leave the company.

This module relies on [node-localstorage](https://github.com/lmaccherone/node-localstorage) for its NodeJS implementation


## philosophy
JavaScript is the language of the web. Wouldn't it be nice if we could stop having to rewrite (most) of our code for all those web connected platforms running on JavaScript? That is what madLib hopes to achieve. The focus of madLib is to have the same old boring stuff ready made for multiple platforms. Write your core application logic once using modules and never worry about the basics stuff again. Basics including XHR, XML, JSON, host mappings, settings, storage, etcetera. The idea is to use the tried and proven frameworks where available and use madlib based modules as the missing link.

Currently madLib is focused on supporting the following platforms:

* Web browsers (IE6+, Chrome, Firefox, Opera)
* Appcelerator/Titanium
* PhoneGap
* NodeJS


## installation
```bash
$ npm install madlib-storage-simple --save
```


## usage
```javascript
simpleStorage = require( "madlib-storage-simple" );

simpleStorage.setItem( "foo", "bar" )
simpleStorage.getItem( "foo" )
simpleStorage.removeItem( "foo" )
```