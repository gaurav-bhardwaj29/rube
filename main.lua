function love.load()
    love.window.setTitle("Rube Goldberg Machine")
    love.window.setMode(800, 600)
  
    love.physics.setMeter(64) 
    world = love.physics.newWorld(0, 9.81 * 64, true)
  
    objects = {}
  
    -- Ground
    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, 400, 575, "static")
    objects.ground.shape = love.physics.newRectangleShape(800, 50)
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

  
    -- Ball
    objects.ball = {}
    objects.ball.body = love.physics.newBody(world, 200, 100, "dynamic")
    objects.ball.shape = love.physics.newCircleShape(20)
    objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)
    objects.ball.fixture:setRestitution(0.6) -- coefficient of restitution

    -- Ramp
    objects.ramp = {}
    objects.ramp.body = love.physics.newBody(world, 400, 400, "static")
    objects.ramp.shape = love.physics.newPolygonShape(-150, -10, 150, 10, 150, -10, -150, 10) 
    objects.ramp.fixture = love.physics.newFixture(objects.ramp.body, objects.ramp.shape)
    objects.ramp.body:setAngle(-math.pi / 6)

    -- Dominos
    objects.dominoes = {}
    local startX = 300
    for i = 1, 6 do
      local domino = {}
      domino.body = love.physics.newBody(world, startX + (i * 25), 500, "dynamic")
      domino.shape = love.physics.newRectangleShape(5, 40)
      domino.fixture = love.physics.newFixture(domino.body, domino.shape, 0.3)
      domino.fixture:setRestitution(0.1)
      domino.fixture:setFriction(0.8)
      table.insert(objects.dominoes, domino)
    end
    -- Seesaw and pivot
    objects.seesaw = {}
    objects.seesaw.body = love.physics.newBody(world, 700, 550, "dynamic")
    objects.seesaw.shape = love.physics.newRectangleShape(200, 20)
    objects.seesaw.fixture = love.physics.newFixture(objects.seesaw.body, objects.seesaw.shape, 1)
    objects.seesaw.body:setMass(0.5)

    objects.seesaw.pivot = love.physics.newBody(world, 700, 550, "static")
    objects.seesaw.joint = love.physics.newRevoluteJoint(objects.seesaw.pivot, objects.seesaw.body, 700, 550, false)

end
  
function love.update(dt)
    world:update(dt)
end
  
function love.draw()
    love.graphics.setColor(0.6, 0.2, 0.1) 
    love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))
  
    love.graphics.setColor(0.75, 0.75, 0.75) 
    love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
    love.graphics.setColor(0.5, 0.5, 0.5) 
    love.graphics.polygon("fill", objects.ramp.body:getWorldPoints(objects.ramp.shape:getPoints()))
    for _, domino in ipairs(objects.dominoes) do
      love.graphics.setColor(0.9, 0.6, 0.3)
      love.graphics.polygon("fill", domino.body:getWorldPoints(domino.shape:getPoints()))
    end
    love.graphics.setColor(0.5, 0.3, 0.1)
    love.graphics.polygon("fill", objects.seesaw.body:getWorldPoints(objects.seesaw.shape:getPoints()))
end

