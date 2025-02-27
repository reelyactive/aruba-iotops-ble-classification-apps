--- A useful set of API functions to communicate with a BLE device
-- @classmod BLEData
BLEData = {}
BLEData.__index = BLEData

--- Initiate the BLE Data module
-- Note: user can only use 1M of memory for Lua Script
-- Note: Each Lua Script can run max 10 second
-- @return the handle to use the other functions
-- @usage handle = BLEData:new()
function BLEData:new()
    local self = setmetatable({}, BLEData)
    Accelerometer = {
        UNSPECIFIED = 0,
        OK = 1,
        OUT_OF_RANGE = 2,
        THRESHOLD1 = 3,
        THRESHOLD1 = 4,
    }

    Alarm = {
        UNSPECIFIED = 0,
        WATER = 1,
        SMOKE = 2,
        FIRE = 3,
        GLASS_BREAK = 4,
        INTRUSION = 5,
    }
    Switch_State = {
        UNSPECIFIED = 0,
        UNKNOWN = 1,
        ON = 2,
        OFF = 3,
    }
    self["Extend"]={}
    self["Accelerometer"]={}
    self["Alarm"]={}
    self["Input"]={}
    self["Input"]["Switch"]={}
    self["Beacons"]={}
    self["Beacons"]["ibeacon"]={}
    self["Beacons"]["eddystone"]={}
    self["Beacons"]["eddystone"]["eddystone_uid"]={}
    self["Beacons"]["eddystone"]["eddystone_url"]={}
    self["Beacons"]["eddystone"]["eddystone_tlm"]={}
    self["Beacons"]["eddystone"]["eddystone_eid"]={}
    self["DeviceClassScope"]={}
    return self
end
---------
-- Set Device Class for the device.
-- @usage handle:setDeviceClass("ABBSENSOR")
function BLEData:setDeviceClass(value)
    self["DeviceClassScope"][value] = {}
end

---------
-- Set Complete Local Name for the device.
-- Since '' is a valid value for local name, and change it to ' ',
-- so in device context, it will treat '' as invalid local name
-- @usage handle:setCompleteLocalName("ABBSENSOR")
function BLEData:setCompleteLocalName(value)
    self["CompleteLocalName"] = value
end

---------
-- Parser Temperature for the device.
--    minimum: -273.15,
--    example: "36.5".
-- @tparam float value the Temperature level for the device
-- @usage handle:setTemperature(25.5)
function BLEData:setTemperature(value)
    self["TemperatureC"] = handleNumberValue(value)
end

---------
-- Set Battery for the device.
--    minimum: 0,
--    maximum: 100,
-- @tparam float value the Battery level for the device
-- @usage handle:setBattery(89)
function BLEData:setBattery(value)
    print(type(value))
    self["Battery"] = handleNumberValue(value)
end

---------
-- Set Voltage for the device.
--    minimum: -3.4028235e+38,
--    maximum: 3.4028235e+38,
-- @tparam float value the Voltage level for the device
-- @usage handle:setVoltage(100.0)
function BLEData:setVoltage(value)
    self["Voltage"] = handleNumberValue(value)
end

---------
-- Set Humidity for the device.
--    minimum: 0,
--    maximum: 100,
-- @tparam float value the Humidity level for the device
-- @usage handle:setHumidity(-100)
function BLEData:setHumidity(value)
    self["Humidity"] = handleNumberValue(value)
end

---------
-- Set Illumination for the device.
--    minimum: 0,
--    maximum: 3.4028235e+38,
-- @tparam float value the Illumination level for the device
-- @usage handle:setIllumination(-100)
function BLEData:setIllumination(value)
    self["Illumination"] = handleNumberValue(value)
end

---------
-- (OBSOLETE)Set SensorTimestamp for the device.
-- @tparam uint value the SensorTimestamp for the device
-- @usage handle:setSensorTimestamp(-100)
function BLEData:setSensorTimestamp(value)
end

---------
-- (OBSOLETE)Set Identifier for the device.
-- @tparam string value the Identifier for the device
-- @usage handle:setIdentifier("100")
-- DEPRECATED: use setDeviceClassScopedDeviceId instead
function BLEData:setIdentifier(value)
end

---------
-- Set HWModel for the device.
-- @tparam string value the HWModel for the device
-- @usage handle:setHardwareModel("aruba beacon")
function BLEData:setHardwareModel(value)
    self["HWModel"] = value
end

---------
-- Set Extend for the device.
-- @tparam string key the key for the pair
-- @tparam any value the value for the pair
-- @usage handle:setExtend("userData","userData")
function BLEData:setExtend(key,value)
    self["Extend"][key]= value
end

