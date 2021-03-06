vector = require '../math/vector'
Vec2 = vector.Vec2
Vec3 = vector.Vec3

# States of the particle
State =
  ALIVE: 0
  LOCKED: 1
  IDLE: 2
  DEAD: 3


###

  VerLer Particle Baseclass

  FIELD flavoured particle integrator.
  Supports Verlet-style integration for 'strict' relationships e.g. Springs + Constraints
  and also Euler-style continous force integration for smooth/ flowing behaviour e.g. Flocking

###
class Particle
  id: 0
  state: State.ALIVE
  age: 0
  lifetime: -1

  size: 1

  # Spring
  isLocked: false

  position: null
  drag: 0.03

  # Verlet style previous position
  prev: null

  # Euler force
  force: null
  velocity: null

  constructor: (id) -> @id = id

  clearVelocity: -> @prev.set @position
  scaleVelocity: (amount) -> @prev.lerp @position, 1.0 - amount

  setPosition: (v) ->
    @position.set v
    @prev.set v

  lock: -> @state = State.LOCKED
  unlock: -> @state = State.ALIVE
  die: -> @state = State.DEAD
  idle: -> @state = State.IDLE

  toString: -> "Particle(#{@position})"



###

  3D VerLer Particle

###
class Particle3 extends Particle
  tmp = new Vec3()

  constructor: (@id) ->
    @position = new Vec3()
    @prev = new Vec3()

    @force = new Vec3()
    @velocity = new Vec3()

  update: ->
    @age++
    return if @state > State.ALIVE

    @state = State.DEAD if @lifetime > 0 and @age == @lifetime

    # integrate velocity
    tmp.set @position
    @position.x += ((@position.x - @prev.x) + @force.x)
    @position.y += ((@position.y - @prev.y) + @force.y)
    @position.z += ((@position.z - @prev.z) + @force.z)
    @prev.set tmp
    @prev.lerp @position, @drag
    @force.zero()

  setPosition3: (x, y, z) ->
    @position.set3 x, y, z
    @prev.set3 x, y, z


###

  2D VerLer Particle

###
class Particle2 extends Particle
  tmp = new Vec2()

  constructor: (@id) ->
    @position = new Vec2()
    @prev = new Vec2()

    @force = new Vec2()
    @velocity = new Vec2()

  update: ->
    @age++
    return if @state > State.ALIVE

    @state = State.DEAD if @lifetime > 0 and @age == @lifetime

    # integrate velocity
    tmp.set @position
    @position.x += ((@position.x - @prev.x) + @force.x)
    @position.y += ((@position.y - @prev.y) + @force.y)
    @prev.set tmp
    @prev.lerp @position, @drag
    @force.zero()

  setPosition2: (x, y) ->
    @position.set2 x, y
    @prev.set2 x, y


module.exports =
  Particle: Particle
  Particle2: Particle2
  Particle3: Particle3
  State: State
