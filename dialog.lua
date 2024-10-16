dialog = {}

-- dialog properties
dialog = {}
dialog.box = {}
dialog.box.padding = 30
dialog.box.height = windowHeight / 4
dialog.box.x = dialog.box.padding
dialog.box.width = (windowWidth - dialog.box.x - dialog.box.padding)
dialog.box.y = (windowHeight - dialog.box.height - dialog.box.padding)
dialog.open = false
dialog.choice = {}
dialog.menuChoice = 1
dialog.menuChoiceLen = 1

-- dialog scenes properties
scene = {
  config = {},
  script = {},
  step = 1,
  len = 1,
  complete = false,
  inMenu = false
}

function dialog:registerScene(current_scene)
  scene.config = current_scene
  scene.script = current_scene.script[lang]
  scene.len = getLen(current_scene.script[lang])
  scene.step = 1
  return scene
end

function dialog:unregisterScene(current_scene)
  if scene.config == current_scene then
    scene.config = {}
    scene.script = {}
    scene.step = 1
    scene.len = 1
    scene.complete = false
    scene.inMenu = false
  end
  return scene
end

function dialog:clearScenes()
  scene.config = {}
  scene.script = {}
  scene.step = 1
  scene.len = 1
  scene.complete = false
  scene.inMenu = false
  return scene
end

function dialog:chooseOption(choice)
  if scene.inMenu then
    local option = scene.script[scene.step].choices[choice]

    if option.branch then
      dialog.choice = option.branch
      dialog:append(
        script,
        dialog.choice
      )
      scene.len = getLen(script)
    end

  end
end

function dialog:keypressed(key)
  if key == "q" then
    if scene.config.persist == false then
      scene.step = 1
    end
    dialog:unregisterScene(scene)
    dialog.open = false
  end

  if scene.inMenu then
    if key == "down" then
      if dialog.menuChoice < dialog.menuChoiceLen then
        dialog.menuChoice = dialog.menuChoice + 1
      end
    end

    if key == "up" then
      if dialog.menuChoice ~= 1 then
        dialog.menuChoice = dialog.menuChoice - 1
      end
    end

    if key == "e" then
      dialog:chooseOption(dialog.menuChoice)
    end
  end

  if scene.config ~= {} then
    if key == "e" then
      if scene.step < scene.len then
        scene.step = scene.step + 1
      end
    end

    if key == "o" then
      if scene.step ~= 1 then
        scene.step = scene.step - 1
      end
    end
  end

end

function dialog:draw()
  if dialog.open then
      love.graphics.setColor(255, 255, 255)
      love.graphics.rectangle("fill", dialog.box.x, dialog.box.y, windowWidth-40, dialog.box.height)

      love.graphics.setColor(0, 0, 0)
      love.graphics.setLineWidth(windowWidth - 80)

      if scene.config and scene.config == {} then
        log("No scene to load.")
      else
        script = scene.script
        if script and scene.complete == false then

          if script[scene.step].choices then
            dialog.menuChoiceLen = getLen(script[scene.step].choices)
            dialog:drawChoiceMenu(script[scene.step].choices, dialog)
          else
            scene.inMenu = false

            love.graphics.print(script[scene.step][1], dialog.box.x + dialog.box.padding, dialog.box.y + dialog.box.padding)
            love.graphics.print(script[scene.step][2], dialog.box.x + (dialog.box.padding), dialog.box.y + (dialog.box.padding * 3))
          end
        end
      end

    love.graphics.setColor(255, 255, 255)
  end
end

function dialog:append(script, newScript)
  local n = #script
  for i=1, #newScript do script[n+i] = newScript[i] end
end

function dialog:drawChoiceMenu(choices, dialog)
  scene.inMenu = true

  local choice_padding = 0
  local optionX = 0
  local optionY = 0

  local choicePositions = {}

  for _, phrase in ipairs(choices) do
    choice_padding = choice_padding + 30
    optionX = dialog.box.x + dialog.box.padding
    optionY = dialog.box.y + (dialog.box.padding) + choice_padding

    table.insert(choicePositions, {
      phrase,
      x = optionX,
      y = optionY,
    })

    log(dump({
      phrase, optionX, optionY
    }))

    
      love.graphics.print(phrase, optionX, optionY)
    end

  local pointerX = choicePositions[dialog.menuChoice].x
  local pointerY = choicePositions[dialog.menuChoice].y + 20
  --local pointerWidth = (windowWidth-40) - (dialog.box.padding) - 30
  --local pointerHeight = 15

  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle("fill", pointerX, pointerY, windowWidth/4, 5)
  love.graphics.setColor(255, 255, 255)
end