---------
-- Set Accelerometer X for the device.
-- @tparam float value the Accelerometer X
-- @usage handle:AccelerometerX(1.2)
function BLEData:setAccelerometerX(value)
    self["Accelerometer"]["X"] = handleNumberValue(value)
end

---------
-- Set Accelerometer Y for the device.
-- @tparam float value the Accelerometer Y
-- @usage handle:setAccelerometerY(1.2)
function BLEData:setAccelerometerY(value)
    self["Accelerometer"]["Y"]= handleNumberValue(value)
end

---------
-- Set Accelerometer Z for the device.
-- @tparam float value the Accelerometer Z
-- @usage handle:setAccelerometerZ(1.2)
function BLEData:setAccelerometerZ(value)
    self["Accelerometer"]["Z"]= handleNumberValue(value)
end

---------
-- Set Accelerometer Status for the device.
-- @tparam status status enum Accelerometer.OK,Accelerometer.OUT_OF_RANGE,Accelerometer.THRESHOLD1,Accelerometer.THRESHOLD2
-- @usage handle:setAccelerometerStatus(Accelerometer.OK)
function BLEData:setAccelerometerStatus(status)
    self["Accelerometer"]["accel_status"]=status
end

---------
-- Set Motion for the device.
-- @tparam bool value the Motion for the device
-- @usage handle:setMotion(true)
function BLEData:setMotion(value)
    self["Motion"]= handleBooleanValue(value)
end

---------
-- Set Current for the device.
--    minimum: -3.4028235e+38,
--    maximum: 3.4028235e+38,
-- @tparam int value the Current for the device
-- @usage handle:setCurrent(32)
function BLEData:setCurrent(value)
    self["Current"]=handleNumberValue(value)
end

---------
-- Set CO for the device.
--    minimum: 0,
--    maximum: 1000000,
-- @tparam int value the CO for the device
-- @usage handle:setCO(32)
function BLEData:setCO(value)
    self["CO"]=handleNumberValue(value)
end

---------
-- Set CO2 for the device.
--    minimum: 0,
--    maximum: 1000000,
-- @tparam int value the CO2 for the device
-- @usage handle:setCO2(32)
function BLEData:setCO2(value)
    self["CO2"]=handleNumberValue(value)
end

---------
-- Set VOC for the device.
--    minimum: 0,
--    maximum: 1000000,
-- @tparam int value the VOC for the device
-- @usage handle:setVOC(32)
function BLEData:setVOC(value)
    self["VOC"]=handleNumberValue(value)
end

---------
-- Set Resistance for the device.
--    minimum: 0,
--    maximum: 3.4028235e+38,
-- @tparam float value the Resistance for the device
-- @usage handle:setResistance(32)
function BLEData:setResistance(value)
    self["Resistance"]=handleNumberValue(value)
end

---------
-- Set Pressure for the device.
--    minimum: 0,
--    maximum: 3.4028235e+38,
-- @tparam int value the Pressure for the device
-- @usage handle:setPressure(32)
function BLEData:setPressure(value)
    self["Pressure"]=handleNumberValue(value)
end


---------
-- Set Alarm for the device.
-- @usage handle:setAlarmWater()
function BLEData:setAlarmWater()
    self["Alarm"]["WATER"]=Alarm.WATER
end

---------
-- Set Alarm for the device.
-- @usage handle:setAlarmSmoke()
function BLEData:setAlarmSmoke()
    self["Alarm"]["SMOKE"]=Alarm.SMOKE
end

---------
-- Set Alarm for the device.
-- @usage handle:setAlarmFire()
function BLEData:setAlarmFire()
    self["Alarm"]["FIRE"]=Alarm.FIRE
end

---------
-- Set Alarm for the device.
-- @usage handle:setAlarmGlassBreak()
function BLEData:setAlarmGlassBreak()
    self["Alarm"]["GLASS_BREAK"]=Alarm.GLASS_BREAK
end

---------
-- Set Alarm for the device.
-- @usage handle:setAlarmIntrusion()
function BLEData:setAlarmIntrusion()
    self["Alarm"]["INTRUSION"]=Alarm.INTRUSION
end

---------
-- Set Distance for the device.
--    minimum: 0,
--    maximum: 3.4028235e+38,
-- @tparam int value the Distance for the device
-- @usage handle:setDistance(32)
function BLEData:setDistance(value)
    self["Distance"]=handleNumberValue(value)
end

---------
-- Set Capacitance for the device.
--    minimum: 0,
--    maximum: 3.4028235e+38,
-- @tparam float value the Capacitance for the device
-- @usage handle:setCapacitance(32.32)
function BLEData:setCapacitance(value)
    self["Capacitance"]=handleNumberValue(value)
end



---------
-- Set Input Switch for the device.
-- @usage handle:setInputSwitchON()
function BLEData:setInputSwitchOn()
    self["Input"]["Switch"]["ON"]= Switch_State.ON
