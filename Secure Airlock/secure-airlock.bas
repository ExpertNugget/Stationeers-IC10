# CONFIG
CONST IntPressure = 1kPa # Target Base Pressure
CONST ExtPressure = 3kPa # Extiorior Pressure
# CONFIG


# DONT TOUCH BELOW UNLESS YOU KNOW WHAT YOU'RE DOING!!
ALIAS IntVent d0
ALIAS ExtVent d1
ALIAS IntDoor d2
ALIAS ExtDoor d3
ALIAS Lock d4
ALIAS Cycle d5
ALIAS Status db
ALIAS Sensor = IC.Device[-1252983604]

ExtVent.On = 0
IntVent.On = 0
ExtDoor.Open = 1
IntDoor.Open = 0

Status = 0
# 0 = Open to Ext, Ready to cycle
# 1 = Cycling to INT
# 2 = Open to Int, Ready to cyle
# 3 = Cyclig to EXT

Start:
yield()
IF Lock.Setting == 1 THEN
    GOTO Start
ENDIF
IF Cycle.Setting == 1 THEN
    IF Status == 0 THEN
        Status = 1
        ExtDoor.Open = 0
        ExtVent.Mode = 1
        ExtVent.On = 1
        WHILE Sensor.Pressure > 0kPa
            WAIT(3)
        ENDWHILE
        ExtVent.On = 0
        IntVent.Mode = 0
        IntVent.On = 1
        WHILE Sensor.Pressure <= IntPressure
            WAIT(3)
        ENDWHILE
        IntVent.On = 0
        IntDoor.Open = 1
        Status = 2
    ENDIF
ENDIF
IF Cycle.Setting == 1 THEN 
    IF Status == 2 THEN
        Status = 3
        IntDoor.Open = 0
        IntVent.Mode = 1 
        IntVent.On = 1
        WHILE Sensor.Pressure > 0kPa
            WAIT(3)
        ENDWHILE
        IntVent.On = 0
        ExtVent.Mode = 0
        ExtVent.On = 1
        WHILE Sensor.Pressure <= ExtPressure
            WAIT(3)
        ENDWHILE
        ExtVent.On = 0
        ExtDoor.Open = 1
        Status = 0
    ENDIF
ENDIF
GOTO Start
