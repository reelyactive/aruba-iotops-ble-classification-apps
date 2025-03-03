--
-- Copyright reelyActive 2025
-- We believe in an open Internet of Things
-- This script is based on HPE Aruba Networking's iBeacon.lua example for IoTOps
--

function decode(address, addressType, advType, elements)
  local handle = BLEData:new()

  -- Apple iBeacon constants
  MANUFACTURER_DATA_TYPE = 0xff
  APPLE_COMPANY_CODE = 0x004c
  IBEACON_FRAME_TYPE = 0x02

  -- See https://reelyactive.github.io/interoperable-identifier/
  PROXIMITY_UUID_PREFIX = "\x49\x6f\x49\x44\x43\x4f\x44\x45\xb7\x3e"
  
  local manufacturerData = elements[MANUFACTURER_DATA_TYPE]

  -- Confirm that manufacturer-specific data is indeed present, correct length
  if manufacturerData == nil or #manufacturerData < 25 then
    return handle
  end

  -- Determine the company code, frame type and proximity UUID prefix
  local companyCode = string.unpack("<I2", (string.sub(manufacturerData, 1, 2)))
  local frameType = string.unpack(">i1", (string.sub(manufacturerData, 3, 3)))
  local proximityUuidPrefix = string.sub(manufacturerData, 5, 14)

  -- Confirm Apple iBeacon frame with InteroperaBLE Identifier UUID prefix
  if companyCode ~= APPLE_COMPANY_CODE or
     frameType ~= IBEACON_FRAME_TYPE or
     proximityUuidPrefix ~= PROXIMITY_UUID_PREFIX then
    return handle
  end

  -- Determine the iBeacon properties
  local iBeaconUuid = string.sub(manufacturerData, 5, 20)
  local iBeaconMajor = string.unpack(">I2",
                                     string.sub(manufacturerData, 21, 22))
  local iBeaconMinor = string.unpack(">I2",
                                     string.sub(manufacturerData, 23, 24))
  local iBeaconTxPower = string.unpack(">i1",
                                       string.sub(manufacturerData, 25, 25))

  -- Determine the InteroperaBLE Identifier properties
  local instanceId = ((iBeaconMajor & 0xfff) << 16) + iBeaconMinor
  local instanceIdHex = string.format("%07x", instanceId)
  local entityUuidSuffix = string.sub(manufacturerData, 15, 20)

  -- Determine the scoped deviceId based on address type
  local scopedDeviceId = address
  if ble_mac_address_is_private(addressType) then
    scopedDeviceId = instanceIdHex
  end

  -- Set common attribute for InteroperaBLE Identifier    
  handle:setExtend("txPower", iBeaconTxPower)
  --handle:setCalibratedPower(iBeaconTxPower) -- TODO: use when supported

  -- DirAct (uses DirAct device class)
  if entityUuidSuffix == "\x44\x69\x72\x41\x63\x74" then
    handle:setDeviceClass("DirAct")
    handle:setDeviceClassScopedDeviceId("DirAct", instanceIdHex)
    return handle
  end

  -- Local .mp3 file
  if entityUuidSuffix == "\x2e\x2f\x2e\x6d\x70\x33" then
    handle:setExtend("uri", "file:/" .. instanceIdHex .. ".mp3")
  end

  -- Unicode Code Point
  if entityUuidSuffix == "\x55\x54\x46\x2d\x33\x32" then
    handle:setExtend("unicodeCodePoint", utf8.char(instanceId))
  end

  -- Motion detection
  if entityUuidSuffix == "\x4d\x6f\x74\x69\x6f\x63" then
    handle:setMotion(true)
    handle:setExtend("isMotionDetected", true)
  end

  -- Button pressed
  if entityUuidSuffix == "\x42\x75\x74\x74\x6f\x6e" then
    handle:setExtend("isButtonPressed", true)
  end

  -- Set the device class and scoped deviceId
  handle:setDeviceClass("iBeacon")
  handle:setDeviceClassScopedDeviceId("iBeacon", scopedDeviceId)

  return handle
end
