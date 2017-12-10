# vim-github-link-opener

Ever seen something like this?

    gem "github/linguist"

Wouldn't it be cool if you could quickly open
<https://github.com/github/linguist>?

This plugin lets you do exactly that!

## Installation

With [vim-plug](https://github.com/junegunn/vim-plug):

    Plug 'gabebw/vim-github-link-opener'

Then run `:PlugInstall`.

## Usage

It's exactly like visiting other URLs in vim: type `gx` when your cursor is
anywhere in the string, and this plugin will open the GitHub project in your
browser.

It won't change how `gx` treats other URLs. They'll still work. And if you use
@christoomey's excellent
[vim-quicklink](https://github.com/christoomey/vim-quicklink), that will keep
working too.
