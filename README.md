![image](resources/icon.png)

# Golly Vectorializer

## Description

A [Processing](https://processing.org/)  app to (mainly):

* Import [Golly](http://golly.sourceforge.net/)'s
  [RLE files](http://golly.sourceforge.net/Help/formats.html#rle)
  containing
  [Cellular Automata](https://en.wikipedia.org/wiki/Cellular_automaton)(CA) 
  (precisely
  [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
  one) and visualize them
* Customize the CA's graphical appearance using a customizable dynamic vector Grid
* Create, draw and export new RLEs
* Export the graphical result ***vectorialized!*** (pdf)

## Main goal

Golly Vectorializer was designed and developed as a support tool enabling
*graphic designers* to work with Golly's CAs in vector graphics. 

## Functioning

At the moment, Golly Vectorializer can parse and draw on grid the
provided CA **first generation only**.

Given this static snapshot on grid, through the app widgets you can customize the generation — made of *active* and *inactive* **cells**.

For instance you can crop the viewport, add columns/row, and even change the status of each containing cell.

You can also stretch or widen the cells, filling them with colors
according to a customizable **palette**, randomly or using a
probability distribution function. It is possible to color neighbor
active cells by the same color, according to a notion of proximity.


## Examples
![image](resources/anim1.gif =600x)
![image](resources/anim2.gif =600x)
![image](resources/snap1.png =600x)

## Binaries

### OSX

* **Standard**: 
[golly_vect-beta1-osx-no_java_embedded.zip](compiled_binaries/golly_vect-beta1-osx-no_java_embedded.zip) [[mirror]](http://sharped.net/golly_vect/compiled_binaries/golly_vect-beta1-no_java_embedded.zip) (sha1:1b206e41f2199d1cd487191d3ed7938b36f1713d)
* **Java7 Embedded**: [golly_vect-beta1-osx-java_embedded.zip](http://sharped.net/golly_vect/compiled_binaries/golly_vect-beta1-osx-java_embedded.zip) (mirror only) (sha1:032ef7cfce25966b1f0f65bc77797b6c4eee7bd3)

### Windows

* **32bit**: [golly_vect-beta1-win32.zip](compiled_binaries/golly_vect-beta1-win32.zip) [[mirror]](http://sharped.net/golly_vect/compiled_binaries/golly_vect-beta1-win32.zip) (sha1:cb12390764232834ff8fe5baa75895d8688da225))
* **64bit**: [golly_vect-beta1-win64.zip](compiled_binaries/golly_vect-beta1-win32.zip) [[mirror]](http://sharped.net/golly_vect/compiled_binaries/golly_vect-beta1-win64.zip) (sha1:cb7c2d51c3f36110532be1310269cd7e7d6eadaa)


### Linux

* **32bit**: [golly_vect-beta1-linux32.zip](compiled_binaries/golly_vect-beta1-linux32.zip) [[mirror]](http://sharped.net/golly_vect/compiled_binaries/golly_vect-beta1-linux32.zip) (sha1:d73de7a23f764b5483d796fc3d767ff609ce1cdd)
* **64bit**: [golly_vect-beta1-linux64.zip](compiled_binaries/golly_vect-beta1-linux64.zip) [[mirror]](http://sharped.net/golly_vect/compiled_binaries/golly_vect-beta1-linux64.zip) (sha1:ff6dc46881f20b89794f8bf1f5a4b5625142d301)

## Authors

* [Giuseppe Lobraico](http://github.com/your)
* [arranger1044](http://github.com/arranger1044)



## Aknowledgments

Special thanks to Marika Mastrandrea and Michele Bozzi who are the
designers that originally contacted the authors to work togheter on an
identity design project for **[TrackZero, a self-sustaining organization](http://www.trackzero.org/)**.

The identity theme naturally felt under topics such as self-organizing
complex systems and artificial life. The main objective was to convey
the idea of a live, bottom-up, holistic structure in a generative design way.

Some of the produced graphical artifacts can be found here, here and
here [links temporary unavailable].

The software delivered exceeded the original requirements and maybe skipped some of them... but, judging from the results, we personally don't regret that. :)

## License
Golly Vectorializer is released under the [GPLv3 License](http://www.gnu.org/licenses/gpl-3.0.en.html).
