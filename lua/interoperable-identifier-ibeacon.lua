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
  
  local manufacturer_data = elements[MANUFACTURER_DATA_TYPE]

  -- Confirm that manufacturer-specific data is indeed present, correct length
  if manufacturer_data == nil or #manufacturer_data < 25 then
    return handle
  end

  -- Determine the company code, frame type and proximity UUID prefix
  local company_code = string.unpack("<I2",
                                     (string.sub(manufacturer_data, 1, 2)))
  local frame_type = string.unpack(">i1",
                                   (string.sub(manufacturer_data, 3, 3)))
  local proximity_uuid_prefix = string.sub(manufacturer_data, 5, 14)

  -- Confirm Apple iBeacon frame with InteroperaBLE Identifier UUID prefix
  if company_code ~= APPLE_COMPANY_CODE or
     frame_type ~= IBEACON_FRAME_TYPE or
     proximity_uuid_prefix ~= PROXIMITY_UUID_PREFIX then
    return handle
  end

  -- Determine the iBeacon properties
  local proximity_uuid = string.sub(manufacturer_data, 5, 20)
  local proximity_major = string.unpack(">I2",
                                        string.sub(manufacturer_data, 21, 22))
  local proximity_minor = string.unpack(">I2",
                                        string.sub(manufacturer_data, 23, 24))
  local proximity_tx_power = string.unpack(">i1",
                                        string.sub(manufacturer_data, 25, 25))

  -- Determine the InteroperaBLE Identifier properties
  local instance_id = ((proximity_major & 0xfff) << 16) + proximity_minor
  local instance_id_hex = string.format("%07x", instance_id)
  local entity_uuid_suffix = string.sub(manufacturer_data, 15, 20)

  -- Determine the scoped deviceId based on address type
  local scoped_device_id = address
  if ble_mac_address_is_private(addressType) then
    scoped_device_id = instance_id_hex
  end

  -- Set common attribute for InteroperaBLE Identifier    
  handle:setExtend("txPower", proximity_tx_power)
  --handle:setCalibratedPower(proximity_tx_power) -- TODO: use when supported

  -- DirAct (uses DirAct device class)
  if entity_uuid_suffix == "\x44\x69\x72\x41\x63\x74" then
    handle:setDeviceClass("DirAct")
    handle:setDeviceClassScopedDeviceId("DirAct", instance_id_hex)
    return handle
  end

  -- Local .mp3 file
  if entity_uuid_suffix == "\x2e\x2f\x2e\x6d\x70\x33" then
    handle:setExtend("uri", "file:/" .. instance_id_hex .. ".mp3")
  end

  -- Unicode Code Point
  if entity_uuid_suffix == "\x55\x54\x46\x2d\x33\x32" then
    handle:setExtend("unicodeCodePoint", utf8.char(instance_id))
  end

  -- Motion detection
  if entity_uuid_suffix == "\x4d\x6f\x74\x69\x6f\x63" then
    handle:setMotion(true)
    handle:setExtend("isMotionDetected", true)
  end

  -- Button pressed
  if entity_uuid_suffix == "\x42\x75\x74\x74\x6f\x6e" then
    handle:setExtend("isButtonPressed", true)
  end

  -- Set the device class and scoped deviceId
  handle:setDeviceClass("InteroperaBLE Identifier")
  handle:setDeviceClassScopedDeviceId("InteroperaBLE Identifier",
                                      scoped_device_id)

  return handle
end
