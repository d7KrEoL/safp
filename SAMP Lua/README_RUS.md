# LUA библиотека чтения планов полёта GTA San Andreas для [moonloader](https://www.blast.hk/threads/13305/)
Эта библиотека позволит получать данные из файлов формата San Andreas Flight Plan (*.safp) и использовать их в ваших lua скриптах.

## Установка и использование.
Для установки библиотеки поместите файл safp.lua в папку с игрой -> moonloader -> lib

Чтобы использовать библиотеку в скрипте, сначала её необходимо подключить:

```lua
local safp = require 'safp'
```

Для получения информации из файла, расположенного по пути filePath можно использовать подобную функцию: 

```lua
function loadSafp(filePath)

  --Проверка что файл существует и доступен для чтения
  local checkFile=io.open(filePath,"r")
  if checkFile~=nil then
    io.close(checkFile)
  else
    print("Flight plan not found (" .. filePath .. ")")
    return
  end

  --Загрузка информации из файла о маршрутных точках с помощью
  --библиотеки "safp", подключенной в предыдущем пункте
  local wpData = safp.Load(filePath)

  --После загрузки, можно передать сразу список ППМ
  --(поворотных пунктов маршрута / маршрутных точек) в вашу функцию
  yourGetWaypointDataFunc(safp.Waypoints)

  --Либо перебором получить доступ к каждому отдельному элементу списка
  for i = 1, #safp.Waypoints do

    --И добавить каждый отдельный элемент, используя вашу функцию для добавления ППМ:
    yourAddWaypointFunc(safp.Waypoints[i].wpid,
                        safp.Waypoints[i].pos.x,
                        safp.Waypoints[i].pos.y,
                        safp.Waypoints[i].pos.z))
  end
end
```

Информация о ППМ хранится в списке, имеющем следующий вид:

```lua
Waypoints = {wpid, pos = {x, y, z}} 
```

где:

```lua
(int) wpid - номер (id) маршрутной точки
(float) pos.x - широта ППМ
(float) pos.y - долгота ППМ
(float) pos.z - высота ППМ
```

формат файла предполагает что маршрутные точки могут быть записаны не по порядку, поэтому при добавлении ППМ обращайте внимание на поле wpid

Быстро сгенерировать план полёта в нужном формате можно используя [этот сайт](http://sampmap.ru/samap)
