#
# RandomNumberGenerator based on Jon Watte's mersenne twister package.
# Adds several utility methods under a unified interface, that'll allow to use 
# different number generators at some point.
#
mersenne = require 'mersenne'

class RandomNumberGenerator
  constructor: (initialSeed=0) ->
    @seed(initialSeed)

  seed: (value) ->
    @seedValue = value
    mersenne.seed @seedValue

  toString: ->
    "RandomNumberGenerator(#{@seedValue})"


  # ~~~ Numbers ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  next: ->
    k = 1000000
    mersenne.rand(k) / k

  # returns a random integer between min and max
  int: (min, max) -> Math.floor(@next() * (max - min) + min)

  # returns a random boolean true/ false
  bool: (chance=0.5) -> @next() < chance


  # ~~~ Lists ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # sorts the given list in random order
  shuffle: (list) -> list.sort -> 0.5 - @next()

  # picks one or several random elements from a list
  pick: (list, count=1) ->
    switch list.length
      when 0 then null
      when 1 then list[0]
      else
      # return single entry
        if count == 1
          list[ @int(0, list.length) ]

          # return multiple entries as list
        else
          indices = []
          for i in [0...list.length]
            indices.push i

          exports.shuffle(indices)
          result = []
          for i in [0...count]
            result.push list[ indices[i] ]

          result

  # given two options selects a random element from one
  pickAB: (listA, listB, chance) ->
    list = if @next() < chance then listA else listB
    @pick list


module.exports =
  RandomNumberGenerator: RandomNumberGenerator