end

---------
-- Set Input Switch for the device.
-- @usage handle:setInputSwitchOFF()
function BLEData:setInputSwitchOFF()
    self["Input"]["Switch"]["OFF"]= Switch_State.OFF
end

---------
-- Set Input Switch for the device.
-- @usage handle:setInputSwitchON()
function BLEData:setInputSwitchUNKNOWN()
    self["Input"]["Switch"]["UNKNOWN"]= Switch_State.UNKNOWN
end

---------
-- Set IBeacon UUID for the device.
-- @tparam bytes value the value of UUID
-- @usage handle:setIBeaconUUID(value)
function BLEData:setIBeaconUUID(value)
    self["Beacons"]["ibeacon"]["bytes_ibeacon_uuid"]= value
end

---------
-- Set IBeacon Major for the device.
--    minimum: 0,
--    maximum: 65535,
-- @tparam int value the value of Major
-- @usage handle:setIBeaconMajor(value)
function BLEData:setIBeaconMajor(value)
    self["Beacons"]["ibeacon"]["ibeacon_major"]= value
end

---------
-- Set IBeacon Minor for the device.
--    minimum: 0,
--    maximum: 65535,
-- @tparam int value the value of Minor
-- @usage handle:setIBeaconMinor(value)
function BLEData:setIBeaconMinor(value)
    self["Beacons"]["ibeacon"]["ibeacon_minor"]= value
end

---------
-- Set IBeacon Power for the device.
--    minimum: -100,
--    maximum: 0,
-- @tparam int value the value of Power
-- @usage handle:setIBeaconPower(value)
function BLEData:setIBeaconPower(value)
    self["Beacons"]["ibeacon"]["ibeacon_power"]= value
end

---------
-- Set IBeacon Extra for the device.
-- @tparam bytes value the value of extra field
-- @usage handle:setIBeaconPower(value)
function BLEData:setIBeaconExtra(value)
    self["Beacons"]["ibeacon"]["bytes_beacon_extra"]= value
end

---------
-- Set Eddystone UID CalibratedPower for the device.
--      minimum: -100,
--      maximum: 20,
-- @tparam int value the value of Eddystone UID Calibrated Power
-- @usage handle:setEddystoneUIDCalibratedPower(value)
function BLEData:setEddystoneUIDCalibratedPower(value)
    self["Beacons"]["eddystone"]["eddystone_uid"]["calibrated_power"]= value
end

---------
-- Set Eddystone UID Nid for the device.
--      max_length: 9,
--      min_length: 9.
-- @tparam bytes value the value of Eddystone UID Nid
-- @usage handle:setEddystoneUIDNid(value)
function BLEData:setEddystoneUIDNid(value)
    self["Beacons"]["eddystone"]["eddystone_uid"]["bytes_eddystone_uid_nid"]= value
end

---------
-- Set Eddystone UID Bid for the device.
--      max_length: 5,
--      min_length: 5.
-- @tparam bytes value the value of Eddystone UID Bid
-- @usage handle:setEddystoneUIDNid(value)
function BLEData:setEddystoneUIDBid(value)
    self["Beacons"]["eddystone"]["eddystone_uid"]["bytes_eddystone_uid_bid"]= value
end

---------
-- Set Eddystone URL CalibratedPower for the device.
--      minimum: -100,
--      maximum: 20,
-- @tparam int value the value of Eddystone URL Calibrated Power
-- @usage handle:setEddystoneURLCalibratedPower(value)
function BLEData:setEddystoneURLCalibratedPower(value)
    self["Beacons"]["eddystone"]["eddystone_url"]["calibrated_power"]= value
end

---------
-- Set Eddystone URL Prefix for the device.
--      minimum: 0,
--      maximum: 3.
-- @tparam int value the value of Eddystone URL Prefix
-- @usage handle:setEddystoneURLPrefix(value)
function BLEData:setEddystoneURLPrefix(value)
    self["Beacons"]["eddystone"]["eddystone_url"]["eddystone_url_prefix"]= value
end

---------
-- Set Eddystone URL EncodedUrl  for the device.
--      min_length: 1,
--      max_length: 17.
-- @tparam bytes value the value of Eddystone URL EncodedUrl
-- @usage handle:setEddystoneURLEncodedUrl (value)
function BLEData:setEddystoneURLEncodedUrl (value)
    self["Beacons"]["eddystone"]["eddystone_url"]["bytes_eddystone_url_encoded_url"]= value
end

---------
-- Set Eddystone TLM Version for the device.
-- @tparam int value the value of Eddystone TLM Version
-- @usage handle:setEddystoneTLMVersion(value)
function BLEData:setEddystoneTLMVersion(value)
    self["Beacons"]["eddystone"]["eddystone_tlm"]["version"]= value
end

---------
-- Set Eddystone TLM Battery Voltage  for the device.
--      minimum: 0,
--      example: "100".
-- @tparam float value the value of Eddystone TLM Battery Voltage
-- @usage handle:setEddystoneTLMBatteryVoltage (value)
function BLEData:setEddystoneTLMBatteryVoltage (value)
    self["Beacons"]["eddystone"]["eddystone_tlm"]["battery_voltage"]= value
end

---------
-- Set Eddystone TLM Beacon Temperature  for the device.
-- @tparam float value the value of Eddystone TLM Beacon Temperature
-- @usage handle:setEddystoneTLMBeaconTemperature (value)
function BLEData:setEddystoneTLMBeaconTemperature (value)
    self["Beacons"]["eddystone"]["eddystone_tlm"]["beacon_temperature"]= value
end

---------
-- Set Eddystone TLM Advertisement Count for the device.
--      minimum: 0,
-- @tparam int value the value of Eddystone TLM Advertisement Count
-- @usage handle:setEddystoneTLMAdvCount (value)
function BLEData:setEddystoneTLMAdvCount (value)
    self["Beacons"]["eddystone"]["eddystone_tlm"]["adv_count"]= value
end

---------
-- Set Eddystone TLM Sec Count for the device.
--      minimum: 0,
-- @tparam int value the value of Eddystone TLM Sec Count
-- @usage handle:setEddystoneTLMSecCount (value)
function BLEData:setEddystoneTLMSecCount (value)
    self["Beacons"]["eddystone"]["eddystone_tlm"]["sec_count"]= value
end

---------
-- Set Eddystone TLM Etlm for the device.
-- @tparam bytes value the value of Eddystone TLM Etlm
-- @usage handle:setEddystoneTLMEtlm (value)
function BLEData:setEddystoneTLMEtlm (value)
    self["Beacons"]["eddystone"]["eddystone_tlm"]["bytes_eddystone_tlm_etlm"]= value
end

---------
-- Set Eddystone TLM Salt for the device.
-- @tparam bytes value the value of Eddystone TLM Salt
-- @usage handle:setEddystoneTLMSalt (value)
function BLEData:setEddystoneTLMSalt (value)
    self["Beacons"]["eddystone"]["eddystone_tlm"]["bytes_eddystone_tlm_salt"]= value
end

---------
-- Set Eddystone TLM Mic for the device.
-- @tparam bytes value the value of Eddystone TLM Mic
-- @usage handle:setEddystoneTLMMic (value)
function BLEData:setEddystoneTLMMic (value)
    self["Beacons"]["eddystone"]["eddystone_tlm"]["bytes_eddystone_tlm_mic"]= value
end

---------
-- Set Eddystone EID CalibratedPower for the device.
-- @tparam int value the value of Eddystone EID Calibrated Power
-- @usage handle:setEddystoneEIDCalibratedPower(value)
function BLEData:setEddystoneEIDCalibratedPower(value)
    self["Beacons"]["eddystone"]["eddystone_eid"]["calibrated_power"]= value
end

---------
-- Set Eddystone EID Eid for the device.
-- @tparam int value the value of Eddystone EID Eid
-- @usage handle:setEddystoneEIDEid(value)
function BLEData:setEddystoneEIDEid(value)
    self["Beacons"]["eddystone"]["eddystone_eid"]["bytes_eddystone_eid_eid"]= value
end

---------
-- Set device id for the class of the device.
-- @tparam string deviceClass the key of deviceClassScope
-- @tparam string deviceId the value of deviceClassScope
-- @usage handle:setDeviceClassScopedDeviceId(deviceClass, deviceId)
function BLEData:setDeviceClassScopedDeviceId(deviceClass, deviceId)
    if self["DeviceClassScope"][deviceClass] ~= nil then
        self["DeviceClassScope"][deviceClass]["string_DeviceId"] = deviceId
    end
end

---------
-- Set Suppression for the device.
-- @tparam bool value the value of suppressed or not
-- @usage handle:setDeviceSuppressed(value)
function BLEData:setDeviceSuppressed(value)
    self["Suppressed"] = handleBooleanValue(value)
end

---------
-- Set calibrated power for the device.
-- @tparam int value the value of calibrated power
-- @usage handle:setCalibratedPower(value)
function BLEData:setCalibratedPower(value)
    self["DeviceInfo"]["CalibratedPower"] = value
end

function handleNumberValue(value)
    if type(value) == 'number' then
        return value
    elseif type(value) == 'string' then
        return tonumber(value)
    else
        return nil
    end
end

function handleBooleanValue(value)
    if type(value) == 'boolean' then
        return value
    else
        return nil
    end
end